VIRTUAL_ENV ?= venv
REQUIREMENTS_BASE:=requirements.in
REQUIREMENTS:=requirements.txt
PIP=$(VIRTUAL_ENV)/bin/pip
PYTHON=$(VIRTUAL_ENV)/bin/python
ISORT=$(VIRTUAL_ENV)/bin/isort
FLAKE8=$(VIRTUAL_ENV)/bin/flake8
BLACK=$(VIRTUAL_ENV)/bin/black
PYTEST=$(VIRTUAL_ENV)/bin/pytest
UVICORN=$(VIRTUAL_ENV)/bin/uvicorn
PYTHON_MAJOR_VERSION=3
PYTHON_MINOR_VERSION=10
PYTHON_VERSION=$(PYTHON_MAJOR_VERSION).$(PYTHON_MINOR_VERSION)
PYTHON_MAJOR_MINOR=$(PYTHON_MAJOR_VERSION)$(PYTHON_MINOR_VERSION)
PYTHON_WITH_VERSION=python$(PYTHON_VERSION)
SOURCES=main.py


$(VIRTUAL_ENV):
	$(PYTHON_WITH_VERSION) -m venv $(VIRTUAL_ENV)

virtualenv: $(VIRTUAL_ENV)
	$(PIP) install -r $(REQUIREMENTS)

index.html: virtualenv
	$(PYTHON) main.py

lint/isort: virtualenv
	$(ISORT) --check-only --diff $(SOURCES)

lint/flake8: virtualenv
	$(FLAKE8) $(SOURCES)

lint/black: virtualenv
	$(BLACK) --check $(SOURCES)

format/isort: virtualenv
	$(ISORT) $(SOURCES)

format/black: virtualenv
	$(BLACK) --verbose $(SOURCES)

lint: lint/isort lint/flake8 lint/black

format: format/isort format/black

clean:
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type d -name "*.egg-info" -exec rm -r {} +

clean/all: clean
	rm -rf $(VIRTUAL_ENV)

$(REQUIREMENTS): $(VIRTUAL_ENV)
	$(PIP) install pip-tools
	$(PIP)-compile \
		--no-emit-index-url --no-emit-trusted-host --upgrade \
		--output-file $(REQUIREMENTS) \
		--build-isolation \
		$(REQUIREMENTS_BASE)

$(VENV_TEST): $(VENV_PROD) $(REQUIREMENTS_TEST) REVISION
	@venv/bin/pip install --index-url $(PYPI) -r $(REQUIREMENTS_TEST)
	@touch $@
