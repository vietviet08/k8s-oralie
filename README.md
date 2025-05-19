# Oralie Microservice Kubernetes Deployment

This directory contains Kubernetes manifests for deploying the Oralie Microservice application to a Kubernetes cluster.

## Architecture

The deployment consists of:

- 3 cluster servers running Kubernetes
- 1 Rancher server for Kubernetes management
- 1 database server (running MySQL and PostgreSQL)
- 1 load balancer server (Nginx Ingress controller)

## Services Overview

1. **Infrastructure Services**:
   - ConfigServer: Centralized configuration management
   - EurekaServer: Service discovery

2. **Databases**:
   - PostgreSQL: For Keycloak 
   - MySQL: For microservices
   - Redis: For caching

3. **Authentication**:
   - Keycloak: Identity and access management

4. **Messaging**:
   - Kafka & Zookeeper: Event streaming
   - Debezium: CDC (Change Data Capture)

5. **Core Microservices**:
   - Accounts: User account management
   - Products: Product catalog
   - Carts: Shopping cart service
   - Orders: Order management
   - Social: Social features
   - Rates: Rating system
   - Inventory: Inventory management
   - Search: Elasticsearch integration
   - Notification: Notification system

6. **Gateway**:
   - API Gateway: Single point of entry

## Deployment Instructions

### Prerequisites

1. A Kubernetes cluster with at least 3 worker nodes
2. Rancher installed and configured
3. Load balancer configured to route traffic to Kubernetes services
4. Persistent storage available for databases

### Deployment Steps with Rancher

1. Log in to your Rancher dashboard
2. Create a new project named "Oralie"
3. Create a new namespace "oralie-system" in the project
4. Build and push the frontend Docker image:

```bash
# Make the build script executable
chmod +x build-push-frontend.sh

# Run the build script
./build-push-frontend.sh
```

5. Use the "Import YAML" feature in Rancher to import these files in order:

```
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f mysql-init-scripts-configmap.yaml
kubectl apply -f connector-configs.yaml
kubectl apply -f storage.yaml
kubectl apply -f databases.yaml
kubectl apply -f auth-search.yaml
kubectl apply -f kafka.yaml
kubectl apply -f infrastructure.yaml
kubectl apply -f core-services.yaml
kubectl apply -f gateway.yaml
kubectl apply -f frontend.yaml
kubectl apply -f ingress.yaml
```

6. Configure DNS or update your hosts file to point the following domains to your load balancer IP:
   - oralie.local
   - api.oralie.local
   - keycloak.oralie.local
   - kafka-ui.oralie.local
   - pgadmin.oralie.local

### Configuration Notes

1. Update the `configmap.yaml` file with your actual secrets and credentials
2. For production use, implement proper secrets management
3. Adjust resource limits based on your cluster capacity
4. Consider configuring additional replicas for high availability

## Monitoring and Logging

The deployment includes telemetry with:
- Prometheus and Grafana for monitoring
- OpenTelemetry for tracing
- Loki for log aggregation 