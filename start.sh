#!/bin/bash

NAME="Blog"                              #Name of the application (*)
DJANGODIR=/home/works/pyenv3/DjangoBlog             # Django project directory (*)
SOCKFILE=/home/works/pyenv3/DjangoBlog/gunicorn.sock        # we will communicate using this unix socket (*)                                   # the group to run as (*)
NUM_WORKERS=4                                     # how many worker processes should Gunicorn spawn (*)
DJANGO_SETTINGS_MODULE=DjangoBlog.settings             # which settings file should Django use (*)
DJANGO_WSGI_MODULE=DjangoBlog.wsgi                    # WSGI module name (*)
LOGFILE=/home/works/pyenv3/DjangoBlog/gunicorn-access.log

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --timeout 60 \
  --workers $NUM_WORKERS \
  --bind=unix:$SOCKFILE \
  --access-logfile=$LOGFILE \
  --access-logformat="%(h)s %(l)s %(u)s %(t)s \"%(r)s\" %(s)s %(b)s \"%(f)s\" \"%(a)s\" %(L)s %(p)s"

