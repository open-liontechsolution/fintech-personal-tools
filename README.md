# Fintech Personal - Tools

Repositorio que contiene la configuración y despliegue de servicios de infraestructura y herramientas necesarias para el proyecto de Fintech Personal.

## Infraestructura

Este repositorio está diseñado para funcionar con:
- Cluster k3s local
- Cilium como CNI
- ArgoCD para despliegue continuo
- Longhorn para almacenamiento persistente
- Sealed Secrets para gestión segura de secretos

## Servicios Incluidos

### 1. Verdaccio (Registro NPM Privado)
- Gestión de paquetes privados
- Cache de paquetes públicos
- Autenticación y control de acceso
- Despliegue como servicio en Kubernetes utilizando el Helm chart oficial
- Integración con FRP Client para acceso externo seguro
- Configuración con URL pública personalizada (verdaccio.liontechsolution.com)

### 2. Fast Reverse Proxy (FRP)
- **Servidor FRP (frps)**: Desplegado en VPS mediante GitHub Actions
- **Cliente FRP (frpc)**: Integrado con servicios internos como Verdaccio
- Túneles seguros para exponer servicios internos a Internet
- Autenticación mediante token para evitar conexiones no autorizadas
- Panel de administración securizado

### 3. Nginx Proxy Manager (NPM)
- Gestión de proxies inversos con interfaz web amigable
- Configuración automática de certificados SSL mediante Let's Encrypt
- Redirección de tráfico a servicios internos y FRP
- Soporte para múltiples dominios y hosts virtuales

### 4. Configuración de Kubernetes
- Recursos separados por entornos (dev, qa, prod)
- Configuración adaptada para Longhorn
- Manifiestos compatibles con ArgoCD
- Gestión de secretos con Sealed Secrets

## Estructura del Repositorio

```
fintech-personal-tools/
├── apps/                  # Aplicaciones/servicios de infraestructura
│   ├── verdaccio/         # Verdaccio NPM Registry
│   │   ├── argocd/        # Configuración de ArgoCD por entorno
│   │   │   ├── application-dev.yaml
│   │   │   ├── application-qa.yaml
│   │   │   └── application-prod.yaml
│   │   ├── helm-values/   # Valores para el chart de Helm por entorno
│   │   │   ├── dev/       # Valores para entorno de desarrollo
│   │   │   ├── qa/        # Valores para entorno de pruebas
│   │   │   └── prod/      # Valores para entorno de producción
│   │   └── README.md      # Documentación específica de Verdaccio
│   ├── frp/               # Fast Reverse Proxy
│   │   ├── frps/          # Servidor FRP
│   │   │   ├── docker/    # Configuración de Docker para frps
│   │   │   │   ├── docker-compose.yaml
│   │   │   │   └── frps.toml
│   │   │   └── README.md
│   │   └── README.md      # Documentación general de FRP
│   └── nginx-proxy-manager/ # Nginx Proxy Manager
│       ├── docker/        # Configuración de Docker para NPM
│       │   └── docker-compose.yaml
│       └── README.md      # Documentación de NPM
├── platform/              # Configuración general de la plataforma
│   ├── namespaces/        # Definición de namespaces
│   ├── rbac/              # Configuración de RBAC
│   ├── networking/        # Configuración de networking (Cilium)
│   └── storage/           # Configuración de almacenamiento (Longhorn)
└── docs/                  # Documentación
```

## Infraestructura Compartida

### Red Docker Compartida

Los servicios Docker (FRP Server y Nginx Proxy Manager) utilizan una red compartida para facilitar la comunicación:

- **Nombre**: `fintech_shared_network`
- **Tipo**: Bridge
- **Propósito**: Permitir que NPM pueda comunicarse directamente con frps y redireccionar tráfico a servicios internos

Esta configuración facilita:
- Resolución de nombres entre contenedores
- Simplicidad en configuración de proxy inverso
- Mayor seguridad al evitar exponer puertos innecesariamente

## Despliegue de Servicios

### Servicios Kubernetes (ArgoCD)

ArgoCD se encarga de la sincronización automática de los recursos en el clúster Kubernetes, como Verdaccio.

ArgoCD se encarga de la sincronización automática de los recursos en el clúster. Cada aplicación tiene configurada:

1. La fuente del chart de Helm (para aplicaciones que usen charts oficiales)
2. Los valores específicos para cada entorno
3. El namespace de destino
4. Las políticas de sincronización

Esto permite tener un flujo GitOps completo donde cualquier cambio en el repositorio se refleja automáticamente en el clúster, manteniendo la infraestructura como código.

### Servicios Docker (GitHub Actions)

Los servicios desplegados en VPS mediante Docker (frps y Nginx Proxy Manager) se gestionan a través de flujos de trabajo de GitHub Actions:

1. Los cambios en la configuración se envían al repositorio
2. GitHub Actions ejecuta automáticamente los flujos de trabajo de despliegue
3. Los contenedores se actualizan en el VPS objetivo
4. Se mantiene la persistencia de datos mediante volúmenes Docker

## Gestión de Secretos

### Kubernetes (Sealed Secrets)

Los secretos sensibles en Kubernetes se gestionan mediante Sealed Secrets:

1. Los secretos se crean inicialmente como archivos YAML normales
2. Se encriptan con `kubeseal` para crear SealedSecrets
3. Solo los SealedSecrets se almacenan en el repositorio
4. El controlador SealedSecrets en el cluster los desencripta

### Servicios Docker (GitHub Secrets)

Para los servicios desplegados con Docker:

1. Los valores sensibles (tokens, contraseñas, etc.) se almacenan como GitHub Secrets
2. Los flujos de trabajo de GitHub Actions inyectan estos secretos como variables de entorno
3. Los archivos de configuración (como `frps.toml`) utilizan estas variables

## Entornos

El repositorio está organizado para soportar múltiples entornos:

- **Dev**: Entorno de desarrollo local para pruebas iniciales
- **QA**: Entorno de control de calidad para pruebas más rigurosas
- **Prod**: Entorno de producción

## Licencia

AGPL-3.0
