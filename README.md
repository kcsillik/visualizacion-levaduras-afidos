# Análisis exploratorio y visualización de respuestas de áfidos a tratamientos con levaduras

**Autora:** Karolina Csillik Concha  
**Curso:** Visualización de datos  
**Herramientas principales:** R, RStudio y GitHub  
**Estado del proyecto:** desarrollo inicial, con scripts de importación y visualización disponibles.

> **Todos los datos utilizados en este proyecto son simulados y tienen fines exclusivamente didácticos.** No corresponden a resultados experimentales de la tesis ni constituyen evidencia de eficacia de los tratamientos con levaduras.

## Resumen del proyecto

Este proyecto utiliza datos simulados basados en la metodología de mi tesis para desarrollar un flujo de organización, análisis exploratorio y visualización en R. El tema de investigación corresponde a la respuesta de *Myzus persicae* y *Brevicoryne brassicae* frente a tratamientos con levaduras en plantas de repollo.

El conjunto de datos representa dos ensayos complementarios. El primero considera recuentos de áfidos por planta en tres momentos de evaluación y permite explorar diferencias poblacionales entre tratamientos. El segundo reúne registros diarios de desarrollo, supervivencia y reproducción de individuos, junto con tablas de vida y parámetros demográficos.

El propósito del repositorio es practicar la preparación de datos, la elaboración de gráficos y la interpretación de patrones descriptivos, manteniendo explícitas las unidades de observación y las limitaciones de la simulación. Lo aprendido se aplicará posteriormente al análisis de los datos reales de la tesis.

## Objetivos

### Objetivo general

Desarrollar un flujo reproducible de análisis exploratorio y visualización de datos simulados sobre la respuesta poblacional y demográfica de dos especies de áfidos a tratamientos con levaduras en plantas de repollo.

### Objetivos específicos

1. Organizar e importar los datos de ambos ensayos, conservando sus identificadores, tratamientos, bloques temporales y niveles de observación.
2. Describir y visualizar la variación de los recuentos poblacionales, la supervivencia y la reproducción entre tratamientos y especies.
3. Documentar el procedimiento de análisis y sus limitaciones, diferenciando los patrones de la simulación de las conclusiones que podrían obtenerse con datos experimentales reales.

## Preguntas exploratorias

1. ¿Cómo cambian los recuentos simulados de áfidos por planta entre los días 14, 21 y 28 posteriores a la inoculación?
2. ¿Qué diferencias descriptivas se observan entre los tratamientos y cómo varían entre *M. persicae* y *B. brassicae*?
3. ¿Qué variabilidad existe entre plantas de un mismo tratamiento, especialmente al finalizar el primer ensayo?
4. ¿Cómo se distribuyen la supervivencia y la reproducción a lo largo de la vida de las cohortes simuladas del segundo ensayo?
5. ¿Cómo influyen las medidas repetidas, los datos ausentes y los registros posteriores a la muerte en la preparación e interpretación de los datos?

## Fuentes de datos

La fuente de entrada es el archivo [`datos/datos-simulados-levaduras-afidos.xlsx`](datos/datos-simulados-levaduras-afidos.xlsx), elaborado previamente como simulación didáctica para el curso.

Según la documentación de [`datos/README.md`](datos/README.md), este archivo conserva el contenido del Excel original `Datos_simulados_levaduras_afidos_RStudio.xlsx`; únicamente se modificaron su nombre y ubicación para ajustarlos a la organización del repositorio. La documentación de integridad del archivo también se encuentra en esa carpeta.

El Excel contiene los datos de ambos ensayos y su documentación asociada. Se mantiene como fuente de entrada: los scripts leen su contenido, pero no deben sobrescribirlo ni generar una nueva simulación en su reemplazo.

### Descripción del primer ensayo

La simulación representa **180 plantas**, distribuidas entre **nueve tratamientos**, **dos especies de áfidos** y **cinco bloques temporales**. Los tratamientos corresponden a ocho cepas de levaduras y un control.

Los recuentos se realizan a los **14, 21 y 28 días posteriores a la inoculación**, por lo que se dispone de **540 registros de recuento**. Estas observaciones corresponden a medidas repetidas sobre las mismas plantas; no representan 540 unidades experimentales independientes.

El script de análisis resume los datos por especie, tratamiento y día de evaluación, y comprueba que cada combinación contenga diez plantas. Los resúmenes actuales agrupan las plantas de los bloques temporales y no estiman por separado un efecto del bloque.

### Descripción del segundo ensayo

La simulación representa **60 plantas**, con un individuo focal por planta, y considera **dos cepas seleccionadas y un control** para las dos especies de áfidos.

Incluye registros diarios de estadio de desarrollo, supervivencia y producción de ninfas, además de resúmenes individuales y tablas de vida. El código calcula los parámetros demográficos por cohorte definida por especie y tratamiento, no como una estimación independiente para cada individuo.

Las filas posteriores a la muerte permiten conservar la estructura temporal de la tabla. No representan nuevos individuos ni nuevas observaciones de supervivencia positiva.

### Hojas utilizadas

| Hoja del Excel | Contenido y función en el análisis |
|---|---|
| `E1_recuentos` | Recuentos de áfidos del primer ensayo en las distintas fechas de evaluación. |
| `E1_plantas` | Información de las plantas del primer ensayo. |
| `E2_diario` | Seguimiento diario de los individuos del segundo ensayo. |
| `E2_individuos` | Resúmenes individuales del segundo ensayo. |
| `E2_tabla_vida` | Tabla de vida incluida en el Excel. |
| `E2_parametros` | Parámetros demográficos del Excel utilizados para contrastar los cálculos realizados en R. |

## Organización del proyecto

```text
visualizacion-levaduras-afidos/
├── README.md
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

La carpeta `datos/` conserva la fuente de entrada y su documentación. La carpeta `scripts/` contiene el código de importación y análisis, mientras que `figuras/` está destinada a los gráficos exportados.

Los nombres descriptivos utilizan minúsculas, guiones y caracteres sin tildes ni espacios. Se mantienen las convenciones `README.md`, `.Rproj` y `.R`. Las rutas de los scripts son relativas a la carpeta principal del proyecto, de modo que no dependan de una ubicación particular en un computador.

## Diccionario preliminar de datos

La siguiente tabla resume las variables utilizadas explícitamente en los scripts disponibles. No sustituye el diccionario completo contenido en el Excel.

| Variable | Descripción |
|---|---|
| `codigo_especie` | Código que identifica la especie de áfido. |
| `especie` | Nombre de la especie de áfido. |
| `tratamiento` | Código del tratamiento asignado. |
| `bloque_temporal` | Identificador del bloque temporal. |
| `id_planta` | Identificador de la planta; permite reconocer sus mediciones repetidas. |
| `dias_post_inoculacion` | Tiempo transcurrido desde la inoculación, expresado en días. |
| `total_afidos` | Recuento total de áfidos por planta y fecha de evaluación. |
| `id_individuo` | Identificador del individuo focal del segundo ensayo. |
| `edad_dias` | Edad al inicio del intervalo de seguimiento diario, en días. |
| `estadio` | Categoría registrada: `N1`, `N2`, `N3`, `N4`, `adulta` o `muerta`. |
| `vivo_inicio` | Indicador de supervivencia al inicio del intervalo; se utiliza para contar los individuos vivos. |
| `evento_muerte` | Indicador del evento de muerte durante el seguimiento. |
| `ninfas_producidas` | Número de ninfas producidas durante el intervalo diario. |
| `origen_dato` | Identificación del origen simulado; el script verifica el valor `simulado_didactico` en los recuentos del primer ensayo. |

La codificación utilizada en los scripts es `L0`, `L1`, `L2`, `L3`, `L5`, `L6`, `L7`, `L8` y `L9`. El código `L0` corresponde al control. Se conserva esta codificación sin introducir ni renumerar tratamientos.

## Tratamiento preliminar de datos ausentes y control de calidad

La importación reconoce las celdas vacías como valores ausentes (`NA`). Los valores ausentes relacionados con el desarrollo de individuos que murieron antes de completar una etapa no deben reemplazarse automáticamente por cero.

Un cero de reproducción y una medición ausente tienen significados diferentes. Los individuos que murieron sin reproducirse deben conservar su fecundidad total igual a cero, mientras que los tiempos de desarrollo no observados deben mantenerse como ausentes cuando corresponda.

Los scripts incluyen comprobaciones del número de registros, plantas e individuos; del origen simulado de los recuentos; de la ausencia de producción de ninfas en registros incompatibles con la reproducción; y del número total de eventos de muerte. También incorporan una comparación entre los parámetros calculados en R y los incluidos en el Excel.

El cálculo actual de medias y desviaciones estándar del primer ensayo no elimina automáticamente valores ausentes. Si se incorporan nuevos faltantes, será necesario revisar su tratamiento y comunicar el número de observaciones válidas utilizado en cada resumen.

## Estadísticas descriptivas

El script [`02-visualizar-datos.R`](scripts/02-visualizar-datos.R) contiene el cálculo del número de plantas, la media, la desviación estándar y el error estándar de los recuentos, agrupados por especie, tratamiento y día de evaluación.

Para el segundo ensayo, el código construye una tabla de vida a partir de los registros diarios y calcula supervivencia (`lx`), reproducción media por individuo vivo (`mx`) y maternidad neta por edad (`lxmx`). También calcula `R0`, `rm_dia`, `lambda_diaria` y `T_dias` por cohorte.

Estos procedimientos están implementados en los scripts, pero este README todavía no presenta una tabla de resultados numéricos verificados.

## Análisis exploratorio y visualizaciones

El código disponible incluye seis visualizaciones:

| Objeto en R | Visualización | Propósito |
|---|---|---|
| `g1` | Curvas de recuento promedio por tratamiento, separadas por especie. | Examinar la evolución entre los días 14, 21 y 28. |
| `g2` | Diagramas de caja con observaciones individuales al día 28. | Mostrar la distribución de los recuentos y la variación entre plantas. |
| `g3` | Gráfico de reducción relativa conjunta respecto del control. | Ordenar descriptivamente las cepas dentro de la simulación. |
| `g4` | Curvas escalonadas de supervivencia. | Comparar la proporción de individuos vivos a lo largo de la edad. |
| `g5` | Curvas de maternidad neta por edad. | Visualizar la producción de ninfas por individuo inicial y día. |
| `g6` | Curvas de supervivencia por edad y estadio. | Describir la distribución de los individuos entre estadios durante el seguimiento. |

### Recuentos poblacionales y comparación con el control

La primera figura muestra las medias por tratamiento. Aunque el script calcula la desviación estándar y el error estándar, la versión actual de esta figura no incorpora barras ni bandas de dispersión. Su incorporación constituye una mejora pendiente.

La comparación con el control utiliza la expresión `1 - media_tratamiento / media_control` para cada combinación de especie y fecha. El código promedia las seis reducciones correspondientes a dos especies y tres fechas para ordenar las cepas y marcar las dos primeras. Un valor negativo indica un recuento medio superior al control.

Este ordenamiento describe únicamente los datos simulados y no constituye una selección validada de cepas para su aplicación experimental.

### Supervivencia, reproducción y parámetros demográficos

Las visualizaciones del segundo ensayo distinguen supervivencia, reproducción y estadio de desarrollo. Los parámetros demográficos se calculan para cada cohorte, conservando la identificación por especie y tratamiento.

Los diez individuos que integran cada cohorte en el esquema del script no se consideran diez estimaciones independientes de los parámetros demográficos. El código actual no incluye pruebas de hipótesis ni procedimientos de remuestreo para cuantificar la incertidumbre de estos parámetros.

### Figuras disponibles en el repositorio

La carpeta [`figuras/`](figuras/) contiene su documentación, que indica que todavía no se han guardado gráficos. El script incluye una instrucción de exportación comentada; por lo tanto, disponer del código de una figura no equivale a tener su imagen publicada en GitHub.

Los títulos de las figuras deben identificar expresamente que se trata de datos simulados.

## Herramientas utilizadas

| Herramienta | Uso en el proyecto |
|---|---|
| R y RStudio | Ejecución y organización del análisis mediante el archivo `.Rproj`. |
| `readxl` | Lectura de las hojas del archivo Excel. |
| `dplyr` | Transformación, agrupación y resumen de los datos. |
| `tidyr` | Reorganización de tablas para determinadas visualizaciones. |
| `ggplot2` | Construcción y exportación de gráficos. |
| GitHub | Organización y publicación de los archivos y su historial de cambios. |

## Cómo reproducir el análisis

### 1. Preparar el proyecto

Descargar o clonar el repositorio completo y abrir `visualizacion-levaduras-afidos.Rproj` en RStudio. Mantener la estructura de carpetas y el archivo Excel dentro de `datos/`.

### 2. Instalar los paquetes necesarios

Ejecutar una vez en la consola de R, si los paquetes todavía no están instalados:

```r
install.packages(c("readxl", "dplyr", "tidyr", "ggplot2"))
```

### 3. Ejecutar la importación y el análisis

Para revisar únicamente la importación y las comprobaciones iniciales:

```r
source("scripts/01-importar-datos.R", encoding = "UTF-8")
```

Para ejecutar el flujo de análisis y visualización:

```r
source("scripts/02-visualizar-datos.R", encoding = "UTF-8")
```

El segundo script llama al primero y vuelve a importar el Excel, por lo que no depende de objetos conservados de una sesión anterior. Las tablas y los objetos gráficos quedan disponibles en el entorno de R.

Si alguna comprobación detiene la ejecución, se debe revisar su causa antes de continuar; no corresponde eliminarla solo para permitir que el script avance.

### 4. Guardar una figura

La exportación incluida al final del segundo script está comentada. Después de ejecutar el análisis, la primera figura puede guardarse con:

```r
dir.create("figuras", showWarnings = FALSE)

ggplot2::ggsave(
  filename = file.path("figuras", "01-crecimiento-poblacional.png"),
  plot = g1,
  width = 10,
  height = 5,
  units = "in",
  dpi = 300
)
```

El archivo se guarda en la carpeta local `figuras/`. Para que sea visible en GitHub, también debe incorporarse al repositorio y registrarse el cambio.

### 5. Registrar el entorno de ejecución

Para documentar las versiones de R y de los paquetes utilizados, ejecutar:

```r
sessionInfo()
```

## Estado actual del proyecto y hallazgos preliminares

El repositorio dispone de una estructura de carpetas, un archivo de proyecto de RStudio, la documentación de los datos y dos scripts con procedimientos de importación, comprobación, resumen y visualización.

La siguiente etapa es documentar la ejecución completa, revisar sus salidas y publicar las figuras y tablas correspondientes. La presencia del código no se presenta como garantía de que todas sus comprobaciones hayan sido ejecutadas satisfactoriamente.

Todavía no se incorporan aquí hallazgos numéricos ni se identifican tratamientos con una respuesta superior. Esa interpretación debe basarse en las salidas revisadas y referirse siempre a la simulación.
