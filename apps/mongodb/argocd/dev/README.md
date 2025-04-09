# Network Policy para MongoDB Community Operator

Este directorio contiene las políticas de red necesarias para que el operador de MongoDB pueda comunicarse correctamente con los recursos de MongoDB en el entorno de desarrollo.

## Archivos

- `network-policy.yaml`: Contiene dos políticas de red:
  - Una NetworkPolicy estándar de Kubernetes
  - Una CiliumNetworkPolicy específica para Cilium

## Propósito

Estas políticas permiten que el operador de MongoDB, que se ejecuta en el namespace `mongodb`, pueda acceder y gestionar los recursos de MongoDB en el namespace `mongodb-dev`.

## Puertos permitidos

- 27017: Puerto principal de MongoDB
- 27018: Puerto adicional para configuración
- 27019: Puerto adicional para configuración

## Aplicación

Para aplicar estas políticas:

```bash
kubectl apply -f network-policy.yaml -n mongodb-dev
```

## Notas importantes

- La política estándar de Kubernetes funcionará en cualquier cluster que soporte NetworkPolicies
- La política de Cilium proporciona un control más granular y es específica para clusters que utilizan Cilium como CNI
- Estas políticas son necesarias para que el operador pueda gestionar correctamente los recursos de MongoDB en diferentes namespaces
