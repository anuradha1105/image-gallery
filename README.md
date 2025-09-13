# VM vs Container – Image Gallery App

## How to run (summary)
- Container:
  - `docker build --target test -t upload-app:test -f docker/Dockerfile .`
  - `docker build -t upload-app:latest -f docker/Dockerfile .`
  - `docker run --rm -p 5000:5000 -v "$(pwd)/app/static/uploads:/app/app/static/uploads" upload-app:latest`
- VM:
  - `cd vagrant && vagrant up` (app at http://localhost:5001)

## Startup time (ms, average of N runs)
- Container: ___
- VM: ___

## Memory / CPU under load (peak during ab -n 5000 -c 50)
- Container: CPU ___%, MEM ___
- VM: CPU ___%, RSS ___

## Throughput / Latency (ab outputs)
- Container: RPS ___, p50 ___ ms, p95 ___ ms
- VM: RPS ___, p50 ___ ms, p95 ___ ms

## Screenshots Checklist
- docker build / run
- docker stats during load
- vagrant up & systemctl status
- top/htop in VM during load
- ab results for both
- startup measurement outputs

## Notes
- Container expected faster startup & lower memory; CPU comparable.
# image-gallery
