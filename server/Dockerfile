FROM python:3.10.16-slim
COPY requirements.txt /app/requirements.txt
COPY myapp.py /app/myapp.py
WORKDIR /app
RUN pip3 install -r requirements.txt
CMD ["python", "myapp.py"]