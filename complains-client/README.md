# Complains Client

## Run with Docker
```
  # build container
  podman build --tag "complains-client:latest" .

  # run container
  podman run -it -p 3000:80 "complains-client:latest"
```

Warning: Docker without SSL, use a reverse proxy or modify the Dockerfile
