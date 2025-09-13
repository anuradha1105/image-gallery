FROM python:3.12-slim

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

# install deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy project
COPY . .

EXPOSE 5000
# root layout: app.py defines `app = Flask(__name__)`
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
