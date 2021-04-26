library(readr)
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(sunburstR)
library(shinydashboard)
library(plotly)
library(geojsonio)
library(leaflet)
library(shinydashboardPlus)
states <- geojson_read("https://raw.githubusercontent.com/codeforamerica/click_that_hood/master/public/data/brazil-states.geojson",  what = "sp")
dados<- read.csv2("C:/Users/gabri/Downloads/JN_25-Ago-2020.csv", header=T)
dados$sigla=(substr(dados$sigla,1,nchar(dados$sigla)-2))

despesas=dados[,c('uf_abrangida','uf_sede','dsc_tribunal',"justica",'ano',"sigla","h1","receitas",
                  'dk','dpe','dpea','dpei','dpj','dpjio','i','dinf1','dinf2','dinf3',"dpe",'dest',
                  'dter','dben','dip',"cc","tfc",'drh',"mag","mag1",'mag2','magje','magtr',"mage",
                  'mage1','mage2','mageje','magtr','ts','tvefet','tfauxc', 'tfauxe',
                  'tfauxjl', 'tfauxt',"magv")]

casos=dados[,c("justica","ano",'uf_abrangida','uf_sede',"sigla","h1",'cn','tbaix',
               'cnncrim','cnelet','cncrim','sent1','dec2')]

produtividade=dados[,c('uf_abrangida','uf_sede','dsc_tribunal',"justica",'ano',"sigla","h1",
                       'ipm','ipm1','ipm2','ipmje','ipmtr',"ips",
                       'ipsjud','ipsjud1','ipsjud2','ipsjudstm','ipsjudtr')]
assistencia=dados[,c('uf_abrangida','uf_sede','dsc_tribunal',"justica",'ano',"sigla",
                     'jg','a1','a2')]
##########################################################################################3

ui <- shinyUI(
  navbarPage("CNJ",tabPanel("Home",
                            tags$style(HTML("
                                      .navbar { background-color: #002f54;} #barra
                                      .navbar-default .navbar-nav > li > a {color:white; }
                                      .navbar-default .navbar-nav > .active > a,
                                      .navbar-default .navbar-nav > .active > a:focus,
                                      
                                      .tabs-above > .nav > li[class=active] > a {background-color: darkcyan;color:#FFF;} ##1A8E88 #cor abas e letras
                                      .tabbable > .nav > li >a{background-color: red; color:white;}
                                      .tabbable > .nav > li {float: left;width:25%; text-align: center;}
                                      .navbar-default .navbar-nav > li > a[data-value='home'] {float:right;}
                                    
                                     # .box {
                                     # background: white;
                                     # margin: auto;
                                     # margin-top: 5%;
                                     # padding: 20px 50px;
                                     # box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
                                     # transition: all 0.3s cubic-bezier(.25,.8,.25,1);
                                     # }
                                     # 
                                     # .box:hover {
                                     # border-top-left-radius: 10px;
                                     # border-bottom-left-radius: 10px;
                                     # animation-name: example;
                                     # animation-duration: 0.25s;
                                     # border-left: 8px solid darkblue;
                                     # box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
                                     # }
                                      "))
                            ,
                            tags$script(HTML('var fakeClick = function(tabName) {
                                              var dropdownList = document.getElementsByTagName("a");
                                              for (var i = 0; i < dropdownList.length; i++) {
                                              var link = dropdownList[i];
                                              if(link.getAttribute("data-value") == tabName) {
                                              link.click();
                                              };
                                              }
                                              };
                                              
                                              ')),
                            tags$head(
                              tags$style(
                                "body {overflow-x: hidden;}"
                              )
                            ),
                            div(
                              carousel(
                                id = "mycarousel",
                                carouselItem(
                                  caption = "Item 1",
                                  div(style="text-align: center;background-color: rgba(10,23,55,0.5);",
                                      img(src = "https://www.contabeis.com.br/assets/img/news/22369c50fddc77c69e16c09af2aa470a.jpg?v=",
                                          onclick = "fakeClick('Insumos')",width="750px",height="300px"))
                                ),
                                carouselItem(
                                  caption = "Item 2",
                                  div(style="text-align: center;background-color: rgba(10,23,55,0.5);",
                                      img(src = "https://www.viverhoje.org/site/assets/files/1896/leis-direitos_20160822.jpg",
                                          onclick = "fakeClick('Litigiosidade')",width="700px",height="300px"))
                                ),
                                carouselItem(
                                  caption = "Item 3",
                                  div(style="text-align: center;background-color: rgba(10,23,55,0.5);",
                                      img(src = "https://guimaraes-adv.com/wp-content/uploads/2018/09/25632879542.jpg",
                                          onclick = "fakeClick('Acesso a Justiça')",width="750px",height="300px"))
                                ),
                                carouselItem(
                                  caption = "Item 4",
                                  div(style="text-align: center;background-color: rgba(10,23,55,0.5);",
                                      img(src = "https://cerizze.com/wp-content/uploads/2019/04/o-tempo-e-o-processo.jpg",
                                          onclick = "fakeClick('Produtividade')",width="750px",height="300px"))
                                )
                                
                              ),style="width: 148%;
                               # height: 200px;
                               position: relative;left: 165px;bottom:10px;
                               margin-left: auto; margin-right: auto;
                               text-align: center;"
                            ),
                            
                            div(navlistPanel(
                              "Descrição",
                              tabPanel("Introdução",
                                       mainPanel("O judiciário é um dos três poderes do Estado, ele 
                                                  tem como principal função julgar e aplicar leis no 
                                                  país. O sistema judiciário é considerado lento por 
                                                  grande parte da população e um dos motivos para isso 
                                                  é que ele não consegue atender às demandas da justiça 
                                                  dentro do ritmo necessário, ou seja, os números de 
                                                  processos são muito maiores do que os magistrados e 
                                                  servidores conseguem finalizar, mesmo que os processos 
                                                  pendentes na Justiça estejam em queda, de acordo com
                                                  Relatório Justiça em Números 2019 da CNJ. Segundo o 
                                                  Diário Oficial da União de 2017,'mesmo que o Poder 
                                                  Judiciário fosse paralisado sem ingresso de novas 
                                                  demandas, com a atual produtividade de magistrados
                                                  e servidores, seriam necessários aproximadamente 3 
                                                  anos de trabalho para zerar o estoque', essa afirmação 
                                                  é preocupante pois, agrava a sensação de ineficiência 
                                                  do Poder Judiciário, nesse sentido, objetiva-se desenvolver
                                                  uma plataforma que permita analisar a produtividade de 
                                                  componentes desse setor. ",
                                                 style="width:173%;")),
                              tabPanel("Objetivos",
                                       mainPanel(p("Este é um projeto da equipe de Justiça e Números da 
                                                    disciplina Laboratório em Estatística, do Departamento 
                                                    de Estatística da Universidade de Brasília (UnB) com 
                                                    o Conselho Nacional de Justiça (CNJ)"),
                                                 p("Tornar o acesso aos dados do módulo de Produtividade Mensal do 
                                                    CNJ mais acessível, criando novos mecanismos de disponibilização 
                                                    dos dados e consequentemente comparação e avaliação da produtividade 
                                                    dos juízes e das unidades judiciárias"),
                                                 p("Criar uma plataforma que possibilite melhor 
                                                    visualização do cenário do sistema judicial brasileiro."),
                                                 style="width:173%;")),
                              "Infromação",
                              tabPanel("Variáveis"),
                              tabPanel("Referencias",
                                       mainPanel(p("Dados so Justiça e Números"),
                                                 p("Código no GitHub: ",
                                                   a(href = "https://github.com/talia499/labest",
                                                     target ="_blank","https://github.com/talia499/labest")),
                                                 style="width:173%;"
                                                 
                                       )),
                              "Sobre",
                              tabPanel("Integrantes",
                                       mainPanel(
                                         style="width:173%;",
                                         p(strong("Professores:")),
                                         p("Ana Maria Nogales"),
                                         p("Jhames Sampaio"),
                                         br(),br(),
                                         p(strong("Orientador:")),
                                         p("Gabriela Moreira de Azevedo Soares"),
                                         br(),br(),
                                         p(strong("Alunos:")),
                                         p("Larissa Moreno Silva"),
                                         p("Pedro Gabriel Moura"),
                                         p("Talia Alves Xavier")
                                       ))
                            ),style="width: 650px;position:relative; left:195px;bottom:-15px;
                       text-align: justify;")
                      ),
             
             tabPanel("Insumos",tags$style(type="text/css",
                                           ".shiny-output-error { visibility: hidden; }",
                                           ".shiny-output-error:before { visibility: hidden; }"),
                      inputPanel(
                        selectInput("jus",'Justiça',choices = unique(dados$justica)),
                        selectInput("tribunal","Tribunal",choices = unique(dados$sigla)),
                        selectInput("uf","UF",choices = unique(dados$uf_sede)),
                        selectInput("ano","Ano",choices = unique(dados$ano))
                        
                      ),
                      tabsetPanel(tabPanel("Despesas",
                                           mainPanel(
                                             div(
                                               plotOutput( "despesa1"),
                                               style = "width:600px ;position: relative;left: 0px;bottom:-30px;"),
                                             div(plotOutput("despesa2"),
                                                 style="width:600px ;position: relative;left: 650px;bottom:360px;"),
                                             div(plotOutput("a2"),
                                                 style="width:700px ;position: relative;left:0px;bottom:350px;")
                                           )),
                                  tabPanel("Força de Trabalho",
                                           mainPanel(
                                             div(plotOutput("ft1"),
                                                 style = "width:600px ;position: relative;left: 0px;bottom:-30px;"),
                                             div(plotOutput("ft2"),
                                                 style="width:600px ;position: relative;left: 650px;bottom:360px;"),
                                             div(box("Cargo magistrado",sunburstOutput("ft3")),
                                                 style="width:700px ;position: relative;left:100px;bottom:350px;"),
                                             div(plotOutput("ft4"),
                                                 style="width:700px ;position: relative;left:600px;bottom:720px;"),
                                             div(plotOutput("ft5"),
                                                 style="width:700px ;position: relative;left:0px;bottom:300px;"))
                                  ),
                                  tabPanel("Arrecadação",
                                           mainPanel(
                                             div(
                                               plotOutput( "a1"),
                                               style = "width:600px ;position: relative;left: 0px;bottom:-30px;"),
                                             div(plotOutput("despesa3"),
                                                 style="width:600px ;position: relative;left: 650px;bottom:360px;")
                                           )))
             ),
             
            
             tabPanel("Litigiosidade",
                      tags$style(type="text/css",
                                 ".shiny-output-error { visibility: hidden; }",
                                 ".shiny-output-error:before { visibility: hidden; }"),
                      sidebarPanel(style="width:300px;position: relative;left:0px;bottom:-70px;",
                                   selectInput("jus1",'Justiça',choices = unique(dados$justica)),
                                   selectInput("tribunal1","Tribunal",choices = unique(dados$sigla)),
                                   selectInput("uf1","UF",choices = unique(dados$uf_sede)),
                                   selectInput("ano1","Ano",choices = unique(dados$ano))
                                   
                      ),mainPanel(
                        div(plotOutput("l1"),
                            style="width:650px ;"),
                        div(plotOutput("l2"),
                            style="width:650px;")
                      )),
             tabPanel("Produtividade",
                      tags$style(type="text/css",
                                 ".shiny-output-error { visibility: hidden; }",
                                 ".shiny-output-error:before { visibility: hidden; }"),
                      tabsetPanel(
                        tabPanel("Indicadores",
                                 sidebarPanel(style="width:300px;position: relative;left:0px;bottom:-70px;",
                                              selectInput("jus2",'Justiça',choices = unique(dados$justica)),
                                              selectInput("tribunal2","Tribunal",choices = unique(dados$sigla)),
                                              selectInput("uf2","UF",choices = unique(dados$uf_sede)),
                                              selectInput("ano2","Ano",choices = unique(dados$ano))),
                                                     mainPanel(
                                                       div(plotlyOutput('i1'),
                                                           style="width:700px;position: relative;left:-130px;bottom:-50px;",))),
                        tabPanel("Tempo de Processo",
                                 sidebarPanel(style="width:300px;position: relative;left:0px;bottom:-70px;",
                                              selectInput("jus3",'Justiça',choices = unique(dados$justica)),
                                              selectInput("tribunal3","Tribunal",choices = unique(dados$sigla)),
                                              selectInput("uf3","UF",choices = unique(dados$uf_sede)),
                                              selectInput("ano3","Ano",choices = unique(dados$ano)))))),
             tabPanel("Acesso à Justiça",
                      tags$style(type="text/css",
                                 ".shiny-output-error { visibility: hidden; }",
                                 ".shiny-output-error:before { visibility: hidden; }"),
                      inputPanel(
                        selectInput("ano4","Ano",choices = unique(dados$ano))),
                      mainPanel(
                        div(leafletOutput("aj1"),
                            style="width:500px;position: relative;left:0px;bottom:-70px;"),
                        div(plotlyOutput("aj2"),
                             style="width:750px;position: relative;left:500px;bottom:350px;"))
                      )
             
            )
)
########################################
server <- function(input, output,session) {
  observeEvent(input$jus,{
    updateSelectInput(session,'tribunal',
                      choices=unique(despesas$sigla[despesas$justica %in% input$jus]))
  })
  
  observeEvent(c(input$jus, input$tribunal),{
    updateSelectInput(session,'uf',
                      choices=unique(despesas$uf_sede[despesas$justica %in% input$jus &
                                                        despesas$sigla %in% input$tribunal])
    )
  })
  #
  observeEvent(input$jus1,{
    updateSelectInput(session,'tribunal1',
                      choices=unique(casos$sigla[casos$justica %in% input$jus1]))
  })
  
  observeEvent(c(input$jus1, input$tribunal1),{
    updateSelectInput(session,'uf1',
                      choices=unique(casos$uf_sede[casos$justica %in% input$jus1 &
                                                        casos$sigla %in% input$tribunal1])
    )
  })
  #
  observeEvent(input$jus2,{
    updateSelectInput(session,'tribunal2',
                      choices=unique(produtividade$sigla[produtividade$justica %in% input$jus2]))
  })
  
  observeEvent(c(input$jus2, input$tribunal2),{
    updateSelectInput(session,'uf2',
                      choices=unique(produtividade$uf_sede[produtividade$justica %in% input$jus2 &
                                                        produtividade$sigla %in% input$tribunal2])
    )
  })
  #
  observeEvent(input$jus3,{
    updateSelectInput(session,'tribunal3',
                      choices=unique(produtividade$sigla[produtividade$justica %in% input$jus3]))
  })
  
  observeEvent(c(input$jus3, input$tribunal3),{
    updateSelectInput(session,'uf3',
                      choices=unique(produtividade$uf_sede[produtividade$justica %in% input$jus3 &
                                                             produtividade$sigla %in% input$tribunal3])
    )
  })
  #
  
  ###################################################################
  
  react1=reactive({
    d1=despesas%>%filter(justica %in% input$jus,sigla %in% input$tribunal,uf_sede %in% input$uf)%>%
      select(dpj,ano,dpjio,h1)%>%
      mutate(dpj=as.numeric(gsub(",",".",dpj)),dpjio=as.numeric(gsub(",",".",dpjio)))%>%
      group_by(ano)%>%
      summarise(dpj=sum(dpj)/sum(h1),dpjio=sum(dpjio)/sum(h1))
    d1
    
  })
  output$despesa1=renderPlot({
    ggplot(react1())+geom_line(aes(x=ano,y=dpj,colour="Despesas por habitantes"))+
      geom_line(aes(ano,dpjio,colour="Despesas por habitantes sem inativos/obras"))+ 
      scale_colour_manual(values=c("Despesas por habitantes"="blue",
                                   "Despesas por habitantes sem inativos/obras"="red"))+
      theme(legend.position="bottom")+labs(colour=" ")+
      ggtitle("Despesas Totais por habitantes segundo ano")+
      labs(x="Ano",y="Total")
    
  })
  
  react2=reactive({
    d3=despesas%>%filter(justica %in% input$jus,sigla %in% input$tribunal,uf_sede %in% input$uf)%>%
      select(ano, receitas, dpj)%>%
      mutate(receitas=as.numeric(gsub(",",".",receitas)),
             dpj=as.numeric(gsub(",",".",dpj)))
    d3
    
  })
  output$despesa2=renderPlot({
    
    ggplot(react2()) + 
      geom_line(mapping = aes(x = as.numeric(ano), y = dpj/1000000,fill="Despesas"),
                stat = "identity",colour="red") + 
      geom_bar(mapping = aes(x =as.numeric(ano),y=receitas/1000000,fill="Receitas"),stat="identity")+
      scale_x_continuous( breaks=c(209,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019))+
      labs(x="Ano",y="Total(em milhões)",fill=" ")+
      scale_fill_manual(values=c("Receitas"="blue",
                                 "Despesas"="red"))+
      
      theme(legend.position="bottom")+
      ggtitle("Totais de despesas e receitas segundo ano")
  })
  react3=reactive({
    d2=despesas%>%filter(ano %in% input$ano)%>%
      select(i,justica)%>%
      mutate(i=as.numeric(gsub(",",".",i)))%>%group_by(justica)%>%
      summarise(a=sum(i,na.rm=T))%>%mutate(a=a/sum(a,na.rm=T))
    
    d2 
  })
  output$despesa3=renderPlot({
    ggplot(subset(react3(),a >= 0.0001),
           aes(x="",y=a,fill=levels(factor(justica))))+geom_bar(stat="identity",width = 1)+
      coord_polar("y", start=0)+
      labs(fill="Justiça",y="",x="")+
      ggtitle("Arrecadação sobre a despesa total da Justiça")+
      scale_fill_brewer(palette="Set1")+
      geom_text(aes(label = paste0(round(a*100), "%")), position = position_stack(vjust = 0.5))+
      theme(axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.grid  = element_blank())
  })
  react4=reactive({
    d2=despesas%>%filter(justica %in% input$jus,sigla %in% input$tribunal,uf_sede %in% input$uf)%>%
      select(ano, i)%>%
      mutate(i=as.numeric(gsub(",",".",i))*100)
    d2
  })
  output$a1=renderPlot({
    ggplot(react4(), aes(x=factor(ano)))+geom_col(aes(y=i),fill = "#ffae00")+
      ggtitle("Arrecadação sobre a despesa total da Justiça segundo ano")+
      labs(x="Ano",y="Percentual")
  })
  react5=reactive({
    d4=despesas%>%filter(justica %in% input$jus,sigla %in% input$tribunal,uf_sede %in% input$uf)%>%
      select(ano, dk,dinf1,dinf2,dinf3)%>%
      mutate(dinf1=as.numeric(gsub(",",".",dinf1)),
             dinf2=as.numeric(gsub(",",".",dinf2)),
             dinf3=as.numeric(gsub(",",".",dinf3)),
             dk=as.numeric(gsub(",",".",dk)))
    d4=d4%>%mutate(di=rowSums(d4[,3:5],na.rm=T))
    d4
  })
  output$a2=renderPlot({
    ggplot(react5())+geom_line(aes(x=ano,y=dk,colour="Despesas com capital"))+
      geom_line(aes(x=ano,y=di,colour="Despesas com Informatica"))+
      scale_colour_manual(values=c("Despesas com Informatica"="red",
                                   "Despesas com capital"="blue"))+
      theme(legend.position="bottom")+labs(colour="",y="Total", x="Ano")+
      scale_x_continuous( breaks=c(2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019))+
      ggtitle("Despesas com capital e informática segundo ano")
  })
  react6=reactive({
    d5=despesas%>%
      filter(justica %in% input$jus,sigla %in% input$tribunal,uf_sede %in% input$uf,
             ano %in% input$ano)%>%
      select(dpe,dest,dter,dben)%>% mutate(dpe=as.numeric(gsub(",",".",dpe)),
                                           dest=as.numeric(gsub(",",".",dest)),
                                           dter=as.numeric(gsub(",",".",dter)),
                                           dben=as.numeric(gsub(",",".",dben)))
    
    d5<- rownames_to_column(data.frame(count=t(d5)), "Despesa")
    d5$count=d5$count/sum(d5$count)
    d5
  })
  
  output$ft1=renderPlot({
    ggplot(data=subset(react6(),count >= 0.001),
           aes(x="",y=round(count,2),fill=levels(factor(Despesa))))+
      geom_bar(stat="identity",width = 1)+
      coord_polar("y", start=0)+
      labs(fill="Justiça",y="",x="")+
      ggtitle("Despesas com Recursos Humanos")+
      scale_fill_brewer(palette="Set1")+
      geom_label_repel(aes(y = round(count,2), label = paste0(round(count*100,3), "%")), 
                       data = react6(), size=4, show.legend = F, nudge_x = 1) +
      theme(axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.grid  = element_blank())
    
  })
  react7=reactive({
    d6=despesas%>%
      filter(justica %in% input$jus,sigla %in% input$tribunal,uf_sede %in% input$uf,
             ano %in% input$ano)%>%
      select(cc,tfc,mag,ts)%>% mutate(cc=as.numeric(gsub(",",".",cc)),
                                      tfc=as.numeric(gsub(",",".",tfc)),
                                      mag=as.numeric(gsub(",",".",mag)),
                                      ts=as.numeric(gsub(",",".",ts)))
    d6<- rownames_to_column(data.frame(count=t(d6)), "trabalho")
    d6
  })
  
  output$ft2=renderPlot({
    ggplot(react7())+geom_col(aes(x=factor(trabalho),y=count))
    
  })
  
  output$ft3=renderSunburst({
    d7=despesas%>%
      filter(justica=="Estadual",despesas$sigla=="TJ",despesas$uf_sede=="AC",ano=="2010")%>%
      select(mag,mage,mag1, mag2,magje, mage1, mage2, mageje,magv)%>%
      mutate(mgv=as.numeric(as.numeric(mage))-as.numeric(as.numeric(mag)),
             mgv1=as.numeric(mage1)-as.numeric(mag1),
             mgv2=as.numeric(mage2)-as.numeric(mag2),
             mgvje=as.numeric(mageje)-as.numeric(magje))%>%
      select(mag1, mag2,magje,mgv1,mgv2,mgvje)
    d7= rownames_to_column(data.frame(count=t(d7)), "cargo")
    
    d7=data.frame(v1=c(paste0("Cargos Ocupados","-",d7$cargo[1:3]),
                       paste0("Cargos Vagos","-",d7$cargo[4:6])),
                  v2=d7$count)
   sunburst(d7)
    
})
react9=reactive({
  d8=despesas%>%
    filter(justica %in% input$jus,sigla %in% input$tribunal,uf_sede %in% input$uf,
           ano %in% input$ano)%>%
    select(ts,tvefet,mag,magv)%>%
    mutate_at(vars(ends_with("_id")), funs(as.numeric(as.character(.))))
   d8= rownames_to_column(data.frame(count=t(d8)), "cargo")
   d8$s=c("servidor","servidor","magristrado","magristrado")
   d8
 })
 
output$ft4=renderPlot({
  ggplot(react9())+geom_col(aes(x=cargo,y=count,
                                fill=factor(s)),
                            position = "dodge")+
    labs(fill="",y=" Quantidade",x="")+
    theme(legend.position="bottom")+labs(colour=" ")
})


output$ft5=renderPlot({
  d9=despesas%>%
    filter(justica %in% input$jus,sigla %in% input$tribunal,uf_sede %in% input$uf,
           ano %in% input$ano)%>%
    select(tfauxc, tfauxe, tfauxjl, tfauxt)%>%
    mutate_at(vars(ends_with("_id")), funs(as.numeric(as.character(.))))
  d9= rownames_to_column(data.frame(count=t(d9)), "auxiliar")%>%
    mutate(count=as.numeric(count))
   
  d9$fraction <- d9$count / sum(d9$count)
  d9$ymax <- cumsum(d9$fraction)
  d9$ymin <- c(0, head(d9$ymax, n=-1))
  d9$labelPosition <- (d9$ymax + d9$ymin) / 2
  d9$label <- paste0(d9$auxiliar, "\n value: ", d9$count)
  ggplot(d9, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=auxiliar)) +
    geom_rect() +
    coord_polar(theta="y") +
    xlim(c(2, 4)) +
    theme(legend.text = element_text(colour="blue", size=10, 
                                     face="bold"))+
    scale_fill_manual(labels = c(paste0(d9$auxiliar,": ",d9$count)),
                      values=c("red","green","blue","yellow"))+
    labs(fill=" ")+
    theme_void()
})
#############################################################################
  
  react11=reactive({
   c1=casos%>%
     filter(justica %in% input$jus1,sigla %in% input$tribunal1,uf_sede %in% input$uf1)%>%
     select( ano,cn,tbaix)%>%
     mutate(cn=as.numeric(cn),
            tbaix=as.numeric(tbaix))
   c1
})
 output$l1=renderPlot({
   ggplot(react11())+geom_line(aes(x=ano,y=cn,colour="Casos Novos"))+
     geom_line(aes(x=ano,y=tbaix,colour="Casos Baixados"))+
     scale_colour_manual(values=c("Casos Novos"="red",
                                  "Casos Baixados"="blue"))+
     labs(colour="")+theme(legend.position="bottom")
   
 })
 react12=reactive({
   c2=casos%>%
     filter(justica %in% input$jus1,sigla %in% input$tribunal1,uf_sede %in% input$uf1,
            ano %in% input$ano1)%>%
     select(cnncrim,cnelet,cncrim)%>%
     mutate_if(is.character, as.numeric)
   
   c2=rownames_to_column(data.frame(count=t(c2)), "cn")
   c2
 })
 output$l2=renderPlot({
   ggplot(react12())+geom_col(aes(x=cn,y=count))
 })
  ###################################################################
  react13=reactive({
    p1=produtividade%>%
      filter(justica %in% input$jus2,sigla %in% input$tribunal2,uf_sede %in% input$uf2,
             ano %in% input$ano2)%>%
      select(ipm,ipm1,ipm2,ipmje,ipmtr,ips,ipsjud,ipsjud1,ipsjud2,ipsjudtr)%>%
      mutate_all(funs(gsub(",", ".", .) ))%>%
      mutate_all(funs(round(as.numeric(.),2)))
    p1=rownames_to_column(data.frame("produtividade"=t(p1)), "indice")
    p1
  })
  output$i1=renderPlotly({
    
    plot_ly(type="table",
            header=list(values=names(react13()),  align = c('center', rep('center', ncol(react13()))),
                        line = list(width = 1, color = 'black'),
                        fill = list(color = "darkblue"),
                        font = list(family = "Arial", size = 14, color = "white")),
            cells=list(values=unname(react13()),
                       font = list(family = "Arial", size = 14, color = c("white","black")),
                       fill = list(color = c("darkblue", '#B0C4DE')))) 
  })
  
  
#################################################
output$aj1=renderLeaflet({
  a1=assistencia%>%filter(ano %in% input$ano4)%>%mutate(jg=as.numeric(gsub(",",".",jg)))%>%
    group_by(uf_sede)%>%
    summarise(jg=sum(jg,na.rm =T))%>%filter(uf_sede!="BR")
  
  a1[28,]=a1[7,]
  a1=a1[-7,]
  
  states2<-cbind(states,a1)
  bins <- c(0, 100000,200000,500000,1000000,2000000,5000000, Inf)
  pal <- colorBin("PuBu", domain =states2$jg, bins = bins)
  labels <- sprintf(
    "<strong>%s</strong><br/>%s Assistência Judiciária Gratuita </sup>",
    states$name, states2$jg
  ) %>% lapply(htmltools::HTML)
  
  leaflet(states) %>%
    setView(-47, -15.8, 3) %>%
    addProviderTiles("Stamen.Watercolor", options = providerTileOptions(
      id = "mapbox.light",
      accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
    addPolygons(
      fillColor = ~pal(states2$jg),
      weight = 2,
      opacity = 1,
      color = "white",
      dashArray = "3",
      fillOpacity = 0.7,
      highlight = highlightOptions(
        weight = 5,
        color = "#666",
        dashArray = "",
        fillOpacity = 0.7,
        bringToFront = TRUE),
      label = labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto")) %>%
    addLegend(pal = pal, values = ~regiao_id, opacity = 0.7, title = NULL,
              position = "bottomleft")%>%
    addMeasure(position = "bottomleft")
  
})
output$aj2=renderPlotly({
  a2=assistencia%>%filter(ano %in% input$ano4)%>%
    select(a1,a2,uf_sede)%>%
    mutate(a1=as.numeric(gsub(",",".",a1)),
           a2=as.numeric(gsub(",",".",a2)))%>%
    group_by(uf_sede)%>%
    summarise(a1=sum(a1,na.rm =T),
              a2=sum(a2,na.rm=T))%>%filter(uf_sede!="BR")
  
  a2[28,]=a2[7,]
  a2=a2[-7,]
  a2<-cbind(states@data[,3:4],a2)
  a2$regiao_id[a2$regiao_id==1]="sul"
  a2$regiao_id[a2$regiao_id==2]="sudeste"
  a2$regiao_id[a2$regiao_id==3]="norte"
  a2$regiao_id[a2$regiao_id==4]="nordeste"
  a2$regiao_id[a2$regiao_id==5]="centro oeste"
  a2=a2%>%group_by(regiao_id)%>%
    summarise(a1=round(sum(a1,na.rm =T),2),
              a2=round(sum(a2,na.rm=T),2))
  
  
  plot_ly(type="table",
          header=list(values=names(a2),  align = c('center', rep('center', ncol(a2))),
                      line = list(width = 1, color = 'black'),
                      fill = list(color = "darkblue"),
                      font = list(family = "Arial", size = 14, color = "white")),
          cells=list(values=unname(a2),
                     font = list(family = "Arial", size = 14, color = c("white","black")),
                     fill = list(color = c("darkblue", '#B0C4DE')))) 
  
  
 })
}

shinyApp(ui, server)
