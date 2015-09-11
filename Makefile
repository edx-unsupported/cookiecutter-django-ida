.DEFAULT_GOAL := test

.PHONY: requirements test

requirements:
	pip install -r requirements.txt

test:
	# Remove any existing data
	rm -rf repo_name

	# Create a new project with the default values
	cookiecutter . --no-input

	# Execute the project's tests
	cd repo_name && make requirements
	cd repo_name && python manage.py makemigrations
	cd repo_name && make migrate
	cd repo_name && make validate

	# Ensure translations can be compiled
	cd repo_name && make fake_translations

	# Ensure documentation can be compiled
	cd repo_name/docs && make html
