FROM python:alpine

# Get latest root certificates
RUN apk add --no-cache ca-certificates && update-ca-certificates

# Install the required packages
RUN pip install --no-cache-dir redis flower

# PYTHONUNBUFFERED: Force stdin, stdout and stderr to be totally unbuffered. (equivalent to `python -u`)
# PYTHONHASHSEED: Enable hash randomization (equivalent to `python -R`)
# PYTHONDONTWRITEBYTECODE: Do not write byte files to disk, since we maintain it as readonly. (equivalent to `python -B`)
ENV PYTHONUNBUFFERED=1 PYTHONHASHSEED=random PYTHONDONTWRITEBYTECODE=1

# Default port
EXPOSE 5555

# Variables with default that can be overruled by environment vars during docker run.
ENV       REDIS_HOST redis
ENV       REDIS_PORT 6379
ENV       REDIS_DATABASE 0
ENV       CELERY_APP adminset

# Run as a non-root user by default, run as user with least privileges.
USER nobody

# ENTRYPOINT ["flower"]
CMD       flower -A $CELERY_APP --address=0.0.0.0 --port=5555 --broker=redis://$REDIS_HOST:$REDIS_PORT/$REDIS_DATABASE
