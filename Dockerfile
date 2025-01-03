FROM python:3.9-slim
COPY myapp.py /app/myapp.py
WORKDIR /app
CMD ["python", "myapp.py"]
