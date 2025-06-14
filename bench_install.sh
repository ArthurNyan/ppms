#!/bin/bash
set -e

PYTHON=python3.11

# Очистка старых окружений
echo "[INFO] Удаляю старые окружения и логи..."
rm -rf venv_pip venv_poetry venv_uv logs
mkdir -p logs

echo "[STEP] pip: создаю окружение и обновляю pip"
$PYTHON -m venv venv_pip
echo "[INFO] pip: активирую окружение"
source venv_pip/bin/activate
echo "[INFO] pip: обновляю pip"
pip install --upgrade pip > logs/pip_upgrade.log 2>&1
echo "[INFO] pip: начинаю установку зависимостей"
START=$(date +%s)
pip install -r requirements.txt > logs/pip_install.log 2>&1 && echo "[OK] pip: зависимости установлены" || echo "[ERROR] pip install error" > logs/pip_error.log
END=$(date +%s)
PIP_TIME=$((END-START))
deactivate
echo "[DONE] pip: установка завершена за $PIP_TIME сек."

echo "[STEP] poetry: создаю окружение и ставлю poetry"
$PYTHON -m venv venv_poetry
echo "[INFO] poetry: активирую окружение"
source venv_poetry/bin/activate
echo "[INFO] poetry: устанавливаю poetry"
pip install poetry > logs/poetry_install.log 2>&1
echo "[INFO] poetry: начинаю установку зависимостей"
START=$(date +%s)
poetry install > logs/poetry_run.log 2>&1 && echo "[OK] poetry: зависимости установлены" || echo "[ERROR] poetry install error" > logs/poetry_error.log
END=$(date +%s)
POETRY_TIME=$((END-START))
deactivate
echo "[DONE] poetry: установка завершена за $POETRY_TIME сек."

echo "[STEP] uv: создаю окружение и ставлю pipx/uv"
$PYTHON -m venv venv_uv
echo "[INFO] uv: активирую окружение"
source venv_uv/bin/activate
echo "[INFO] uv: устанавливаю pipx"
pip install pipx > logs/uv_pipx.log 2>&1 || echo "[ERROR] pipx install error" > logs/uv_error.log
echo "[INFO] uv: устанавливаю uv через pipx"
pipx install uv > logs/uv_install.log 2>&1 || echo "[ERROR] uv install error" > logs/uv_error.log
if command -v uv > /dev/null; then
  echo "[INFO] uv: начинаю установку зависимостей"
  START=$(date +%s)
  uv pip install -r requirements.txt > logs/uv_run.log 2>&1 && echo "[OK] uv: зависимости установлены" || echo "[ERROR] uv pip install error" > logs/uv_error.log
  END=$(date +%s)
  UV_TIME=$((END-START))
  echo "[DONE] uv: установка завершена за $UV_TIME сек."
else
  echo "[ERROR] uv not found" > logs/uv_error.log
  UV_TIME=-1
fi
deactivate

echo "[RESULT] ==== Итоги ====" | tee logs/result.log
echo "pip: $PIP_TIME сек" | tee -a logs/result.log
echo "poetry: $POETRY_TIME сек" | tee -a logs/result.log
echo "uv: $UV_TIME сек" | tee -a logs/result.log
if [ -f logs/pip_error.log ]; then cat logs/pip_error.log | tee -a logs/result.log; fi
if [ -f logs/poetry_error.log ]; then cat logs/poetry_error.log | tee -a logs/result.log; fi
if [ -f logs/uv_error.log ]; then cat logs/uv_error.log | tee -a logs/result.log; fi
