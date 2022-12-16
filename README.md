# Salários para posições de Ciência e Análise de dados 

Este script foi criado por [Jonas Arjona](https://www.linkedin.com/in/jonas-arjona-639497190/). Nele desenvolvemos uma análise de dados para os salários de posições relacionadas com Análise, Ciência e Engenharia de Dados a partir dos dados disponiblizados por [Ruchi Bhatia na plataforma Kaggle](https://www.kaggle.com/datasets/ruchi798/data-science-job-salaries). Eles foram extraídos por este do site [AI-Jobs](https://ai-jobs.net/). Seu uso e reprodução é de domínio público. 

## Primeiro passo: a pergunta de pesquisa
A fonte de dados em questão possui informações sobre características de vagas para posições relacionadas a dados, como possibilidade de trabalho remoto, tipo de vínculo empregaticio ou nível de experiência desejada do candidato.

Logo, nossa pergunta de pesquisa foi: 

**As vagas para carreiras em dados sofrem influências significativas das escolhas feitas pelos recrutadores no processo de contratação?**

Como perguntas auxiliares temos algumas delas:
* A perspectiva de trabalho remoto reduz a compensação salarial?
* A experiência é a mais influente variável na definição do salário?
* Há algum tipo de contratação dominante nesse ramo?

## Segundo passo: os dados e suas fontes
Nosso banco consiste em informações extraídos de um site de anúncio de vagas e possui:
* **work_year**: Ano da públicação da vaga (2020,2021 ou 2022);
* **experienca_level**: experiência desejada ("EN" para entrada, "MI" para júnior, "SE" para sênior e "EX" para diretor);
* **employment_type**: tipo de contratração ("PT" para meio-período,"FT" para integral, "CT" para contrato e "FL" para freelance); 
* **job_title**: título do cargo;
* **salary**: salário;
* **salary_currency**: moeda do salário;
* **salary_in_usd**: salário em dólares;
* **employee_residence**: residência do contratado;
* **remote_ratio**: modalidade de trabalho remot0 ("0" para presencial, "50" para híbrido e "100" para remoto);
* **company_location**: país da empresa;
* **company_size**: tamanho da empresa ("S" para -50 empregados,"M" entre 50 e 250 e "L" para +250).

Primeiro, selecionamos nosso **working directory**, os pacotes a serem usados e desabilitamos a função automática de notação científica. 

```r
#WORKING DIRECTORY 
setwd([DIRETÓRIO DE SUA ESCOLHA])
getwd()

#PACOTES
library(tidyverse)
library(ggplot2)

#OPTIONS
options(scipen = 999)
```

Em seguida, abrimos nosso arquivo **.csv** contendo nossos dados e o associamos a um objeto chamado **ds_sal**. A base contém o nome das variáveis no topo e valores separados por vírgula. Usamos o argumetno **dec** para definir o ponto final como divisor decimal.

```r
ds_sal <- read.csv("ds_salaries.csv",sep=",",dec=".",header = T)
```

Usamos a função **nrow** para obtermos o tamanho do nosso banco, isto é, quantas vagas estão contidas nele. Além disso, executamos um **unique** para **job_title** onde obtemos a relação dos cargos contidos na base. Por fim, rodamos **group_by** junto com um **summarise** para obter número de vagas para cada um deles organizado de forma decrescente. Como temos muitos cargos, pedimos apenas os 10 primeiros cargos.

```r
nrow(ds_sal)

unique(ds_sal$job_title)
```

![imagem]( "imagem 1")

```r
ds_sal %>% 
  group_by(job_title) %>% 
  summarise(contagem=n()) %>%
  arrange(desc(contagem))
```

![imagem]( "imagem 2")
