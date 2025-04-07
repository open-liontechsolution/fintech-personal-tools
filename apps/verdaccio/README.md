# Verdaccio en Kubernetes

Este directorio contiene la configuración para desplegar Verdaccio en un clúster Kubernetes (k3s) utilizando el chart oficial de Helm a través de ArgoCD.

## Estructura del Directorio

```
apps/verdaccio/
├── argocd/                # Manifiestos de ArgoCD para cada entorno
│   ├── application-dev.yaml
│   ├── application-qa.yaml
│   └── application-prod.yaml
└── helm-values/           # Valores personalizados para el Helm chart
    ├── dev/
    │   └── values.yaml    # Valores para el entorno de desarrollo
    ├── qa/
    │   └── values.yaml    # Valores para el entorno de QA
    └── prod/
        └── values.yaml    # Valores para el entorno de producción
```

## Configuración de ArgoCD

Los manifiestos de ArgoCD en el directorio `argocd/` configuran ArgoCD para:

1. Utilizar el chart oficial de Verdaccio desde el repositorio `https://charts.verdaccio.org`
2. Aplicar los valores personalizados para cada entorno desde nuestro repositorio
3. Desplegar cada entorno en su propio namespace, con su propia configuración

## Configuraciones por Entorno

Cada entorno (dev, qa, prod) tiene su propia configuración con diferentes:

- Número de réplicas
- Recursos asignados (CPU, memoria)
- Configuración de ingress
- Configuración de almacenamiento
- Configuración de TLS (solo en producción)

## Recursos Utilizados

- **Longhorn**: Utilizado como clase de almacenamiento para persistencia
- **Cilium**: Utilizado como controlador de ingress y redes
- **Helm Chart Oficial**: Verdaccio versión 4.2.0

## Cómo Funciona el Despliegue

1. ArgoCD monitorea cambios en el repositorio `fintech-personal-tools`
2. Cuando detecta cambios en los archivos de valores o en las definiciones de aplicaciones, ArgoCD:
   - Obtiene el chart de Verdaccio del repositorio oficial
   - Aplica los valores personalizados desde nuestro repositorio
   - Despliega o actualiza la aplicación en el namespace correspondiente

## Escalabilidad

La configuración está diseñada para facilitar la escalabilidad horizontal:

- El entorno de desarrollo tiene 1 réplica con recursos mínimos
- El entorno de QA tiene 2 réplicas con recursos moderados
- El entorno de producción tiene 3 réplicas con recursos amplios y afinidad entre pods

## Seguridad

- Cada entorno está aislado en su propio namespace
- TLS habilitado en el entorno de producción
- Las credenciales de administrador deben gestionarse con Sealed Secrets

## Notas de Uso

Para acceder a Verdaccio desde otros servicios en el clúster, utiliza la URL:

```
http://verdaccio.fintech-personal-<env>:4873
```

Donde `<env>` es `dev`, `qa` o `prod` dependiendo del entorno.
