# Deploy app to Swarm environment #

Application is simple container that prints its build id and its hostname.

## Create Docker image ##

### Flask image ###

```dockerfile
FROM hypriot/rpi-alpine-scratch

RUN apk update && \
apk upgrade && \
apk add bash py-pip \
    && pip install --upgrade pip \
    && pip install flask \
    && rm -rf /var/cache/apk/*

CMD ["/bin/bash"]
```

**Build**

``` bash
docker build -t akrevev/rpi3b-alpine-flask .
```

## Deploy app to Swarm cluster ##

**Create docker image with app**

```dockerfile
FROM akrevev/rpi3b-alpine-flask

ADD flask-app.py /apps/flask-app.py
EXPOSE 5000
CMD ["python", "/apps/flask-app.py"]
```

``` bash
docker build -t akrevev/rpi3b-demoflask .
```

**Run Service**
``` bash
docker service create --replicas 1 --publish 80:5000 --name simpleflask akrevev/rpi3b-demoflask
```

**Inspect Service**

``` bash
docker service ls
docker service inspect simpleflask
```
