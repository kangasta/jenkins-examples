FROM python:3-slim-buster AS base

ENV BROWSER='headlesschrome'
ENV BROWSER_OPTIONS='add_argument("--no-sandbox"); add_argument("--disable-gpu"); add_argument("--disable-build-check")'

# Disable interactive configuration
ENV DEBIAN_FRONTEND='noninteractive'

WORKDIR /work
COPY ./entrypoint.sh ./requirements.txt /work/
RUN apt-get update && \
    apt-get install -y \
        chromium \
        chromium-driver && \
    pip install -r requirements.txt && \
    chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]


FROM base

COPY . .
