# Makefile for development and deployment

.PHONY: setup test run clean deploy

setup:
	pip install -r requirements.txt

test:
	python -m pytest src/app_test.py -v

run:
	python src/app.py

clean:
	rm -rf __pycache__
	deploy:
	gcloud builds submit --config cloudbuild.yaml .