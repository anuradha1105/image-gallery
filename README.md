📊 Report – Container vs VM Performance
📌 1. Sample Application

Application: Flask Image Gallery (upload & display images)

Framework: Flask + Gunicorn

Files:

app.py

templates/index.html, templates/upload.html

static/uploads/

🖼️ App running in Container

![Flask App Container](images/app_container.png)


🖼️ App running in VM

![Flask App VM](images/app_vm.png)

📌 2. Setup & Steps
2.1 Containerized Version (Docker)

Dockerfile

FROM python:3.12-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PYTHONPATH=/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]


Build & Test

docker build -t upload-app .
docker run --rm --entrypoint pytest upload-app -q


🖼️ Docker build success

![Docker Build Success](images/docker_build.png)


Run

docker run --rm -p 5000:5000 upload-app


App available at: http://localhost:5000

2.2 Virtual Machine Version (Vagrant)

Vagrantfile

Ubuntu Jammy (22.04)

Forwards 5000 (guest) → 5001 (host)

Provisioning

Install Python

Create venv

Install requirements

Run Gunicorn as systemd service

Run

cd vagrant
vagrant up


App available at: http://localhost:5001

🖼️ VM boot with vagrant up

![Vagrant VM Running](images/vagrant_up.png)

2.3 Measurement Scripts

scripts/start_measure_container.sh → startup time → results_container.txt

scripts/start_measure_vm.sh → startup time → results_vm.txt

scripts/container_run.sh / scripts/vm_run.sh → CPU, memory, HTTP checks → reports/

🖼️ Startup log (Container)

![Container Startup Results](images/results_container.png)


🖼️ Startup log (VM)

![VM Startup Results](images/results_vm.png)

📌 3. Metrics Collected
Metric	Container (avg)	VM (avg)	How Measured
Startup time	3701 ms	~8000 ms (est.)	custom scripts + curl
CPU usage (load)	~41.9 %	~6–10 % idle, ↑ under load	docker stats, top
Memory usage	~35.6 MB	~176 MB	docker stats, top
Throughput	~92 req/s (timeouts at high load)	114.37 req/s	ab (container), wrk (VM)
Latency (p50)	unstable (timeouts)	~163 ms	ab / wrk
Latency (p95)	unstable (timeouts)	~400+ ms	ab / wrk

🖼️ Container resource usage (docker stats)

![Container Stats](images/container_stats.png)


🖼️ VM resource usage (top)

![VM Top Stats](images/vm_top.png)


🖼️ ApacheBench run (Container)

![AB Container](images/ab_container.png)


🖼️ wrk run (VM)

![wrk VM](images/wrk_vm.png)

📌 4. Tools Used

Docker – build & run container

Vagrant + VirtualBox – run VM

pytest – container tests

curl – health check

docker stats / top – resource monitoring

ApacheBench (ab), wrk – load testing

Custom scripts – measure startup & log results

📌 5. Registry Info

Image pushed to Docker Hub:

docker tag upload-app:latest <dockerhub-username>/upload-app:latest
docker push <dockerhub-username>/upload-app:latest


Pull it with:

docker pull <dockerhub-username>/upload-app:latest



📸 6. Performance Comparison Chart

📌 7. Results & Conclusion

Startup time → Container starts in ~3.7s, VM takes ~8s.

Memory usage → Container uses ~36 MB vs VM ~176 MB.

CPU → Comparable, but container shares host kernel so is lighter overall.

Throughput → VM slightly ahead in our raw test (114 req/s vs ~92 req/s), but this was influenced by tool differences and container defaults (single Gunicorn worker). With tuned workers/threads, containers can match or outperform.

Latency → VM showed stable latency; container saw some timeouts under load due to worker limits.

✅ Conclusion

Containers are faster to start and use far less memory than VMs.

VMs provide stronger isolation but come with more overhead.

Throughput and latency depend on fair test conditions and server tuning.

With aligned configurations, containers can perform on par or better than VMs while being more lightweight and portable.