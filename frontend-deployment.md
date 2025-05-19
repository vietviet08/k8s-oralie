# Frontend Deployment Guide

This guide covers how to deploy the Oralie frontend application to Kubernetes.

## Environment Variables

The frontend application requires several environment variables to function properly. These variables are configured in different ways depending on the deployment environment:

### Development Environment Variables

For local development, create a `.env` file in the root of the frontend project with the following variables:

```bash
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:8072
NEX_PUBLIC_KEYCLOAK_URL=http://localhost:7080
NEXT_PUBLIC_URL=http://localhost:3000
NEXT_PUBLIC_BASE_URL=http://localhost:3000

# Authentication
NEXTAUTH_SECRET=development-secret-key-replace-in-production
NEXTAUTH_URL=http://localhost:3000

# CORS
ALLOWED_ORIGIN=*

# Keycloak Integration
KEYCLOAK_DOMAIN=http://keycloak:8080
KEYCLOAK_STORE_CLIENT_ID=oralie-app
KEYCLOAK_STORE_CLIENT_SECRET=your-client-secret
KEYCLOAK_END_SESSION_URL=http://keycloak:8080/realms/oralie/protocol/openid-connect/logout
```

### Docker Compose Environment Variables

For Docker Compose, the environment variables are defined in the `docker-compose.yml` file:

```yaml
frontend:
  image: oralie-frontend:latest
  environment:
    NEXT_PUBLIC_API_URL: "http://localhost:8072"
    NEX_PUBLIC_KEYCLOAK_URL: "http://localhost:7080"
    NEXT_PUBLIC_URL: "http://localhost:3000"
    # ... other variables
```

### Kubernetes Environment Variables

For Kubernetes, the environment variables are defined in the `frontend.yaml` deployment manifest:

```yaml
containers:
- name: frontend
  image: oralie-frontend:latest
  env:
  - name: NEXT_PUBLIC_API_URL
    value: "http://api.oralie.local"
  - name: NEX_PUBLIC_KEYCLOAK_URL
    value: "http://keycloak.oralie.local"
  # ... other variables
```

## Building the Docker Image

The `build-push-frontend.sh` script automates the process of building the Docker image:

1. It checks for a `.env` file and creates one with default values if needed
2. It builds the Docker image using the Dockerfile in the frontend directory
3. It provides instructions for pushing the image to a registry

```bash
# Make the script executable
chmod +x build-push-frontend.sh

# Run the script
./build-push-frontend.sh
```

## Deployment Steps

1. Build the Docker image using the build script
2. Push the image to a container registry if deploying to a remote cluster
3. Update the `frontend.yaml` to use the correct image reference
4. Deploy the frontend to Kubernetes:

```bash
kubectl apply -f k8s/frontend.yaml
```

5. Configure the ingress to route traffic to the frontend:

```bash
kubectl apply -f k8s/ingress.yaml
```

## Updating the ConfigMap

If you need to update the frontend configuration without rebuilding the image, you can modify the ConfigMap:

```bash
kubectl edit configmap oralie-config -n oralie-system
```

## Verifying the Deployment

1. Check that the pods are running:

```bash
kubectl get pods -n oralie-system -l app=frontend
```

2. Check that the service is available:

```bash
kubectl get service -n oralie-system frontend
```

3. Access the frontend through the configured ingress: http://oralie.local 