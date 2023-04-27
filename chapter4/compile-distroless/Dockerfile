# Build
FROM python:3-slim AS build-env
COPY testtask /memory
WORKDIR /memory
RUN pip install --no-cache-dir -r requirements.txt

# Deploy
FROM gcr.io/distroless/python3:nonroot
WORKDIR /memory
COPY --from=build-env /memory .
COPY --from=build-env /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages
ENTRYPOINT [ "python", "memory.py" ]
