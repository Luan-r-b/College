library(data.table)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(psych)
library(sqldf)
library(tidyverse)


#Lendo toda a base de dados de vinhos vermelhos
base <- fread(input = paste0("Red.csv"), header = T, na.strings = "NA", data.table = FALSE, dec = ".")

#Separando pelos países mediterrâneos, os mais presentes na base de dados, para fazer uma avaliaalção estatística
#Onde todos os países inclusos tenham uma quantidadde adequada de vinhos na base
dataset <- subset(base, subset = Country == "Italy" | Country == "France" | Country == "Portugal" | Country == "Spain")

#Introduz uma coluna 'Range' que sera a classificação dos preços em subdivisões
dataset$Range <- NA

#Classificação do Range através de Price
dataset$Range[dataset$Price < 5.0] = "0:<5" 
dataset$Range[dataset$Price >= 5.0 & dataset$Price < 10.0] = "1:5~10" 
dataset$Range[dataset$Price >= 10.0 & dataset$Price < 25.0] = "2:10~25"  
dataset$Range[dataset$Price >= 25.0 & dataset$Price < 50.0] = "3:25~50" 
dataset$Range[dataset$Price >= 50.0 & dataset$Price < 100.0] = "4:50~100"  
dataset$Range[dataset$Price >= 100.0 & dataset$Price <250.0] = "5:100~250" 
dataset$Range[dataset$Price >= 250.0 & dataset$Price < 500.0] = "6:250~500"  
dataset$Range[dataset$Price >= 500.0 & dataset$Price < 750.0] = "7:500~750"  
dataset$Range[dataset$Price >= 750.0 & dataset$Price < 1000.0] = "8:750~1000"  
dataset$Range[dataset$Price >= 1000.0] = "9:>1000"

#Fazendo e exportando a tabela para Country - Incluir 
freq.tabela_country <- table(dataset$Country)
porc.tabela_country <- round(prop.table(freq.tabela_country)*100, 1)
tabela_country <- data.frame(freq.tabela_country, porc.tabela_country)
tabela_country = tabela_country[,-3]
colnames(tabela_country) = c("País", "Frequencia", "Porcentagem")

Tb.Country = tabela_country
png("Tabela_Country.png")
p = tableGrob(Tb.Country)
grid.arrange(p)
dev.off()

#Fazendo e exportando a tabela para Year - Fazer Histograma
freq.tabela_year <- table(dataset$Year)
porc.tabela_year <- round(prop.table(freq.tabela_year)*100, 1)
tabela_year <- data.frame(freq.tabela_year, porc.tabela_year)
tabela_year <- tabela_year[,-3]
colnames(tabela_year) = c("Ano", "Frequência", "Porcentagem")

Tb.Year = tabela_year
png("Tabela_Year.png")
p = tableGrob(Tb.Year)
grid.arrange(p)
dev.off()

#Fazendo e exportando a tabela Range
freq.tabela_range = table(dataset$Range)
porc.tabela_range = round(prop.table(freq.tabela_range)*100,1)
tabela_range = data.frame(freq.tabela_range, porc.tabela_range)
tabela_range = tabela_range[,-3]
colnames(tabela_range) = c("Range", "Frequência", "Porcentagem")

png("Table_Range.png")
grid.table(tabela_range)
dev.off()

#Fazendo e exportando a tabela Rating
freq.tabela_rating <- table(dataset$Rating)
porc.tabela_rating <- round(prop.table(freq.tabela_rating)*100,1)
tabela_rating <- data.frame(freq.tabela_rating, porc.tabela_rating)
tabela_rating <- tabela_rating[,-3]
colnames(tabela_rating) = c("Rating", "Frequência", "Porcentagem")

png("Tabela_rating.png", height = 800)
grid.table(tabela_rating)
dev.off()


#Relacionando Country e Year
freq.tabela.Country_Year = table(dataset$Country, dataset$Year, useNA = "ifany")
porc.tabela_country_Year = round(prop.table((freq.tabela.Country_Year),1)*100,1)

#Exportando como Tabela
df.2 = porc.tabela_country_Year
png("tabela_pais_ano.png", width = 1300, height = 150)
p = tableGrob(df.2)
grid.arrange(p)
dev.off()


#Relacionando Country e Price-Range
freq.tabela_country_range = table(dataset$Country, dataset$Range, useNA = "ifany")
porc.tabela_country_range = round(prop.table((freq.tabela_country_range),1)*100,1)
tabela_country_range = data.frame(freq.tabela_country_range, porc.tabela_country_range)
tabela_country_range = tabela_country_range[,-(4:5)]
colnames(tabela_country_range) = c("Country", "Range", "Frequência", "Porcentagem")
tabela_country_range = tabela_country_range[order(tabela_country_range$Country),]

#Extraindo tabela
png("Tabela_Country_Price_Range.png", height = 1000)
grid.table(tabela_country_range)
dev.off()


#Relacionando Price-Range e Year
freq.tabela_range_year = table(dataset$Year, dataset$Range, useNA = "ifany")
porc.tabela_range_year = round(prop.table((freq.tabela_range_year),1)*100,1)
tabela_range_year = data.frame(freq.tabela_range_year,porc.tabela_range_year)
tabela_range_year = tabela_range_year[,-(4:5)]
colnames(tabela_range_year) = c("Year", "Range", "Frequência", "Porcentagem")
tabela_range_year = tabela_range_year[order(tabela_range_year$Year),]

#Extraindo tabela
png("Tabela_Range_Year.png", height = 1000)
grid.table(tabela_range_year)
dev.off()

#Relacionando Rating e Country
freq.tabela_rating_country = table(dataset$Country, dataset$Rating,  useNA = "ifany")
porc.tabela_rating_country = round(prop.table((freq.tabela_rating_country),1)*100,1)
tabela_rating_country = data.frame(freq.tabela_rating_country, porc.tabela_rating_country)
tabela_rating_country = tabela_rating_country[,-(4:5)]
colnames(tabela_rating_country) = c( "Country","Rating", "Frequência", "Porcentagem")
tabela_rating_country = tabela_rating_country[order(tabela_rating_country$Country),]

png("Tabela_rating_country.png", height = 1000)
grid.table(tabela_rating_country)
dev.off()

#Fazendo Tabela Avg.Price_Year
table_avgprice_year = aggregate(Price ~ Year, data = dataset, FUN = mean, na.rm = TRUE)

#Fazendo Tabela Avg.Price_Year_Country
table_avgprice_year_country = aggregate(Price ~  Year + Country, data = dataset, FUN = mean, na.rm = TRUE)

#Fazendo tabela Avg.Price_Rating
table_avgprice_rating = aggregate(Price ~ Rating, data = dataset, FUN = mean, na.rm = TRUE)


#-------------------------------------------PLOTS-----------------------------------------------
#Fazendo gráfico Rating_Country

png("rating_country.png")
ggplot(data = tabela_rating_country ,aes(Rating, Frequência,
                                         colour = Porcentagem))+
  geom_point(size = 2)+
  facet_wrap(~Country)+
  labs(title= "Frequência de avaliações")+
  theme_bw()
dev.off()

#Fazendo gráfico avgprice-year
png("mean_avgprice_year.png", width = 1300)
ggplot(data = table_avgprice_year, aes(Year, Price)) +
  geom_point(size = 3) +
  labs(title = "Média de Preço por Ano") +
  theme_bw()
dev.off()

#Fazendo gráfico avgprice-year-country
png("mean_avgprice_year_country.png", width = 1600)
ggplot(data = table_avgprice_year_country, aes(Year, Price)) +
  geom_point(size = 2)+
  facet_wrap(~Country)+
  labs(title = "Média de Preço por ano e país") +
  theme_bw()
dev.off()

png("boxplot_price.png")
boxplot(dataset$Price,
        main = "Gráfico de Caixa de Preço",
        xlab = "",
        ylab = "Preço dos Vinhos",
        col = "purple",
        horizontal = FALSE)
dev.off()

png("boxplot_price_country.png")
boxplot(Price~Country,
        data = dataset,
        main = "Gráfico de Caixa de Preço por País",
        xlab = "País",
        ylab = "Preço dos vinhos",
        col = "purple",
        horizontal = FALSE)
dev.off()

png("gráfico_de_barras_range_country.png")
ggplot(tabela_country_range, aes(Country, Porcentagem)) +
  labs(title = "Porcentagem de Price Range por País")+
  geom_bar(aes(fill = Range), position = "dodge", stat = "identity")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  theme_bw()
dev.off()

