FROM python

WORKDIR /opt/flask

RUN pip3 install \
    flask \
    psycopg\
    psycopg-binary

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]