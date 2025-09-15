# 📊 Image Gallery – Container vs VM Performance Comparison

## 📌 Project Overview
This project implements a simple **Flask Image Gallery** application where users can upload and view images.  
The goal was to **package and run the app** in two environments:  
- **Docker container**  
- **Vagrant VM**  

Then compare their performance in terms of **startup time, CPU usage, memory usage, throughput, and latency**.


## 🗂️ Repository Structure
<img width="391" height="466" alt="repo" src="https://github.com/user-attachments/assets/d23b3e6e-cb84-44f4-9061-1cab49f491dd" />


---

## 🚀 Running the Application

### 🔹 Container (Docker)
Build & test:
```bash
docker build -t upload-app .
docker run --rm --entrypoint pytest upload-app -q
```
Run:
```
docker run --rm -p 5000:5000 \
  -v "$(pwd)/static/uploads:/app/static/uploads" \
  --name upload-app upload-app
```
App available at 👉 http://localhost:5000

🔹 VM (Vagrant)

Start VM:
```
cd vagrant
vagrant up
vagrant ssh -c "systemctl status flaskapp --no-pager -l | head -n 15"

```
App URL → http://localhost:5001

🧪 Measurement Process
Startup time
Measured using scripts:
- *scripts/start_measure_container.sh
- *scripts/start_measure_vm.sh
- *Scripts use date +%s%3N to capture milliseconds, restart service/container, and curl until HTTP 200 OK.

CPU & Memory
- *Container: docker stats*
- *VM: top or htop inside VM*

Throughput & Latency
Used ApacheBench (ab) with:

