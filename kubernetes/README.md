# DOCKER TO KUBERNETES MIGRATION & MICROSERVICES ARCHITECTURE

## Introduction 
This project is a simple **Image Gallery Web Application** built using **Flask**, containerized using **Docker**, and deployed on a **Kubernetes cluster** (kind).  
The app allows users to upload and view images through a clean web interface.

- Re-use the existing Dockerized application
- Migrate it to a Kubernetes environment
- Break it into a microservices-style architecture
- Deploy it using Kubernetes objects (Deployment, Service, Namespace)
- Provide screenshots of the Kubernetes running state

---

## 🚀 Features
- Upload image files (JPG, PNG, JPEG, GIF, WEBP)
- Auto-gallery based display
- Flask backend + HTML templates
- Containerized using Docker
- Deployed using Kubernetes (Deployment + Service)
- Scalable microservices structure (1 or more replicas)

---

## 📦 Technologies Used
- **Kind (Kubernetes in Docker)**
- **kubectl**

---


## BEFORE: Docker Architecture


<img width="642" height="491" alt="image" src="https://github.com/user-attachments/assets/d44a853d-5dcf-4e92-a80f-4e442bc37d11" />


## Description
- Single container.
- No orchestration, no auto-recovery, no scaling.
- Networking handled directly via docker run -p 5000:5000.
- Local host filesystem used for uploads (optional: -v static/uploads:/app/static/uploads).
- If container dies → app goes down.


Originally, the application was run using:
docker build -t upload-app .

```
docker run --rm -p 5000:5000 upload-app
```

<img width="1700" height="1182" alt="image" src="https://github.com/user-attachments/assets/2028760d-6c4c-436d-8c28-2f8a71b2fb96" />

The assignment required extending this into a scalable Kubernetes deployment.





## AFTER: Kubernetes Microservices Architecture
- Separation of concerns
- Independent container orchestration
- Scaling at pod level
- Service discovery
- Declarative deployments

For this assignment, the Image Gallery app is treated as a single microservice:
gallery-service 


### Kubernetes Architecture Diagram

<img width="429" height="573" alt="image" src="https://github.com/user-attachments/assets/daaf5a62-244e-4f81-a372-ab2a8f750c65" />



## Kubernetes Components
1. Namespace

2. Deployment

3. Service (NodePort)

## How the app is accessed:
kubectl port-forward svc/gallery-service -n image-gallery 8080:80
Browser: http://localhost:8080

<img width="2024" height="1430" alt="image" src="https://github.com/user-attachments/assets/6cb08aa3-cf39-4ed7-9b07-f75bba27dc70" />


6. Kubernetes Deployment Steps (Executed)
- kind create cluster --name img-gallery-cluster
- kind load docker-image upload-app:latest --name img-gallery-cluster
- kubectl apply -f namespace.yaml
- kubectl apply -f gallery-deployment.yaml
- kubectl apply -f gallery-service.yaml
- kubectl get pods -n image-gallery
- kubectl get svc -n image-gallery
- kubectl port-forward svc/gallery-service -n image-gallery 8080:80
- Access application at http:/localhost:8080


<img width="1182" height="354" alt="image" src="https://github.com/user-attachments/assets/9c6a9e43-f500-409a-9f7d-20c39607f325" />


<img width="1704" height="406" alt="image" src="https://github.com/user-attachments/assets/02f5e9aa-56ac-40f8-ae17-f2fbd5644527" />

Added one more pod 

<img width="1450" height="396" alt="image" src="https://github.com/user-attachments/assets/88fd08dc-ec81-424c-b950-31955219c3ee" />


## 📁 Repository Structure
```
image-gallery/
│
├── app.py
├── Dockerfile
├── requirements.txt
├── static/
├── templates/
│
└── kubernetes/
     ├── namespace.yaml
     ├── gallery-deployment.yaml
     └── gallery-service.yaml
```

---




