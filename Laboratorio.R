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


