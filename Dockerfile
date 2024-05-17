ARG PY_VERSION=3.12
FROM python:${PY_VERSION}-alpine AS builder
ARG PY_VERSION

WORKDIR /app

COPY requirements.txt ./

RUN apk add libmagic && \
  pip install --no-cache-dir -r requirements.txt && \
  find /usr/local/lib/python${PY_VERSION}/site-packages \( -type d -a -name test -o -name tests \) -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' \+

FROM python:${PY_VERSION}-alpine
ARG PY_VERSION

COPY --from=builder /usr/local/lib/python${PY_VERSION}/site-packages /usr/local/lib/python${PY_VERSION}/site-packages/
COPY md2sf.py /usr/local/bin

ENTRYPOINT ["/usr/local/bin/md2sf.py"]


