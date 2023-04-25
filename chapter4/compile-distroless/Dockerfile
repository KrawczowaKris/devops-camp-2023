# Build
FROM python:3-slim AS build-env
COPY testtask /memory
WORKDIR /memory
RUN pip install --no-cache-dir -r requirements.txt

# Deploy
FROM gcr.io/distroless/python3:debug
WORKDIR /memory
COPY --from=build-env /memory .
COPY --from=build-env /usr/local /usr/local
ENTRYPOINT [ "python", "memory.py" ]
