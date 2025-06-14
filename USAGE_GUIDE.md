# Руководство по использованию виртуальных сред и инструментов

## 1. pip (venv_pip)

**Активация среды:**

```bash
source venv_pip/bin/activate
```

**Запуск кода:**

```bash
python script.py
```

**Установка новых пакетов:**

```bash
pip install <package>
```

**Деактивация:**

```bash
deactivate
```

---

## 2. poetry (venv_poetry)

**Активация среды:**

```bash
source venv_poetry/bin/activate
```

**Запуск кода:**

```bash
python script.py
# или через poetry
poetry run python script.py
```

**Установка новых пакетов:**

```bash
poetry add <package>
```

**Деактивация:**

```bash
deactivate
```

---

## 3. uv (venv_uv)

**Активация среды:**

```bash
source venv_uv/bin/activate
```

**Запуск кода:**

```bash
python script.py
```

**Установка новых пакетов:**

```bash
uv pip install <package>
```

**Деактивация:**

```bash
deactivate
```

---

## 4. pipenv

**Активация среды:**

```bash
pipenv shell
```

**Запуск кода:**

```bash
python script.py
```

**Установка новых пакетов:**

```bash
pipenv install <package>
```

**Деактивация:**

```bash
exit
```

**Где хранится окружение:**

- pipenv создаёт виртуальное окружение в системной папке (узнать путь: `pipenv --venv`).
- Файлы зависимостей: `Pipfile`, `Pipfile.lock`.

---

## 5. pyenv

**pyenv** — это менеджер версий Python, а не окружений.

**Проверить доступные версии:**

```bash
pyenv versions
```

**Сменить версию Python для проекта:**

```bash
pyenv local 3.11.9
```

**Далее можно создавать окружения и работать с любым инструментом (pip, poetry, uv, pipenv) уже на выбранной версии Python.**

---

## 6. Просмотр логов установки

Все логи установки и ошибок сохраняются в папке `logs/`:

- `pip_install.log`, `poetry_run.log`, `uv_run.log`, `pipenv_install.log` — подробные логи установки.
- `result.log` — итоговая таблица времени и ошибок.
- `pyenv_versions.log` — список версий Python через pyenv.

---

## 7. Удаление сред

```bash
rm -rf venv_pip venv_poetry venv_uv Pipfile Pipfile.lock
pipenv --rm  # если нужно удалить pipenv-окружение
```

---

## 8. Советы

- Активируй только одну среду одновременно.
- Для pipenv не нужно вручную создавать venv — всё делается через pipenv.
- Для pyenv можно быстро переключаться между версиями Python и повторять тесты.
