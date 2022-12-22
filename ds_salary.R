####data-scientist-salary####
#Jonas Arjona
#16-12-2022


#WORKING DIRECTORY 
setwd("E:/ANTES DA MUDANÇA/Jonas/quanti R/github/data-scientist-salary")
getwd()

#PACOTES
library(tidyverse)
library(ggplot2)
library(ggthemes)

#OPTIONS
options(scipen = 999)

#SUBINDO DADOS
ds_sal <- read.csv("ds_salaries.csv",sep=",",dec=".",header = T)

#CONHECENDO NÚMERO DE VAGAS
nrow(ds_sal)

#CONHECENDO OS CARGOS
unique(ds_sal$job_title)

#QUANTIDADE DE VAGAS POR CARGO
ds_sal %>% 
  group_by(job_title) %>% 
  summarise(contagem=n()) %>%
  arrange(desc(contagem))


#CATEGORIZAÇÃO DOS CARGOS
DA <- c('Product Data Analyst','Data Analyst','Business Data Analyst',
        'Lead Data Analyst','BI Data Analyst','Marketing Data Analyst',
        'Financial Data Analyst','Data Analytics Manager',
        'Finance Data Analyst','Principal Data Analyst',
        'Data Analytics Lead')

DS <- c('Data Scientist','Machine Learning Scientist','Data Science Consultant',
        'Director of Data Science','Research Scientist','Machine Learning Manager',
        'AI Scientist','Data Science Manager','3D Computer Vision Researcher',
        'Applied Data Scientist','Machine Learning Developer',
        'Applied Machine Learning Scientist','Head of Data Science',
        'Staff Data Scientist','Head of Machine Learning','Lead Data Scientist',
        'Principal Data Scientist')

DE <- c('Big Data Engineer','Machine Learning Engineer','Lead Data Engineer',
        'Data Engineer','Data Engineering Manager','Machine Learning Infrastructure Engineer',
        'ML Engineer','Computer Vision Engineer','Data Analytics Engineer','Cloud Data Engineer',
        'Computer Vision Software Engineer','Director of Data Engineering',
        'Data Science Engineer','Principal Data Engineer','Data Specialist',
        'Data Architect','Big Data Architect','Analytics Engineer','ETL Developer',
        'NLP Engineer','Lead Machine Learning Engineer')

ds_sal <- ds_sal %>% 
  mutate(big_job_title=case_when(
    job_title %in% DA~"Data Analyst",
    job_title %in% DS~"Data Scientist",
    job_title %in% DE~"Data Engineer",
    TRUE~"Outros"
  ))

rm(DE,DA,DS)

#VAGAS POR CARGO RECODIFICADO
table(ds_sal$big_job_title)

#CORREÇÃO DO NÍVEL DE EXPERIÊNCIA
ds_sal$experience_level <- factor(ds_sal$experience_level,
                                  levels=c("EN","MI","SE","EX"))

table(ds_sal$experience_level)

#CORREÇÃO DO FORMATO DE TRABALHO
ds_sal <- ds_sal %>% 
  mutate(remote_ratio = case_when(
    remote_ratio == "0" ~ "Presential",
    remote_ratio == "50" ~ "Hybrid",
    TRUE ~ "Remote"
  ))

table(ds_sal$remote_ratio)


#MERGULHO EXPLORATÓRIO
#STR DOS DADOS
str(ds_sal)

#SUMMARY DOS DADOS
summary(ds_sal)

#CRUZAMENTOS
#bjt(big_job_title)-exp
ds_sal %>%
  group_by(big_job_title,experience_level) %>%
  summarise(contagem=n()) %>%
  arrange(big_job_title,experience_level,desc(contagem))

ds_sal %>%
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,experience_level) %>%
  summarise(contagem=n()) %>%
  ggplot()+
  geom_col(aes(x=big_job_title,y=contagem,fill=experience_level))

#bjt-remote
ds_sal %>%
  group_by(big_job_title,remote_ratio) %>%
  summarise(contagem=n()) %>%
  arrange(big_job_title,remote_ratio,desc(contagem))

ds_sal %>%
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,remote_ratio) %>%
  summarise(contagem=n()) %>%
  ggplot()+
  geom_col(aes(x=big_job_title,y=contagem,fill=remote_ratio))

#bjt-país
ds_sal %>%
  filter(big_job_title != "Outros") %>% 
  group_by(company_location,big_job_title) %>%
  summarise(contagem=n()) %>%
  ggplot()+
  geom_col(aes(x=reorder(company_location,contagem),y=contagem,fill=big_job_title))+
  coord_flip()

#bjt-tamanho
ds_sal %>%
  group_by(big_job_title,company_size) %>%
  summarise(contagem=n()) %>%
  arrange(big_job_title,desc(contagem))

ds_sal %>%
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,company_size) %>%
  summarise(contagem=n()) %>%
  ggplot()+
  geom_col(aes(x=big_job_title,y=contagem,fill=company_size))

#bjt-ano
ds_sal$work_year <- factor(ds_sal$work_year,
                           levels=c("2020","2021","2022"))

ds_sal %>%
  group_by(big_job_title,work_year) %>%
  summarise(contagem=n()) %>%
  arrange(big_job_title,desc(contagem))

ds_sal %>%
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,work_year) %>%
  summarise(contagem=n()) %>%
  ggplot()+
  geom_col(aes(x=big_job_title,y=contagem,fill=work_year),position="dodge")

#bjt-mediana salarial
ds_sal %>%
  group_by(big_job_title,experience_level) %>%
  summarise(contagem=n(),
            mediana=median(salary_in_usd)) %>%
  arrange(big_job_title,desc(mediana))

ds_sal %>%
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,experience_level) %>%
  summarise(contagem=n(),
            mediana=median(salary_in_usd)) %>% 
  ggplot()+
  geom_col(aes(x=big_job_title,y=mediana,fill=experience_level),position = "dodge")

#contrato-bjt
ds_sal %>%
  group_by(big_job_title,employment_type) %>%
  summarise(contagem=n()) %>%
  arrange(big_job_title,desc(contagem))

ds_sal %>%
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,employment_type) %>%
  summarise(contagem=n()) %>% 
  ggplot()+
  geom_col(aes(x=big_job_title,y=contagem,fill=reorder(employment_type,contagem)),
               position = "dodge")+
  theme(legend.position = "bottom")


#ANÁLISE EM SI

##OBJETOS DE CONFIG
tema <- theme(plot.title = element_text(hjust=.5,size = 20),
              axis.title = element_text(size = 17.5),
              axis.text = element_text(size = 13),
              legend.title = element_text(size = 17.5),
              legend.text = element_text(size = 13),
              legend.position = "bottom",
              strip.text = element_text(size=13),
              panel.background = element_rect(fill = "white"),
              panel.border = element_rect(fill = NA,color = "grey20"),
              panel.grid = element_line(color = "grey92"))

cores_exp <- scale_color_manual(values = c("#dda56d","#639e55","#7dcfe5","#c25ee8"))
cores_remote <- scale_color_manual(values = c("#e7b962","#5cd08b","#5c73d0"))


#Experiência
##exp-min/mediana/max
rel_exp <- ds_sal %>% 
  filter(big_job_title != "Outros") %>% 
  group_by(experience_level) %>%
  summarise(contagem = n(),
            mediana = median(salary_in_usd),
            minimo = min(salary_in_usd),
            maximo = max(salary_in_usd)) %>% 
  pivot_longer(cols=3:5,
               names_to="medida")

rel_exp$medida <- factor(rel_exp$medida,
                            levels=c("minimo","mediana","maximo"))

ggplot(rel_exp,
       aes(x=medida,
           y=value,
           color=experience_level,
           group=experience_level))+
  geom_line(size=2)+
  geom_point(size=3)+
  scale_x_discrete(labels=c("Mínimo","Mediana","Máximo"))+
  labs(title = "Salário mediano anual em dólares por experiência",
       x = "Métrica",
       y = "Valor do salário anual",
       color = "Nível de experiência")+
  tema+
  cores_exp

rm(rel_exp)

##exp/cargo-min/mediana/max
rel_exp_cargo<- ds_sal %>% 
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,experience_level) %>%
  summarise(contagem = n(),
            mediana = median(salary_in_usd),
            minimo = min(salary_in_usd),
            maximo = max(salary_in_usd)) %>% 
  pivot_longer(cols=4:6,
               names_to="medida")

rel_exp_cargo$medida <- factor(rel_exp_cargo$medida,
                         levels=c("minimo","mediana","maximo"))

ggplot(rel_exp_cargo,
       aes(x=medida,
           y=value,
           color=experience_level,
           group=experience_level))+
  geom_line(size=2)+
  geom_point(size=3)+
  facet_wrap(~big_job_title)+
  scale_x_discrete(labels=c("Mínimo","Mediana","Máximo"))+
  labs(title = "Salário mediano anual em dólares por experiência e cargo",
       x = "Métrica",
       y = "Valor do salário anual",
       color = "Nível de experiência")+
  tema+
  cores_exp

rm(rel_exp_cargo)

##exp/cargo/ano-min/mediana/max
rel_exp_cargo_ano<- ds_sal %>% 
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,experience_level,work_year) %>%
  summarise(contagem = n(),
            mediana = median(salary_in_usd),
            minimo = min(salary_in_usd),
            maximo = max(salary_in_usd)) %>% 
  pivot_longer(cols=5:7,
               names_to="medida")

rel_exp_cargo_ano$medida <- factor(rel_exp_cargo_ano$medida,
                               levels=c("minimo","mediana","maximo"))

ggplot(rel_exp_cargo_ano,
       aes(x=medida,
           y=value,
           color=experience_level,
           group=experience_level))+
  geom_line(size=2)+
  geom_point(size=3)+
  facet_grid(work_year~big_job_title)+
  scale_x_discrete(labels=c("Mínimo","Mediana","Máximo"))+
  labs(title = "Salário mediano anual em dólares por experiência, cargo e ano",
       x = "Métrica",
       y = "Valor do salário anual",
       color = "Nível de experiência")+
  tema+
  cores_exp

rm(rel_exp_cargo_ano)


##exp/cargo/size-min/mediana/max
rel_exp_cargo_size<- ds_sal %>% 
  filter(big_job_title != "Outros") %>% 
  group_by(big_job_title,experience_level,company_size) %>%
  summarise(contagem = n(),
            mediana = median(salary_in_usd),
            minimo = min(salary_in_usd),
            maximo = max(salary_in_usd)) %>% 
  pivot_longer(cols=5:7,
               names_to="medida")

rel_exp_cargo_size$medida <- factor(rel_exp_cargo_size$medida,
                                            levels=c("minimo","mediana","maximo"))

ggplot(rel_exp_cargo_size,
       aes(x=medida,
           y=value,
           color=experience_level,
           group=experience_level))+
  geom_line(size=2)+
  geom_point(size=3)+
  facet_grid(company_size~big_job_title)+
  scale_x_discrete(labels=c("Mínimo","Mediana","Máximo"))+
  labs(title = "Salário mediano anual em dólares por experiência, cargo e porte da empresa",
       x = "Métrica",
       y = "Valor do salário anual",
       color = "Nível de experiência")+
  tema+
  cores_exp

rm(rel_exp_cargo_size)

#formato de trabalho
##remote-min/mediana/max
rel_remote <- ds_sal %>% 
  group_by(remote_ratio) %>%
  summarise(contagem = n(),
            mediana = median(salary_in_usd),
            minimo = min(salary_in_usd),
            maximo = max(salary_in_usd)) %>%
  pivot_longer(cols=3:5,
              names_to="medida")
  
rel_remote$medida <- factor(rel_remote$medida,
                                  levels=c("minimo","mediana","maximo"))

ggplot(rel_remote,
       aes(x=medida,
           y=value,
           color=remote_ratio,
           group=remote_ratio))+
  geom_line(size=2)+
  geom_point(size=3)+
  scale_x_discrete(labels=c("Mínimo","Mediana","Máximo"))+
  labs(title = "Salário mediano anual em dólares por formato de trabalho",
       x = "Métrica",
       y = "Valor do salário anual",
       color = "Formato de trabalho")+
  tema+
  cores_remote

rm(rel_remote)

##remote/cargo-min/mediana/max
rel_remote_cargo <- ds_sal %>% 
  filter(big_job_title != "Outros") %>% 
  group_by(remote_ratio,big_job_title) %>%
  summarise(contagem = n(),
            mediana = median(salary_in_usd),
            minimo = min(salary_in_usd),
            maximo = max(salary_in_usd)) %>%
  pivot_longer(cols=4:6,
               names_to="medida")

rel_remote_cargo$medida <- factor(rel_remote_cargo$medida,
                            levels=c("minimo","mediana","maximo"))

ggplot(rel_remote_cargo,
       aes(x=medida,
           y=value,
           color=remote_ratio,
           group=remote_ratio))+
  geom_line(size=2)+
  geom_point(size=3)+
  facet_wrap(~big_job_title)+
  scale_x_discrete(labels=c("Mínimo","Mediana","Máximo"))+
  labs(title = "Salário mediano anual em dólares por formato de trabalho e cargo",
       x = "Métrica",
       y = "Valor do salário anual",
       color = "Formato de trabalho")+
  tema+
  cores_remote

rm(rel_remote_cargo)


#remote/cargo/ano-min/mediana/max
rel_remote_cargo_ano <- ds_sal %>% 
  filter(big_job_title != "Outros") %>% 
  group_by(remote_ratio,big_job_title,work_year) %>%
  summarise(contagem = n(),
            mediana = median(salary_in_usd),
            minimo = min(salary_in_usd),
            maximo = max(salary_in_usd)) %>%
  pivot_longer(cols=5:7,
               names_to="medida")

rel_remote_cargo_ano$medida <- factor(rel_remote_cargo_ano$medida,
                                  levels=c("minimo","mediana","maximo"))

ggplot(rel_remote_cargo_ano,
       aes(x=medida,
           y=value,
           color=remote_ratio,
           group=remote_ratio))+
  geom_line(size=2)+
  geom_point(size=3)+
  facet_grid(work_year~big_job_title)+
  scale_x_discrete(labels=c("Mínimo","Mediana","Máximo"))+
  labs(title = "Salário mediano anual em dólares por formato de trabalho, cargo e ano",
       x = "Métrica",
       y = "Valor do salário anual",
       color = "Formato de trabalho")+
  tema+
  cores_remote

rm(rel_remote_cargo_ano)


##remote/cargo/size-min/mediana/max
rel_remote_cargo_size <- ds_sal %>% 
  filter(big_job_title != "Outros") %>% 
  group_by(remote_ratio,big_job_title,company_size) %>%
  summarise(contagem = n(),
            mediana = median(salary_in_usd),
            minimo = min(salary_in_usd),
            maximo = max(salary_in_usd)) %>%
  pivot_longer(cols=5:7,
               names_to="medida")

rel_remote_cargo_size$medida <- factor(rel_remote_cargo_size$medida,
                                      levels=c("minimo","mediana","maximo"))

ggplot(rel_remote_cargo_size,
       aes(x=medida,
           y=value,
           color=remote_ratio,
           group=remote_ratio))+
  geom_line(size=2)+
  geom_point(size=3)+
  facet_grid(company_size~big_job_title)+
  scale_x_discrete(labels=c("Mínimo","Mediana","Máximo"))+
  labs(title = "Salário mediano anual em dólares por formato de trabalho, cargo e porte da empresa",
       x = "Métrica",
       y = "Valor do salário anual",
       color = "Formato de trabalho")+
  tema+
  cores_remote

rm(rel_remote_cargo_size)



