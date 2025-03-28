FROM python:3.11-slim as builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

RUN mkdir -p /install && \
    cp -r /root/.local /install

FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /install/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["python", "app/manage.py", "runserver", "0.0.0.0:8000"]