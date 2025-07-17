FROM python:3.12-slim AS build

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/builder -r requirements.txt
COPY . .

FROM python:3.12-slim

WORKDIR /app

COPY --from=build /app/builder /builder
COPY --from=build /app ./

RUN chmod +x ./commands.sh && \
    pip install --no-cache /builder/* && \
    rm -rf /builder

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]






