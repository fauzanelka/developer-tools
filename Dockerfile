FROM ubuntu:jammy

LABEL org.opencontainers.image.source https://github.com/fauzanelka/developer-tools

RUN apt-get update && \
    apt-get install -y build-essential sudo vim ca-certificates curl gnupg

RUN install -m 0755 -d /etc/apt/keyrings

RUN curl  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN pip install git+https://github.com/aws/aws-cli@v2

RUN useradd --create-home --home-dir=/home/dev --uid=1000 --user-group --groups=sudo,docker --shell=/bin/bash dev

RUN echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dev

USER dev

WORKDIR /home/dev
