FROM python:3.10.16-slim
RUN pip install -r requirements.txt
COPY myapp.py /app/myapp.py
WORKDIR /app
CMD ["python", "myapp.py"]
