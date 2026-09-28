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

Se conservará el Excel completo de la simulación ya elaborada. **No se ha generado una
nueva simulación para preparar este proyecto.** El nombre del archivo se ha adaptado a
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

## Comenzar en RStudio

1. Descomprime la carpeta y abre `visualizacion-levaduras-afidos.Rproj`.
2. Instala una sola vez los paquetes necesarios, desde la consola de R:

   ```r
   install.packages(c("readxl", "dplyr", "tidyr", "ggplot2"))
   ```

3. Abre y ejecuta `scripts/01-importar-datos.R` para revisar los datos.
4. Abre `scripts/02-visualizar-datos.R` y ejecútalo por secciones para explorar
   resúmenes y gráficos. Este segundo script vuelve a importar los datos antes del
   análisis para que pueda ejecutarse de manera independiente.

También se puede ejecutar el flujo completo desde la consola, con el proyecto abierto:

```r
source("scripts/02-visualizar-datos.R", encoding = "UTF-8")
```

La sección final incluye una instrucción comentada para guardar un gráfico en
`figuras/`. No se generaron gráficos durante la preparación de esta carpeta.

Los scripts se adaptaron del archivo de práctica existente, conservando su lógica de
análisis. El contenido del Excel se verificó mediante comparación SHA-256. Los scripts
no se ejecutaron en R durante esta preparación; contienen verificaciones internas
que se evaluarán cuando se ejecuten en RStudio.

## Crear la copia en GitHub

Esta carpeta **no está publicada en GitHub**. Para completar la actividad:

1. Crea en tu cuenta un repositorio llamado `visualizacion-levaduras-afidos`.
   Descripción sugerida: «Proyecto final de Visualización de datos: análisis en R de
   datos simulados sobre levaduras y pulgones en repollo». Elige la visibilidad según
   las indicaciones del curso y quiénes deban tener acceso.
2. Crea el repositorio sin añadir otro README, licencia ni archivo .gitignore;
   esta carpeta ya contiene README y .gitignore.
3. En la página inicial del repositorio, utiliza la opción para subir un archivo
   existente. Después de la primera carga, la opción estará en **Add file → Upload
   files**. Arrastra el contenido de esta carpeta, conservando sus subcarpetas.
   **No subas el ZIP ni la carpeta contenedora como una subcarpeta adicional.**
4. Añade el mensaje «Agregar estructura inicial y datos simulados existentes» y
   confirma los cambios. Si el formulario propone una nueva rama, completa la
   solicitud de incorporación y combínala para que los archivos queden en la rama
   principal. Comparte con el curso la dirección del repositorio una vez creado.

Comprueba que también se haya incluido `.gitignore`, que puede estar oculto en el
explorador de archivos. Si no aparece en la carga, créalo en GitHub con **Add file →
Create new file** y pega el contenido del archivo local. No subas credenciales ni
archivos personales ajenos al proyecto.

## Documentación de referencia

- GitHub: creación de repositorios.
  <https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository>
- GitHub: carga de archivos y carpetas.
  <https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository>
- Posit: proyectos de RStudio.
  <https://docs.posit.co/ide/user/ide/guide/code/projects.html>
- readxl: importación de hojas de Excel.
  <https://readxl.tidyverse.org/reference/read_excel.html>
- Tidyverse: convenciones para nombres de archivos.
  <https://style.tidyverse.org/files.html>
