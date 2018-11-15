## Prerequisites
* docker

## Startup
clone repository

```console
docker build -t todoapp .
docker run -p 8000:80 -d todoapp
```

navigate to the `http://localhost:8000`