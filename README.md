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
- Despliegue como servicio en Kubernetes

### 2. Configuración de Kubernetes
- Recursos separados por entornos (dev, qa, prod)
- Configuración adaptada para Longhorn
- Manifiestos compatibles con ArgoCD
- Gestión de secretos con Sealed Secrets

## Estructura del Repositorio

```
fintech-personal-tools/
├── apps/                  # Aplicaciones/servicios de infraestructura
│   ├── verdaccio/        # Verdaccio NPM Registry
│       ├── base/         # Configuración base (común)
│       ├── overlays/     # Configuraciones específicas por entorno
│           ├── dev/      # Entorno de desarrollo
│           ├── qa/       # Entorno de pruebas
│           └── prod/     # Entorno de producción
├── platform/             # Configuración general de la plataforma
│   ├── namespaces/       # Definición de namespaces
│   ├── rbac/            # Configuración de RBAC
│   ├── networking/       # Configuración de networking (Cilium)
│   └── storage/          # Configuración de almacenamiento (Longhorn)
└── docs/                 # Documentación
```

## Despliegue con ArgoCD

Este repositorio está estructurado para ser desplegado con ArgoCD. Cada directorio en `apps/` y `platform/` contiene un manifiesto de aplicación de ArgoCD que puede ser utilizado para desplegar los recursos correspondientes.

## Gestión de Secretos

Los secretos sensibles se gestionan mediante Sealed Secrets:

1. Los secretos se crean inicialmente como archivos YAML normales
2. Se encriptan con `kubeseal` para crear SealedSecrets
3. Solo los SealedSecrets se almacenan en el repositorio
4. El controlador SealedSecrets en el cluster los desencripta

## Entornos

El repositorio está organizado para soportar múltiples entornos:

- **Dev**: Entorno de desarrollo local para pruebas iniciales
- **QA**: Entorno de control de calidad para pruebas más rigurosas
- **Prod**: Entorno de producción

## Licencia

AGPL-3.0
