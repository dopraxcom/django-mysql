#!/bin/bash
source /venv/bin/activate
cd /app

echo "----- Collect static files ------ " 
python manage.py collectstatic --noinput

echo "-----------Apply migration--------- "
python manage.py makemigrations 
python manage.py migrate

echo "-----------Run gunicorn--------- "
gunicorn -b :5000 --reload --access-logfile - --error-logfile - myapp.wsgi:application --pythonpath "/app,/app/myapp/"
