FROM multiarch/debian-debootstrap:armhf-stretch

# Install packages
RUN apt-get update
RUN apt-get install -y jq tzdata python3 python3-dev python3-pip \
        python3-six python3-pyasn1 libportaudio2 alsa-utils \
        portaudio19-dev libffi-dev libssl-dev libmpg123-dev
RUN pip3 install --upgrade pip
COPY requirements.txt /tmp
ADD .asoundrc /root/
WORKDIR /tmp
RUN pip3 install -r requirements.txt
RUN pip3 install --upgrade six
RUN pip3 install --no-cache-dir \
    cherrypy=="18.1.1" \
    google-assistant-grpc=="0.2.0" \
    google-assistant-library=="1.0.0" \
    google-assistant-sdk=="0.5.0" \
    google-auth=="1.6.3" \
    requests_oauthlib=="1.2.0"
RUN pip3 install --upgrade flask flask-jsonpify flask-restful \
        grpcio setuptools wheel pyopenssl
#RUN apt-get remove -y --purge python3-pip python3-dev
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

# Copy data
COPY run.sh /
COPY *.py /

RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
