# FRP (Fast Reverse Proxy) para Fintech Personal

Este directorio contiene la configuración necesaria para desplegar FRP, una herramienta de tunneling y reverse proxy que permite exponer servicios internos de forma segura a través de un VPS en la nube.

## Arquitectura

FRP funciona con dos componentes principales:

1. **frps** (Servidor): Se ejecuta en el VPS en la nube y actúa como punto de entrada para las conexiones externas.
2. **frpc** (Cliente): Se ejecuta en la red interna y establece conexiones con el servidor frps.

Esta configuración permite:
- Exponer servicios internos sin abrir puertos en el router local
- Mantener la seguridad de la red interna
- Proporcionar acceso a los servicios desde cualquier lugar

## Despliegue

### Servidor (VPS en la nube)

El servidor FRP (frps) se despliega en un VPS en la nube utilizando Kubernetes/k3s:

```bash
kubectl apply -f apps/frp/kubernetes/frps.yaml
```

### Cliente (Red interna)

El cliente FRP (frpc) se despliega en el cluster k3s local:

```bash
kubectl apply -f apps/frp/kubernetes/frpc.yaml
```

## Configuración

La configuración de FRP se encuentra en:

- `apps/frp/docker/frps.ini`: Configuración del servidor
- `apps/frp/docker/frpc.ini`: Configuración del cliente
- `apps/frp/helm-values/`: Valores de Helm para diferentes entornos

## Seguridad

- Se utiliza autenticación mediante token para asegurar la conexión entre cliente y servidor
- Todo el tráfico está cifrado mediante TLS
- Se implementan restricciones de acceso basadas en IP cuando es posible

## Referencias

- [Documentación oficial de FRP](https://github.com/fatedier/frp)
- [Guía de configuración avanzada](https://github.com/fatedier/frp/blob/master/README.md)
