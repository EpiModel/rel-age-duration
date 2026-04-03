library(shiny)

ui <- fluidPage(
  titlePanel(h3("Relational duration and the age of extant relationships"),
                windowTitle = "Relational Duration and Age"),
  headerPanel(h5(
                 h4(strong("Introduction:")),

                 p("This app helps demonstrate the connections between",
                   strong("relational duration"), "and",
                   strong("relational age"),
                   "for different distributions of
                    relational duration.", style = "margin-bottom: 12px"),

                 p("By relational duration, we mean the amount of time that a relationship
                    lasts before it ends.", style = "margin-bottom: 12px"),

                 p("By relational age, we mean how old an ongoing (a.k.a. extant)
                    relationship is when it is observed at a specific time
                    point.", style = "margin-bottom: 12px"),

                 p("In particular, the app demonstrates the somewhat counter-intutive connections
                    between the two when relationship durations follow a",
                   strong("memoryless"),
                   "distribution. Since the model here operates in discrete time,
                    the relevant distribution is the",
                   strong("geometric,"), "but the principle applies as well to
                    continuous-time phenomena that follow the exponential distribution.",
                   style = "margin-bottom: 12px"),

                 h4(strong("Instructions:")),

                 p("Select a time window size, expected relational duration,
                   number of relations, and distribution for relational durations from
                   the options on the left. Observe the simulation in the plot on the right,
                   and read the resulting metrics below.", style = "margin-bottom: 12px"),

                 h4(strong("Details:")),

                 p("The app simulates a user-specified number of relationships,
                    each beginning at a random time point across a time window of
                    user-specified width. Relationships have a user-specified mean duration,
                    with a distribution selected from a menu of
                    options. The app then selects an observation day randomly (although not
                    too close to the edges of the window, to avoid dealing with boundary
                    issues).", style = "margin-bottom: 12px"),

                 p("For all relationships existing on that day, the app calculates:"),
                 tags$ol(
                   tags$li("the", strong("mean duration for all relationships,"),
                           "regardless of whether they exist on the observation day"),
                   tags$li("the", strong("mean relational age"), "on that day,
                           i.e. time to the left of the observation day"),
                   tags$li("the", strong("mean time remaining"), "on that day,
                           i.e. time to the right of the observation day"),
                   tags$li("the", strong("mean duration for extant relationships"), "on the observation day,
                           i.e. the sum of #1 and #2")
                 )
                 )),
  sidebarLayout(
    sidebarPanel(
      sliderInput("WindowSizeInput", "Window size", min = 1000, max = 10000,
                  value = c(1000)),
      sliderInput("ExpectedDurationInput", "Expected relational duration", min = 2, max = 100,
                  value = c(50)),
      sliderInput("NumRelationsInput", "# of relations", min = 100, max = 10000,
                  value = c(5000)),
      radioButtons("DistInput", "Distribution of relational durations",
                   choices = c("All equal", "Geometric", "Uniform"),
                   selected = "Geometric")
      ),
    mainPanel(
      plotOutput("timeplot"),
      h5(htmlOutput("recap")),
      plotOutput("durhist")
    )
  )
)

server <- function(input, output) {

  ####### Generate the relationship start and end times #######
  exp_num_extant_ties <- reactive({input$NumRelationsInput*input$ExpectedDurationInput/input$WindowSizeInput})
  starts <- reactive({sample(1:input$WindowSizeInput, input$NumRelationsInput, replace=T)})

  durs <- reactive({
    (input$DistInput=="All equal") * rep(input$ExpectedDurationInput, input$NumRelationsInput) +
    (input$DistInput=="Geometric") * (rgeom(input$NumRelationsInput, 1/input$ExpectedDurationInput)+1) +
    (input$DistInput=="Uniform") * sample(1:(2*input$ExpectedDurationInput-1), input$NumRelationsInput, replace=TRUE)
  })

  ends <- reactive({starts()+durs()})
  reltimes <- reactive({cbind(starts(),ends())})

  ####### Pick the observation day (not too close to either end to avoid artifacts) #######
  obs_day <- reactive({sample( (2*input$ExpectedDurationInput+1) :
                      (input$WindowSizeInput - 2*input$ExpectedDurationInput), 1)})

  ####### Calculate metrics of interest #######
  meandur <- reactive({mean(durs())})
  rels_obs <- reactive({which(reltimes()[,1] <= obs_day() & reltimes()[,2] > obs_day())})
  rel_age <- reactive({obs_day() - starts()[rels_obs()] + 1})
  mean_age <- reactive({mean(rel_age())})
  time_remaining <- reactive({ends()[rels_obs()] - obs_day() - 1})
  mean_time_remaining <- reactive({mean(time_remaining())})

  output$timeplot <- renderPlot({
    plot(0,0, xlim = c(0,input$WindowSizeInput),
         ylim=c(0,input$NumRelationsInput), col='white',
         xlab="time", ylab="relationship #")
    invisible(sapply(1:input$NumRelationsInput, function(x)
      lines(reltimes()[x,], c(x,x))))
    abline(v=obs_day(), col='red', lwd=3)
  })

  output$recap <- renderUI({
    str1 <- paste("Expected mean relational duration is ", input$ExpectedDurationInput, ";",
                   " actual mean relational duration is ", round(meandur(),1), ".", sep="")
    str2 <- paste("We randomly pick day ", obs_day(), " as our observation day (seen in red).", sep="")
    str3 <- paste("We expect about ", exp_num_extant_ties(),
                    " relationships to exist on any given day. On our selected day, ",
                   length(rels_obs()), " relationships exist.", sep="")
    str4 <- paste("Among the extant ties, the mean relational age on
                  observation day is ", round(mean_age(),1),
                  ", which is ", 100*round(mean_age()/meandur(),3), "% of the mean relational
                  duration for all relationships of ",round(meandur(),1),".", sep="")
    str5 <- paste("Among the extant ties, the mean time remaining until relational
                  termination (the right-censored part) is ", round(mean_time_remaining(),1),
                  ", which is ", 100*round(mean_time_remaining()/meandur(),3), "% of the
                  mean relational duration for all relationships of ",round(meandur(),1),".", sep="")
    str6 <- paste("This means that the final mean duration of the relationships
                  existing on the observation day is ",
                round(mean_age() + mean_time_remaining(),1), ", which is ",
                100*round((mean_age()+mean_time_remaining())/meandur(),3),
                "% of the mean duration of *all* relationships, ",
                round(meandur(),1), ".\n", sep="")

    HTML(paste(tags$li(str1), tags$li(str2), tags$li(str3), tags$li(str4), tags$li(str5), tags$li(str6),
                sep = '<br/>'))
    })

    output$durhist <- renderPlot({
      par(mfrow=c(2,1))
      ifelse(input$DistInput=="All equal",
        hist(durs(), xlab="duration", ylab="# relationships",
             main = "Distribution of all relational durations",
             xlim=c(0,2*input$ExpectedDurationInput)),
        hist(durs(), xlab="duration", ylab="# relationships",
             main = "Distribution of all relational durations"))
      ifelse(input$DistInput=="All equal",
        hist(durs()[rels_obs()], xlab="duration", ylab="# relationships",
             main = "Distribution of relational durations for relations extant on observation day",
             xlim=c(0,2*input$ExpectedDurationInput)),
        hist(durs()[rels_obs()], xlab="duration", ylab="# relationships",
             main = "Distribution of relational durations for relations extant on observation day"))
    })

}

shinyApp(ui = ui, server = server)
