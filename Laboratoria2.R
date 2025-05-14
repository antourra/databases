#abriremos los datos

rm(list=ls())   # Limpia la lista de objetos 
graphics.off()  # Limpia la lista de gráficos

# Instalación de librerías
library(readxl) 
library(modeest)
library(ggplot2)
library(dplyr)
library(nortest)
library(lmtest)
library(car)
library(sandwich)
library(stargazer)

df<- read.csv("C:/Users/antoo/Downloads/Lab2.csv")
View(df)

# Porcentaje de descargas en el grupo económico (treatment group)
porcentaje_descargas_economico <- mean(df$download[df$economic == 1]) * 100
cat("Porcentaje de descargas en el grupo económico:", porcentaje_descargas_economico, "%\n")

# Porcentaje de descargas en el grupo control
porcentaje_descargas_control <- mean(df$download[df$economic == 0]) * 100
cat("Porcentaje de descargas en el grupo control:", porcentaje_descargas_control, "%\n")

# Porcentaje que recibió el mensaje en el grupo económico
porcentaje_mensaje_economico <- mean(df$whatsapp_received[df$economic == 1]) * 100
cat("Porcentaje que recibió el mensaje (grupo económico):", porcentaje_mensaje_economico, "%\n")

# Porcentaje que recibió el mensaje en el grupo control
porcentaje_mensaje_control <- mean(df$whatsapp_received[df$economic == 0]) * 100
cat("Porcentaje que recibió el mensaje (grupo control):", porcentaje_mensaje_control, "%\n")

# Porcentaje de descargas entre quienes recibieron el mensaje, grupo económico
descarga_mensaje_economico <- mean(df$download[df$whatsapp_received == 1 & df$economic == 1]) * 100
cat("Descargas entre quienes recibieron mensaje (grupo económico):", descarga_mensaje_economico, "%\n")

ITT <- 5.0368 - 1.3057            
ITTD <- (75.1751 - 0) / 100       
CACE <- ITT / ITTD  

# Regresión con errores robustos
modelo_itt <- lm(download ~ economic, data = df)
summary(modelo_itt)

# Errores robustos
coeftest(modelo_itt, vcov = vcovHC(modelo_itt, type = "HC1"))

modelo_2 <- lm(download ~ economic * edad, data= df)
summary(modelo_2)

# 4
# Instalar paquetes si es necesario
if (!require(pwr)) install.packages("pwr")
library(pwr)

# Defina los inputs
p1 <- porcentaje_descargas_control / 100  # Proporción del grupo de control (convertido a decimal)
p2 <- p1 + 0.01  # Proporción esperada en el grupo tratamiento (1 punto porcentual más que el grupo de control)
alpha <- 0.05  # Nivel de significancia (5%)
power <- 0.95  # Poder estadístico (95%)
allocation_ratio <- 1  # Ratio de asignación N2/N1 (grupos iguales)

# Función para calcular el tamaño de muestra
calcular_sample_size <- function(p1, p2, alpha, power, allocation_ratio) {
  h <- ES.h(p1, p2)
  if (allocation_ratio == 1) {
    resultado <- pwr.2p.test(h = h, sig.level = alpha, power = power, alternative = "two.sided")
    n1 <- ceiling(resultado$n)
    n2 <- ceiling(resultado$n)
  } else {
    z_alpha <- qnorm(1 - alpha / 2)
    z_beta <- qnorm(power)
    num <- (z_alpha + z_beta)^2 * (p1 * (1 - p1) + (p2 * (1 - p2)) / allocation_ratio)
    den <- (p1 - p2)^2
    n1 <- ceiling(num / den)
    n2 <- ceiling(n1 * allocation_ratio)
  }
  n_total <- n1 + n2
  critical_z <- qnorm(1 - alpha / 2)
  p_pool <- (p1 * n1 + p2 * n2) / (n1 + n2)
  se <- sqrt(p_pool * (1 - p_pool) * (1 / n1 + 1 / n2))
  z_observado <- abs(p2 - p1) / se
  power_real <- pnorm(z_observado - critical_z) + (1 - pnorm(z_observado + critical_z))
  return(data.frame(
    Critical_Z = round(critical_z, 4),
    Sample_Size_Group1 = n1,
    Sample_Size_Group2 = n2,
    Total_Sample_Size = n_total,
    Actual_Power = round(power_real, 4)
  ))
}

# Ejecutar la función
resultado <- calcular_sample_size(p1, p2, alpha, power, allocation_ratio)
print(resultado)