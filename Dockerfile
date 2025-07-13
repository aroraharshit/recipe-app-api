FROM python:3.9-alpine3.13
LABEL maintainer="Harshit Arora"

# <<< CHANGED: Added ARG for conditional dev install >>>
ARG DEV=false

# <<< CHANGED: Fixed env assignment syntax >>>
ENV PYTHONUNBUFFERED=1 \
    PATH="/py/bin:$PATH" 

WORKDIR /app

COPY ./requirements.txt /tmp/requirements.txt  
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app



RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --no-cache postgresql-client && \  
    apk add --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \  
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser --disabled-password --no-create-home django-user

USER django-user

EXPOSE 8000
