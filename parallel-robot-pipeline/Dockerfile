FROM python:3-slim-stretch AS base

# Disable interactive configuration
ENV DEBIAN_FRONTEND='noninteractive'

WORKDIR /work
COPY ./entrypoint.sh ./requirements.txt /work/
RUN pip install -r requirements.txt && \
    chmod +x entrypoint.sh


FROM ubuntu:20.04 as firefox-base

# Disable interactive configuration
ENV DEBIAN_FRONTEND='noninteractive'

WORKDIR /work
COPY ./entrypoint.sh ./requirements.txt /work/
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip install -r requirements.txt && \
    chmod +x entrypoint.sh


FROM base as chromium

ENV BROWSER='headlesschrome'
ENV BROWSER_OPTIONS='add_argument("--no-sandbox"); add_argument("--disable-gpu")'

RUN apt-get update && \
    apt-get install -y chromium chromium-driver
COPY . /work

ENTRYPOINT ["./entrypoint.sh"]


FROM firefox-base as firefox

ENV BROWSER='headlessfirefox'
ENV BROWSER_OPTIONS=''

RUN apt-get install -y firefox firefox-geckodriver
COPY . /work

ENTRYPOINT ["./entrypoint.sh"]