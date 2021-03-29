#!/bin/bash
source /venv/bin/activate
cd /app/source
export DB_HOST = localhost
export DB_PORT = 3306
echo "----- Collect static files ------ " 
python manage.py collectstatic --noinput
DB_READY=$(nc -vz $DB_HOST $DB_PORT  2>&1 | grep open | wc -l)
while [ $DB_READY -eq 0 ];
do
  echo "Database Initializing";
  sleep 10
  DB_READY=$(nc -vz $DB_HOST $DB_PORT  2>&1 | grep open | wc -l)  
done
echo "Database ready"
echo "-----------Apply migration--------- "
python manage.py makemigrations 
python manage.py migrate


gunicorn -b :5000 --reload --access-logfile - --error-logfile - myapp.wsgi:application --pythonpath "/app/source,/app/source/myapp/"
