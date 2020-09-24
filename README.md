# Sistemas de Negocio
> Grado en Ingeniería Informática (Curso 2020-2021)

## Imagen Docker

Situado en el directorio que contiene el notebook de trabajo, ejecuta el siguiente comando para arrancar la imagen Docker:

```bash
docker run --rm -p 8888:8888 -v "$(pwd)":"$(pwd)" -w "$(pwd)" hlfernandez/jupyter-sn:2020-2021
```
