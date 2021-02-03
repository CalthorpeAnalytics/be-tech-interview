# This is a simple Dockerfile to use while developing
# It's not suitable for production
#
# It allows you to run both flask and celery if you enabled it
# for flask: docker run --env-file=.flaskenv image flask run
# for celery: docker run --env-file=.flaskenv image celery worker -A myapi.celery_app:app
#
# note that celery will require a running broker and result backend
FROM python:3.8.2

RUN mkdir /code
WORKDIR /code

RUN pip install --no-cache-dir --upgrade \
        pip==21.0.1 \
        poetry-core==1.0.0 \
        poetry==1.1.4 \
    && rm -rf ~/.cache/pip

COPY poetry.lock pyproject.toml ./
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

COPY geoeditor geoeditor/
RUN pip install .

COPY migrations migrations/
COPY tox.ini mypy.ini ./

EXPOSE 8080
