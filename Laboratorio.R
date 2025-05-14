library(stargazer)
library(readxl) 
library(modeest)
library(ggplot2)
library(dplyr)
library(nortest)
library(lmtest)
library(car)
library(sandwich)

df<- read_excel("C:/Users/antoo/Downloads/2023100316071526988D8472BD81__Data_lab_2_2023-2.xlsx")
View(df)

data_econ<- df %>% filter(cond == "Economic")
data_pro<- df %>% filter(cond == "Prosocial")
data_both<- df %>% filter(cond == "Both")
data_control<- df %>% filter(cond == "Control")

#-----

#1)

#econ
mean(data_econ$age)
sd(data_econ$age)

mean(data_econ$past_report)
sd(data_econ$past_report)

#pro
mean(data_pro$age)
sd(data_pro$age)

mean(data_pro$past_report)
sd(data_pro$past_report)

#both
mean(data_both$age)
sd(data_both$age)

mean(data_both$past_report)
sd(data_both$past_report)

#control
mean(data_control$age)
sd(data_control$age)

mean(data_control$past_report)
sd(data_control$past_report)


#  modelo ANOVA para age
modelo_anova_años <- aov(age ~ cond, data = df)

# Obtener los resultados del ANOVA
summary(modelo_anova_años)

# Realizar el test de chi-cuadrado para past_report

resultado_chi2 <- chisq.test(df$cond, df$past_report)

# Ver el resultado del test
print(resultado_chi2)


#--------

#2)

# % de descargas

sum(data_econ$download)/22276

sum(data_pro$download)/6505

sum(data_both$download)/11147

sum(data_control$download)/6510


# % que abrió el mensaje

sum(data_econ$whatsapp_received)/22276

sum(data_pro$whatsapp_received)/6505

sum(data_both$whatsapp_received)/11147


# % de descargas de los que abrieron el mensaje 

data_abremensaje<- df %>% filter(whatsapp_received == 1)

data_econ2<- data_abremensaje %>% filter(cond == "Economic")
data_pro2<- data_abremensaje %>% filter(cond == "Prosocial")
data_both2<- data_abremensaje %>% filter(cond == "Both")


sum(data_econ2$download)/10385

sum(data_pro2$download)/2950

sum(data_both2$download)/5224

#------
#3)
# Calcular ITT
ITT_econ <- mean(data_econ$download) - mean(data_control$download)
ITT_pro <- mean(data_pro$download) - mean(data_control$download)
ITT_both <- mean(data_both$download) - mean(data_control$download)

cat("ITT Economic:", ITT_econ, "\n")
cat("ITT Prosocial:", ITT_pro, "\n")
cat("ITT Both:", ITT_both, "\n")

# Calcular ITTd (solo para los que abrieron el mensaje)
ITTd_econ <- mean(data_econ2$download) - mean(data_control$download[data_control$whatsapp_received == 1])
ITTd_pro <- mean(data_pro2$download) - mean(data_control$download[data_control$whatsapp_received == 1])
ITTd_both <- mean(data_both2$download) - mean(data_control$download[data_control$whatsapp_received == 1])

cat("ITTd Economic:", ITTd_econ, "\n")
cat("ITTd Prosocial:", ITTd_pro, "\n")
cat("ITTd Both:", ITTd_both, "\n")

# Calcular CACE (ajustado por la tasa de cumplimiento)
compliance_rate_econ <- mean(data_econ$whatsapp_received)
compliance_rate_pro <- mean(data_pro$whatsapp_received)
compliance_rate_both <- mean(data_both$whatsapp_received)

CACE_econ <- ITT_econ / compliance_rate_econ
CACE_pro <- ITT_pro / compliance_rate_pro
CACE_both <- ITT_both / compliance_rate_both

cat("CACE Economic:", CACE_econ, "\n")
cat("CACE Prosocial:", CACE_pro, "\n")
cat("CACE Both:", CACE_both, "\n")

#------
#4)

modelo<-lm(download~Economic+Prosocial+Both,data=df)


summary(modelo)

#------
#5)


modelo2<-lm(download~econ+pro+both+ past_report + past_report*econ,data=df)

stargazer(modelo, modelo2,type="text",df=FALSE)

#------

#6)

# Filtrar los datos solo para personas que recibieron los mensajes o son del grupo de control
datos_filtrados <- subset(df, whatsapp_received == 1 | cond == "Control")

# Ajustar una regresión lineal con todas las variables independientes para el grupo filtrado
modelo_filtrado <- lm(download ~ Economic + Prosocial + Both, data = datos_filtrados)

# Ver los resultados del modelo para el grupo filtrado
summary(modelo_filtrado)


