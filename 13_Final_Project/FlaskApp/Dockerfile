FROM python:3.6
EXPOSE 5002
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
CMD python -m flask run --host=0.0.0.0 --port=5002
