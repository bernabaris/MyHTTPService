FROM python:3.10.16-slim
COPY ../myapp.py /app/myapp.py
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "myapp.py"]