FROM nvidia/cuda:11.6.0-base-ubuntu20.04
LABEL maintainer="José Antonio Perdiguero López <perdy@perdy.io>"

ENV APP=barrenero-miner-trex
ENV BASE_PATH=/srv/apps/$APP/
ENV APP_PATH=$BASE_PATH/app/
ENV LOGS_PATH=$BASE_PATH/logs/
ENV LC_ALL='C.UTF-8' PYTHONIOENCODING='utf-8'

# Install system dependencies
ENV RUNTIME_PACKAGES 'python3 python3-pip'
RUN apt-get update -m && \
    apt-get install -y --no-install-recommends $RUNTIME_PACKAGES && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

# Create project dirs
RUN mkdir -p $BASE_PATH $APP_PATH $LOGS_PATH
WORKDIR $BASE_PATH

# Install python requirements
COPY pyproject.toml poetry.lock $BASE_PATH
RUN python3 -m pip install --no-cache-dir --upgrade poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-dev

# Install miner
ENV MINER_VERSION="0.25.2"
ENV BUILD_PACKAGES curl
RUN apt-get update && \
    apt-get install -y --no-install-recommends $BUILD_PACKAGES && \
    curl -Ls https://github.com/trexminer/T-Rex/releases/download/0.25.2/t-rex-0.25.2-linux.tar.gz | tar xvz -C /tmp && \
    mv /tmp/t-rex $BASE_PATH && \
    chmod +x $BASE_PATH/t-rex && \
    apt-get purge -y --auto-remove $BUILD_PACKAGES && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

# Copy application
COPY src/ $APP_PATH

ENTRYPOINT ["python3", "app"]
