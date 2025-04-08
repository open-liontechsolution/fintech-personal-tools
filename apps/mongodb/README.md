# MongoDB Community Edition

Esta configuración implementa MongoDB Community Edition en un cluster k3s utilizando ArgoCD.

## Estructura

- `argocd/`: Contiene los manifiestos de ArgoCD para los diferentes entornos (dev, qa, prod)
- `helm-values/`: Contiene los valores personalizados para el Helm chart oficial de MongoDB

## Características

- Utiliza el chart oficial de MongoDB (versión Community sin licencia de pago)
- Configurado para trabajar con Cilium como CNI e ingress controller
- Almacenamiento persistente con Longhorn
- Configuración por entornos (desarrollo, QA, producción)
- Despliegue automatizado mediante ArgoCD

## Arquitectura

- **Desarrollo**: MongoDB en modo replicaset con una réplica para ahorro de recursos
- **QA**: MongoDB en modo replicaset con 3 réplicas para mayor disponibilidad
- **Producción**: MongoDB en modo replicaset con 3 réplicas, TLS activado y copias de seguridad programadas

## Uso

Para desplegar MongoDB en un entorno específico:

```bash
# Para desarrollo
kubectl apply -f argocd/application-dev.yaml -n argocd

# Para QA
kubectl apply -f argocd/application-qa.yaml -n argocd

# Para producción
kubectl apply -f argocd/application-prod.yaml -n argocd
```

## Notas importantes

- Se utiliza el chart oficial `mongodb` en su versión 13.6.4
- Los datos se almacenan en volúmenes persistentes proporcionados por Longhorn
- La sincronización automática está habilitada para mantener la configuración actualizada
- El prune automático está desactivado para evitar conflictos con recursos gestionados por Cilium
- Esta configuración cumple con los requisitos de escalabilidad horizontal y arquitectura cloud-native
