FROM python:3.7

RUN git clone https://github.com/LamAnnieV/deploy_7.git

WORKDIR deploy_7

RUN pip install pip --upgrade

RUN pip install -r requirements.txt

RUN pip install mysqlclient

RUN pip install gunicorn

RUN python database.py

EXPOSE 8000

ENTRYPOINT python -m gunicorn app:app -b 0.0.0.0
