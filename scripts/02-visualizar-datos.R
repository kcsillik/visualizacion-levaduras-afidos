# VISUALIZACION DE DATOS YA SIMULADOS - USO DOCENTE
# Adaptacion del script de practica original para la estructura del proyecto.
# Este script NO crea ni reemplaza las observaciones simuladas.
# Abre visualizacion-levaduras-afidos.Rproj y ejecuta por secciones.
# Se vuelve a importar el Excel para no depender de objetos de una sesion anterior.

ruta_importacion <- file.path("scripts", "01-importar-datos.R")
if (!file.exists(ruta_importacion)) {
  stop("Abre primero visualizacion-levaduras-afidos.Rproj desde la carpeta del proyecto.")
}
source(ruta_importacion, encoding = "UTF-8")

# 2. RESUMEN DEL PRIMER ENSAYO --------------------------------------------
resumen_e1 <- e1 %>%
  group_by(codigo_especie, especie, tratamiento, dias_post_inoculacion) %>%
  summarise(n_plantas = n_distinct(id_planta),
            media_total = mean(total_afidos),
            desviacion_estandar = sd(total_afidos),
            error_estandar = desviacion_estandar / sqrt(n_plantas),
            .groups = "drop")
stopifnot(all(resumen_e1$n_plantas == 10))

g1 <- ggplot(resumen_e1,
             aes(dias_post_inoculacion, media_total, colour = tratamiento,
                 group = tratamiento)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  facet_wrap(~ especie) +
  scale_x_continuous(breaks = c(14, 21, 28)) +
  labs(title = "Crecimiento poblacional: datos simulados",
       x = "Dias posteriores a la inoculacion", y = "Media de afidos por planta",
       colour = "Tratamiento")
print(g1)

g2 <- e1 %>% filter(dias_post_inoculacion == 28) %>%
  ggplot(aes(tratamiento, total_afidos)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(width = 0.12, seed = 26),
             alpha = 0.65, size = 1.5) +
  facet_wrap(~ especie) +
  labs(title = "Variacion entre plantas a 28 dpi: simulacion",
       x = "Tratamiento", y = "Afidos por planta")
print(g2)

# 3. SELECCION: MEDIA DE SEIS REDUCCIONES ----------------------------------
controles <- resumen_e1 %>% filter(tratamiento == "L0") %>%
  select(codigo_especie, dias_post_inoculacion, media_control = media_total)
reducciones <- resumen_e1 %>%
  left_join(controles, by = c("codigo_especie", "dias_post_inoculacion")) %>%
  mutate(reduccion_relativa = 1 - media_total / media_control)
seleccion <- reducciones %>% filter(tratamiento != "L0") %>%
  group_by(tratamiento) %>%
  summarise(reduccion_conjunta = mean(reduccion_relativa), .groups = "drop") %>%
  arrange(desc(reduccion_conjunta)) %>%
  mutate(puesto = row_number(), seleccionada = puesto <= 2L)
print(seleccion)
# Un valor negativo significa mas afidos que en el control, no un error.
g3 <- ggplot(seleccion,
             aes(reorder(tratamiento, reduccion_conjunta),
                 100 * reduccion_conjunta)) +
  geom_col() +
  coord_flip() +
  labs(title = "Seleccion de cepas: resultado exclusivamente simulado",
       x = "Tratamiento", y = "Reduccion conjunta (%)")
print(g3)

# 4. TABLA DE VIDA DESDE LOS DATOS DIARIOS ---------------------------------
# Las filas relleno_postmuerte conservan vivo=0 y crias=0.
# No aumentan el numero de individuos iniciales.
# NO convertir los NA de desarrollo ninfal de individuos muertos en ceros.
vida <- e2 %>%
  group_by(codigo_especie, especie, tratamiento, edad_dias) %>%
  summarise(n_inicial = n_distinct(id_individuo),
            n_vivos = sum(vivo_inicio),
            crias_totales = sum(ninfas_producidas),
            n_N1 = sum(estadio == "N1"),
            n_N2 = sum(estadio == "N2"),
            n_N3 = sum(estadio == "N3"),
            n_N4 = sum(estadio == "N4"),
            n_adultas = sum(estadio == "adulta"),
            .groups = "drop") %>%
  mutate(lx = n_vivos / n_inicial,
         mx = if_else(n_vivos > 0, crias_totales / pmax(n_vivos, 1), 0),
         lxmx = crias_totales / n_inicial,
         sx_N1 = n_N1 / n_inicial, sx_N2 = n_N2 / n_inicial,
         sx_N3 = n_N3 / n_inicial, sx_N4 = n_N4 / n_inicial,
         sx_adulta = n_adultas / n_inicial,
         tiempo_euler_dias = edad_dias + 1)
stopifnot(all(vida$n_inicial == 10L))
stopifnot(all(abs(vida$lxmx - vida$lx * vida$mx) < 1e-10))

g4 <- ggplot(vida, aes(edad_dias, lx, colour = tratamiento)) +
  geom_step(linewidth = 0.8) +
  facet_wrap(~ especie) +
  labs(title = "Supervivencia de cohortes simuladas",
       x = "Edad al inicio del intervalo (dias)", y = "Supervivencia (lx)",
       colour = "Tratamiento")
print(g4)

g5 <- ggplot(vida, aes(edad_dias, lxmx, colour = tratamiento)) +
  geom_line(linewidth = 0.8) +
  facet_wrap(~ especie) +
  labs(title = "Maternidad neta por edad: simulacion",
       x = "Edad al inicio del intervalo (dias)",
       y = "Crias por individuo inicial y dia (lxmx)", colour = "Tratamiento")
print(g5)

vida_estadios <- vida %>%
  select(especie, tratamiento, edad_dias, starts_with("sx_")) %>%
  pivot_longer(starts_with("sx_"), names_to = "estadio", values_to = "sxj")
g6 <- ggplot(vida_estadios, aes(edad_dias, sxj, colour = estadio)) +
  geom_line() +
  facet_grid(especie ~ tratamiento) +
  labs(title = "Supervivencia edad-estado: simulacion",
       x = "Edad (dias)", y = "Supervivencia edad-estado (sxj)", colour = "Estadio")
print(g6)

# 5. RM, LAMBDA, R0 Y T: UNA ESTIMACION POR COHORTE --------------------------
# Los parametros NO se sortean ni se calculan como 10 replicas por tratamiento.
# rm resuelve sum(exp(-rm*(x+1))*lxmx) = 1.
# La fecundidad se atribuye al final de cada intervalo, x+1.
parametros_r <- vida %>%
  group_by(codigo_especie, especie, tratamiento) %>%
  group_modify(~ {
    z <- .x
    R0 <- sum(z$lxmx)
    if (R0 <= 0) {
      return(tibble(R0 = R0, rm_dia = NA_real_, lambda_diaria = NA_real_,
                    T_dias = NA_real_, residuo_euler = NA_real_))
    }
    f <- function(r) sum(exp(-r * z$tiempo_euler_dias) * z$lxmx) - 1
    limites <- c(-1, 2)
    if (f(limites[1]) * f(limites[2]) > 0) {
      stop("La raiz Euler-Lotka no esta acotada: revisar datos e intervalo.")
    }
    rm <- uniroot(f, interval = limites, tol = 1e-12)$root
    tiempo <- if (abs(rm) < 1e-10) {
      sum(z$tiempo_euler_dias * z$lxmx) / R0
    } else log(R0) / rm
    tibble(R0 = R0, rm_dia = rm, lambda_diaria = exp(rm),
           T_dias = tiempo, residuo_euler = f(rm))
  }) %>%
  ungroup()
print(parametros_r)

# Comprobar las estimaciones contra las formulas del Excel.
comparacion <- parametros_r %>%
  select(codigo_especie, tratamiento, R0_R = R0, rm_R = rm_dia) %>%
  mutate(tratamiento = as.character(tratamiento)) %>%
  left_join(parametros_excel %>%
              select(codigo_especie, tratamiento, R0_Excel = R0, rm_Excel = rm_dia),
            by = c("codigo_especie", "tratamiento")) %>%
  mutate(diferencia_R0 = R0_R - R0_Excel, diferencia_rm = rm_R - rm_Excel)
stopifnot(all(abs(comparacion$diferencia_R0) < 1e-8))
stopifnot(all(abs(comparacion$diferencia_rm) < 1e-8))
print(comparacion)

# 6. EXPORTAR UN GRAFICO (opcional; descomenta) -----------------------------
# ggsave(file.path("figuras", "01-crecimiento-poblacional.png"), plot = g1,
#        width = 10, height = 5, units = "in", dpi = 300)

# RECORDATORIOS:
# E1: 180 unidades, NO 540; los tres dias son medidas repetidas.
# E2: cada individuo ocupa una planta; no mezclar crias con la hembra focal.
# Cinco bloques no significan diez repeticiones por bloque.
# Fecundidad_total incluye los ceros de quienes murieron sin reproducirse.
# No se hicieron pruebas de hipotesis ni bootstrap.
# Una diferencia entre tratamientos simulados no demuestra eficacia real.
# Los rangos y fechas son ilustrativos, no predicciones para el invernadero.
