#!/bin/bash

# Crear namespace
kubectl create namespace fintech-personal || true

# Crear recursos
kubectl apply -f k8s/pvc.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Esperar a que el pod esté listo
echo "Waiting for Verdaccio pod to be ready..."
kubectl -n fintech-personal wait --for=condition=ready pod -l app=verdaccio --timeout=300s

# Crear usuario administrador
echo "Creating admin user..."
kubectl -n fintech-personal exec -it $(kubectl -n fintech-personal get pods -l app=verdaccio -o jsonpath='{.items[0].metadata.name}') -- verdaccio/bin/verdaccio --config /verdaccio/config/config.yaml --listen 0.0.0.0:4873 --storage /verdaccio/storage --auth /verdaccio/config/htpasswd --create-user admin --password admin123 --email admin@example.com

# Mostrar información de conexión
echo "Verdaccio is ready!"
echo "URL: http://verdaccio.fintech-personal.svc.cluster.local:4873"
echo "Admin credentials:"
echo "Username: admin"
echo "Password: admin123"
