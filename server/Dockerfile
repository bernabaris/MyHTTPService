FROM python:3.10.16-slim
COPY server/requirements.txt /app/requirements.txt
COPY server/myapp.py /app/myapp.py
WORKDIR /app
RUN pip3 install -r requirements.txt
CMD ["python", "myapp.py"]