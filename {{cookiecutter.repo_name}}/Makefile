.DEFAULT_GOAL := help

.PHONY: help clean piptools requirements ci_requirements dev_requirements \
        validation_requirements doc_requirementsprod_requirements static shell \
        test coverage isort_check isort style lint quality pii_check validate \
        migrate html_coverage upgrade extract_translation dummy_translations \
        compile_translations fake_translations  pull_translations \
        push_translations start-devstack open-devstack  pkg-devstack \
        detect_changed_source_translations validate_translations check_keywords

define BROWSER_PYSCRIPT
import os, webbrowser, sys
try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT
BROWSER := python -c "$$BROWSER_PYSCRIPT"

# Generates a help message. Borrowed from https://github.com/pydanny/cookiecutter-djangopackage.
help: ## display this help message
	@echo "Please use \`make <target>\` where <target> is one of"
	@awk -F ':.*?## ' '/^[a-zA-Z]/ && NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

clean: ## delete generated byte code and coverage reports
	find . -name '*.pyc' -delete
	coverage erase
	rm -rf assets
	rm -rf pii_report

piptools: ## install pinned version of pip-compile and pip-sync
	pip install -r requirements/pip-tools.txt

requirements: piptools dev_requirements ## sync to default requirements

ci_requirements: validation_requirements ## sync to requirements needed for CI checks

dev_requirements: ## sync to requirements for local development
	pip-sync -q requirements/dev.txt

validation_requirements: ## sync to requirements for testing & code quality checking
	pip-sync -q requirements/validation.txt

doc_requirements:
	pip-sync -q requirements/doc.txt

prod_requirements: ## install requirements for production
	pip-sync -q requirements/production.txt

static: ## generate static files
	python manage.py collectstatic --noinput

shell: ## run Django shell
	python manage.py shell

test: clean ## run tests and generate coverage report
	pytest

# To be run from CI context
coverage: clean
	pytest --cov-report html
	$(BROWSER) htmlcov/index.html

isort_check: ## check that isort has been run
	isort --check-only -rc {{cookiecutter.repo_name}}/

isort: ## run isort to sort imports in all Python files
	isort --recursive --atomic {{cookiecutter.repo_name}}/

style: ## run Python style checker
	pylint --rcfile=pylintrc {{cookiecutter.repo_name}} *.py

lint: ## run Python code linting
	pylint --rcfile=pylintrc {{cookiecutter.repo_name}} *.py

quality: style isort_check lint ## check code style and import sorting, then lint

pii_check: ## check for PII annotations on all Django models
	DJANGO_SETTINGS_MODULE={{cookiecutter.repo_name}}.settings.test \
	code_annotations django_find_annotations --config_file .pii_annotations.yml --lint --report --coverage

check_keywords: ## Scan the Django models in all installed apps in this project for restricted field names
	python manage.py check_reserved_keywords --override_file db_keyword_overrides.yml

validate: test quality pii_check check_keywords ## run tests, quality, and PII annotation checks

migrate: ## apply database migrations
	python manage.py migrate

html_coverage: ## generate and view HTML coverage report
	coverage html && open htmlcov/index.html

upgrade: export CUSTOM_COMPILE_COMMAND=make upgrade
upgrade: piptools ## update the requirements/*.txt files with the latest packages satisfying requirements/*.in
	# Make sure to compile files after any other files they include!
	pip-compile --upgrade -o requirements/pip-tools.txt requirements/pip-tools.in
	pip-compile --upgrade -o requirements/base.txt requirements/base.in
	pip-compile --upgrade -o requirements/test.txt requirements/test.in
	pip-compile --upgrade -o requirements/doc.txt requirements/doc.in
	pip-compile --upgrade -o requirements/quality.txt requirements/quality.in
	pip-compile --upgrade -o requirements/validation.txt requirements/validation.in
	pip-compile --upgrade -o requirements/dev.txt requirements/dev.in
	pip-compile --upgrade -o requirements/production.txt requirements/production.in

extract_translations: ## extract strings to be translated, outputting .mo files
	python manage.py makemessages -l en -v1 -d django
	python manage.py makemessages -l en -v1 -d djangojs

dummy_translations: ## generate dummy translation (.po) files
	cd {{cookiecutter.repo_name}} && i18n_tool dummy

compile_translations: # compile translation files, outputting .po files for each supported language
	python manage.py compilemessages

fake_translations: ## generate and compile dummy translation files

pull_translations: ## pull translations from Transifex
	tx pull -af --mode reviewed

push_translations: ## push source translation files (.po) from Transifex
	tx push -s

start-devstack: ## run a local development copy of the server
	docker-compose --x-networking up

open-devstack: ## open a shell on the server started by start-devstack
	docker exec -it {{cookiecutter.repo_name}} /edx/app/{{cookiecutter.repo_name}}/devstack.sh open

pkg-devstack: ## build the {{cookiecutter.repo_name}} image from the latest configuration and code
	docker build -t {{cookiecutter.repo_name}}:latest -f docker/build/{{cookiecutter.repo_name}}/Dockerfile git://github.com/edx/configuration

detect_changed_source_translations: ## check if translation files are up-to-date
	cd {{cookiecutter.repo_name}} && i18n_tool changed

validate_translations: fake_translations detect_changed_source_translations ## install fake translations and check if translation files are up-to-date

docker_build:
	docker build . -f Dockerfile -t openedx/{{cookiecutter.repo_name}}
	docker build . -f Dockerfile --target newrelic -t openedx/{{cookiecutter.repo_name}}:latest-newrelic

travis_docker_tag: docker_build
	docker tag openedx/{{cookiecutter.repo_name}} openedx/{{cookiecutter.repo_name}}:$$TRAVIS_COMMIT
	docker tag openedx/{{cookiecutter.repo_name}}:latest-newrelic openedx/{{cookiecutter.repo_name}}:$$TRAVIS_COMMIT-newrelic

travis_docker_auth:
	echo "$$DOCKER_PASSWORD" | docker login -u "$$DOCKER_USERNAME" --password-stdin

travis_docker_push: travis_docker_tag travis_docker_auth ## push to docker hub
	docker push 'openedx/{{cookiecutter.repo_name}}:latest'
	docker push "openedx/{{cookiecutter.repo_name}}:$$TRAVIS_COMMIT"
	docker push 'openedx/{{cookiecutter.repo_name}}:latest-newrelic'
	docker push "openedx/{{cookiecutter.repo_name}}:$$TRAVIS_COMMIT-newrelic"
