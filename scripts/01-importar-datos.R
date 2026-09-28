# DATOS TOTALMENTE SIMULADOS - USO DOCENTE
# Curso: Visualizacion de datos. No son resultados del experimento.
# Abre visualizacion-levaduras-afidos.Rproj antes de ejecutar este script.
# Se lee el Excel existente desde datos/: no se generan datos nuevos.
# Las tablas de datos tienen encabezados en la primera fila.
#
# Una sola vez, instala los paquetes necesarios:
# install.packages(c("readxl", "dplyr", "tidyr", "ggplot2"))

paquetes <- c("readxl", "dplyr", "tidyr", "ggplot2")
faltantes <- paquetes[!vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltantes) > 0L) {
  stop(paste0("Primero instala: install.packages(c(",
              paste(sprintf('"%s"', faltantes), collapse = ", "), "))"))
}
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# 1. IMPORTAR -------------------------------------------------------------
archivo <- file.path("datos", "datos-simulados-levaduras-afidos.xlsx")
if (!file.exists(archivo)) {
  stop(paste0("No se encontro el Excel. Abre primero ",
              "visualizacion-levaduras-afidos.Rproj y conserva la carpeta datos."))
}
excel_sheets(archivo)

e1 <- read_excel(archivo, sheet = "E1_recuentos", na = "")
e1_plantas <- read_excel(archivo, sheet = "E1_plantas", na = "")
e2 <- read_excel(archivo, sheet = "E2_diario", na = "")
individuos <- read_excel(archivo, sheet = "E2_individuos", na = "")
vida_excel <- read_excel(archivo, sheet = "E2_tabla_vida", na = "")
parametros_excel <- read_excel(archivo, sheet = "E2_parametros", na = "")

niveles <- c("L0", "L1", "L2", "L3", "L5", "L6", "L7", "L8", "L9")
e1 <- e1 %>%
  mutate(tratamiento = factor(tratamiento, levels = niveles),
         bloque_temporal = factor(bloque_temporal),
         especie = factor(especie))
e2 <- e2 %>%
  mutate(tratamiento = factor(tratamiento, levels = niveles),
         bloque_temporal = factor(bloque_temporal),
         especie = factor(especie),
         estadio = factor(estadio, levels = c("N1", "N2", "N3", "N4", "adulta", "muerta")))
individuos <- individuos %>%
  mutate(tratamiento = factor(tratamiento, levels = niveles),
         bloque_temporal = factor(bloque_temporal),
         especie = factor(especie))

stopifnot(nrow(e1) == 540L, n_distinct(e1$id_planta) == 180L)
stopifnot(n_distinct(e2$id_individuo) == 60L, nrow(individuos) == 60L)
stopifnot(all(e1$origen_dato == "simulado_didactico"))
stopifnot(all(e2$ninfas_producidas[e2$vivo_inicio == 0] == 0))
stopifnot(all(e2$ninfas_producidas[e2$estadio != "adulta"] == 0))
stopifnot(sum(e2$evento_muerte) == 60L)
glimpse(e1)
glimpse(individuos)


# Los objetos quedan disponibles en el entorno de R.
# El Excel original no se modifica.
message("Datos existentes importados. No se ha generado una nueva simulacion.")
