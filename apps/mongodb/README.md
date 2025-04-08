# MongoDB Community Edition

Esta configuración implementa MongoDB Community Edition en un cluster k3s utilizando ArgoCD.

## Estructura

- `argocd/`: Contiene los manifiestos de ArgoCD para los diferentes entornos (dev, qa, prod)
- `helm-values/`: Contiene los valores personalizados para el Helm chart oficial de MongoDB

## Características

- Utiliza el chart oficial de MongoDB Community (sin licencia de pago)
- Configurado para trabajar con Cilium como CNI e ingress controller
- Almacenamiento persistente con Longhorn
- Configuración por entornos (desarrollo, QA, producción)
- Despliegue automatizado mediante ArgoCD

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

- Se utiliza el chart `mongodb-community-server` que es la versión Community Edition (sin costo)
- Los datos se almacenan en un volumen persistente proporcionado por Longhorn
- La sincronización automática está habilitada para mantener la configuración actualizada
- El prune automático está desactivado para evitar conflictos con recursos gestionados por Cilium
