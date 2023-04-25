### Build
Image building:
```make build

[+] Building 2.5s (15/15) FINISHED                                                                                                                                       
 => [internal] load .dockerignore                                                                                                                                              0.0s
 => => transferring context: 2B                                                                                                                                                0.0s
 => [internal] load build definition from Dockerfile                                                                                                                           0.0s
 => => transferring dockerfile: 344B                                                                                                                                           0.0s
 => [internal] load metadata for gcr.io/distroless/python3:debug                                                                                                               1.3s
 => [internal] load metadata for docker.io/library/python:3-slim                                                                                                               2.5s
 => [auth] library/python:pull token for registry-1.docker.io                                                                                                                  0.0s
 => [stage-1 1/4] FROM gcr.io/distroless/python3:debug@sha256:29da1c25f3bfc13a3bc750e875e18587139688472ba5869ad6ff41059d0cdbde                                                 0.0s
 => [internal] load build context                                                                                                                                              0.0s
 => => transferring context: 112B                                                                                                                                              0.0s
 => [build-env 1/4] FROM docker.io/library/python:3-slim@sha256:286f2f1d6f2f730a44108656afb04b131504b610a6cb2f3413918e98dabba67e                                               0.0s
 => CACHED [stage-1 2/4] WORKDIR /memory                                                                                                                                       0.0s
 => CACHED [build-env 2/4] COPY testtask /memory                                                                                                                               0.0s
 => CACHED [build-env 3/4] WORKDIR /memory                                                                                                                                     0.0s
 => CACHED [build-env 4/4] RUN pip install --no-cache-dir -r requirements.txt                                                                                                  0.0s
 => CACHED [stage-1 3/4] COPY --from=build-env /memory .                                                                                                                       0.0s
 => CACHED [stage-1 4/4] COPY --from=build-env /usr/local /usr/local                                                                                                           0.0s
 => exporting to image                                                                                                                                                         0.0s
 => => exporting layers                                                                                                                                                        0.0s
 => => writing image sha256:68547868fd20f6990c13cfa462dd5342f4e31b15597e5a62f8ebbc617901a4ef                                                                                   0.0s
 => => naming to docker.io/library/memory-test                                                                                                                                 0.0s
```

### Run
Run with memory limit:
```make run memory_limit=100M

Usage over time: [22.19140625, 22.29296875, 36.63671875, 51.22265625, 66.09375, 80.7890625, 95.2265625, 22.4140625]
Peak usage: 95.2265625
```
If there is not enough memory:
```make run memory_limit=30M

{exited false false false true false 0 137  2023-04-25T10:46:47.347929667Z 2023-04-25T10:46:47.766722563Z <nil>}

```

### Hadolint installation
Hadolint checks your Dockerfiles.
```brew install hadolint
```
Start check:
```hadolint Dockerfile
```

We need to run the following command to pre-commit:
```pre-commit install
```
