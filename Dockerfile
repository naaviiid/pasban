ARG PYTHON_VERSION=3.12

FROM python:$PYTHON_VERSION-slim AS build

ENV PYTHONUNBUFFERED=1

WORKDIR /code

ARG XRAY_VERSION=latest
COPY ./scripts/install_xray.sh /tmp/install_xray.sh
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential curl unzip gcc python3-dev libpq-dev \
    && bash /tmp/install_xray.sh "$XRAY_VERSION" \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /code/
# setuptools>=81 drops pkg_resources, which APScheduler 3.9 still imports
RUN python3 -m pip install --upgrade pip "setuptools<81" \
    && pip install --no-cache-dir --upgrade -r /code/requirements.txt

FROM python:$PYTHON_VERSION-slim

ENV PYTHON_LIB_PATH=/usr/local/lib/python${PYTHON_VERSION%.*}/site-packages
WORKDIR /code

RUN rm -rf $PYTHON_LIB_PATH/*

COPY --from=build $PYTHON_LIB_PATH $PYTHON_LIB_PATH
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/share/xray /usr/local/share/xray

COPY . /code

RUN ln -s /code/pasban-cli.py /usr/bin/pasban-cli \
    && chmod +x /usr/bin/pasban-cli \
    && pasban-cli completion install --shell bash

CMD ["bash", "-c", "alembic upgrade head; python main.py"]
