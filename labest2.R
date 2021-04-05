library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
ui = shinyUI(
  
  navbarPage("CNJ",
             tabPanel("home",
                      tags$style(HTML("
                                      .navbar { background-color: darkblue;}
                                      .navbar-default .navbar-nav > li > a {color:white; }
                                      .navbar-default .navbar-nav > .active > a,
                                      .navbar-default .navbar-nav > .active > a:focus,
                                      
                                      .tabs-above > .nav > li[class=active] > a {background-color: red;color: #FFF;}
                                      .tabbable > .nav > li >a{background-color: red; color:white;}
                                      .tabbable > .nav > li {float: left;width:25%; text-align: center;}
                                      .navbar-default .navbar-nav > li > a[data-value='home'] {float:right;}
                                      
                                      ")),
                      tags$head(tags$script(HTML('
                                                 var fakeClick = function(tabName) {
                                                 var dropdownList = document.getElementsByTagName("a");
                                                 for (var i = 0; i < dropdownList.length; i++) {
                                                 var link = dropdownList[i];
                                                 if(link.getAttribute("data-value") == tabName) {
                                                 link.click();
                                                 };
                                                 }
                                                 };
                                                 '))),
                      fluidPage(
                        box(h3("Insumos e Despesas"),h4("Descrição"),onclick = "fakeClick('Insumos')",img(src="https://www.contabeis.com.br/assets/img/news/22369c50fddc77c69e16c09af2aa470a.jpg?v=", width='50%')),
                        box(h3("Litigiosidade"),h4("Descrição"), onclick = "fakeClick('Litigiosidade')",img(src="https://www.viverhoje.org/site/assets/files/1896/leis-direitos_20160822.jpg", width='50%')),
                        box(h3("Acesso a Justiça"),h4("Descrição"), onclick = "fakeClick('Acesso à Justiça')",img(src="https://lh3.googleusercontent.com/proxy/pAQu5aWCMnyQ8wHTvSmSXAQPEaTVAYCBwWUZ-EpP3krej8KKx7hXPXAONXu9kTdlXPQoHaKHXFIe_TDZyne0-gnbblOdw4zTEkL5chDrXaiRobEriSp5oF7EwmQS", width='50%')),
                        box(h3("Tempo de Processo"),h4("Descrição"),
                            img(src="https://cerizze.com/wp-content/uploads/2019/04/o-tempo-e-o-processo.jpg", width='50%'),onclick = "fakeClick('Tempo de Processo')")
                      )
                      ), 
             ##########################################################################
             tabPanel("Insumos",
                      tabsetPanel(tabPanel("Financeiros"),
                                  tabPanel("Humanos"),
                                  tabPanel("Físicos")),
                      sidebarLayout(
                        sidebarPanel(width = 2,
                          selectInput("vara",'Vara',choices = c("a","b")),
                          selectInput("municipios","Municípios",choices=c("c")),
                          selectInput("tribunal","Tribunal",choices = c("d")),
                          dateInput("date", "Data", value = "2012-02-29",
                                    datesdisabled = c("2012-03-01", "2012-03-02"))
                        ),
                        mainPanel())),
             ###########################################################################              
             tabPanel("Litigiosidade",
                      tabsetPanel(tabPanel("1º grau"),
                                  tabPanel("2º grau"),
                                  tabPanel("Turma Recursal"),
                                  tabPanel("Juizado Especial")),
                      sidebarLayout(
                        sidebarPanel(width = 2,
                          selectInput("vara",'Vara',choices = c("a","b")),
                          selectInput("municipios","Municípios",choices=c("c")),
                          selectInput("tribunal","Tribunal",choices = c("d")),
                          dateInput("date", "Data", value = "2012-02-29",
                                    datesdisabled = c("2012-03-01", "2012-03-02"))
                        ),
                        mainPanel())),
             ##########################################################################
             tabPanel("Acesso à Justiça",  sidebarLayout(
               sidebarPanel(width = 2,
                 selectInput("vara",'Vara',choices = c("a","b")),
                 selectInput("municipios","Municípios",choices=c("c")),
                 selectInput("tribunal","Tribunal",choices = c("d")),
                 dateInput("date", "Data", value = "2012-02-29",
                           datesdisabled = c("2012-03-01", "2012-03-02"))
               ),
               mainPanel())),
             #########################################################################
             tabPanel("Tempo de Processo",
                      tabsetPanel(tabPanel("1º grau"),
                                  tabPanel("2º grau"),
                                  tabPanel("Turma Recursal"),
                                  tabPanel("Juizado Especial")),
                        sidebarLayout(
                        sidebarPanel(width = 2,
                                     selectInput("vara",'Vara',choices = c("a","b")),
                                     selectInput("municipios","Municípios",choices=c("c")),
                                     selectInput("tribunal","Tribunal",choices = c("d")),
                                     dateInput("date", "Data", value = "2012-02-29",
                                               datesdisabled = c("2012-03-01", "2012-03-02"))
                        ),
                        mainPanel())),
             ########################################################################
             tabPanel(value="home",socialButton(
               href = "https://github.com/talia499/labest",
               icon = icon("github")
             )
             )
                      )

                      )


server = function(input, output, session){}
shinyApp(ui, server)