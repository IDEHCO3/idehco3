FROM ubuntu:14.04
RUN apt-get update && apt-get install -y \
    python \
    python-dev \
    python-pip \
    python-psycopg2 \
    libpq-dev \
    libgdal-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-psycopg2 \
    install python3-scipy
 
RUN mkdir /code
WORKDIR /code
ADD requirements.txt requirements3.txt .
RUN pip install -r requirements.txt
RUN pip3 install -r requirements3.txt
