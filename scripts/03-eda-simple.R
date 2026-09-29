# 03-eda-simple.R
# Proyecto: levaduras-repollo-afidos
# Analisis exploratorio del primer ensayo con los datos simulados existentes.
# No genera datos nuevos ni modifica el Excel.
# Abrir primero el archivo .Rproj y ejecutar este script desde la raiz del proyecto.

# Instalar una sola vez si faltan estos paquetes:
# install.packages(c("readxl", "dplyr", "ggplot2"))

paquetes <- c("readxl", "dplyr", "ggplot2")
faltantes <- paquetes[!vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltantes) > 0L) {
  stop("Primero instala estos paquetes: ", paste(faltantes, collapse = ", "))
}

library(readxl)
library(dplyr)
library(ggplot2)

# 1. Importar la hoja del primer ensayo ------------------------------------
archivo <- file.path("datos", "datos-simulados-levaduras-afidos.xlsx")
if (!file.exists(archivo)) {
  stop("No se encuentra el Excel. Abre el archivo .Rproj y comprueba la carpeta datos.")
}
datos <- read_excel(archivo, sheet = "E1_recuentos")

columnas <- c("id_planta", "especie", "tratamiento", "dias_post_inoculacion", "total_afidos")
if (!all(columnas %in% names(datos))) {
  stop("La hoja no contiene todas las columnas esperadas. Revisa el archivo y la hoja.")
}
if (!is.numeric(datos$total_afidos) || !is.numeric(datos$dias_post_inoculacion)) {
  stop("Los recuentos y los dias deben ser columnas numericas.")
}

# 2. Conocer la estructura y revisar valores faltantes ----------------------
glimpse(datos)
print(head(datos))
print(datos %>% summarise(
  registros = n(),
  plantas = n_distinct(id_planta),
  especies = n_distinct(especie),
  tratamientos = n_distinct(tratamiento),
  recuentos_faltantes = sum(is.na(total_afidos))
))
# Los recuentos se repiten en tres fechas sobre las mismas plantas.
# Por eso 540 registros no equivalen a 540 unidades experimentales.
print(colSums(is.na(datos)))

# 3. Promedios por especie, tratamiento y fecha -----------------------------
resumen <- datos %>%
  group_by(especie, tratamiento, dias_post_inoculacion) %>%
  summarise(
    n_plantas = n_distinct(id_planta),
    n_con_dato = sum(!is.na(total_afidos)),
    promedio = if (all(is.na(total_afidos))) NA_real_ else mean(total_afidos, na.rm = TRUE),
    desviacion = sd(total_afidos, na.rm = TRUE),
    .groups = "drop"
  )

print(resumen, n = Inf)

# Tabla mas corta para una captura de la consola: solo el dia 28.
print(resumen %>% filter(dias_post_inoculacion == 28), n = Inf)

# 4. Grafico exploratorio --------------------------------------------------
grafico <- ggplot(
  resumen,
  aes(x = dias_post_inoculacion, y = promedio,
      colour = tratamiento, group = tratamiento)
) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2.5) +
  facet_wrap(~ especie) +
  scale_x_continuous(breaks = c(14, 21, 28)) +
  labs(
    title = "EDA: crecimiento poblacional de pulgones",
    subtitle = "Primer ensayo: datos completamente simulados",
    x = "Dias posteriores a la inoculacion",
    y = "Promedio de pulgones por planta",
    colour = "Tratamiento",
    caption = "L0 = control. Exploracion descriptiva; no demuestra eficacia biologica."
  ) +
  theme_minimal()

print(grafico)

# 5. Guardar el grafico ----------------------------------------------------
dir.create("figuras", showWarnings = FALSE)
ggsave(
  filename = file.path("figuras", "eda-crecimiento-poblacional.png"),
  plot = grafico, width = 10, height = 5, units = "in", dpi = 300
)

# Cada punto representa la media de las plantas de un tratamiento y especie
# en una fecha. Se agrupan los cinco bloques para esta primera descripcion.
# El grafico describe promedios: no muestra toda la variabilidad individual
# ni constituye una prueba de diferencias estadisticamente significativas.
