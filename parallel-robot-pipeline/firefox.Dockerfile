FROM ubuntu:20.04 as base

ENV BROWSER='headlessfirefox'
ENV BROWSER_OPTIONS=''

# Disable interactive configuration
ENV DEBIAN_FRONTEND='noninteractive'

WORKDIR /work
COPY ./entrypoint.sh ./requirements.txt /work/
RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        firefox \
        firefox-geckodriver && \
    pip install -r requirements.txt && \
    chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]


FROM base

COPY . .
