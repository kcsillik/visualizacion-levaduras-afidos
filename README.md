# Visualización de levaduras y áfidos

Proyecto final del curso **Visualización de datos**.

> **Todos los datos son simulados y se utilizarán exclusivamente con fines didácticos.**
> No son resultados experimentales ni evidencia de eficacia de las levaduras.

## Objetivo

Utilizaré datos simulados basados en la metodología de mi tesis para practicar en RStudio
la organización, comparación y visualización de respuestas de *Myzus persicae* y
*Brevicoryne brassicae* frente a tratamientos con levaduras en plantas de repollo.
Lo aprendido se aplicará posteriormente al análisis de los datos reales de la tesis.

## Datos que se utilizarán

Se conservará el Excel completo de la simulación ya elaborada. El nombre del archivo se ha adaptado a
la convención del repositorio, pero su contenido es idéntico al original.

- **Primer ensayo:** 180 plantas, nueve tratamientos (ocho cepas y un control), dos
  especies y cinco bloques temporales; 540 recuentos a los días 14, 21 y 28.
- **Segundo ensayo:** 60 plantas con dos cepas seleccionadas y un control; registros
  diarios de desarrollo, supervivencia y reproducción, resúmenes individuales y
  parámetros demográficos derivados de tablas de vida.

Se utilizarán las hojas `E1_recuentos`, `E1_plantas`, `E2_diario`, `E2_individuos`,
`E2_tabla_vida` y `E2_parametros`. El Excel también conservará su documentación,
diccionario de variables, supuestos y controles de calidad.

Las observaciones de distintas fechas de una misma planta no se tratarán como
unidades experimentales independientes. Los parámetros demográficos se calcularán
por cohorte, no como diez estimaciones independientes por tratamiento. Las filas de
relleno posteriores a la muerte no representarán nuevos individuos.

## Organización

```text
visualizacion-levaduras-afidos/
├── README.md
├── .gitignore
├── visualizacion-levaduras-afidos.Rproj
├── datos/
│   ├── README.md
│   └── datos-simulados-levaduras-afidos.xlsx
├── scripts/
│   ├── 01-importar-datos.R
│   └── 02-visualizar-datos.R
└── figuras/
    └── README.md
```

Los nombres descriptivos usarán minúsculas, guiones y caracteres sin tildes ni espacios.
Se mantendrán las convenciones `README.md`, `.Rproj` y `.R`. Los prefijos `01` y `02`
indicarán el orden de trabajo. Las rutas de los scripts serán relativas a la raíz del
proyecto, no a una carpeta particular de un computador.
