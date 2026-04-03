library(shiny)

ui <- fluidPage(

  tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700&display=swap",
      rel = "stylesheet"
    ),
    tags$style(HTML("
      /* ---- Base ---- */
      body {
        font-family: 'Open Sans', -apple-system, BlinkMacSystemFont, sans-serif;
        color: #444;
        background-color: #f0f5f9;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
      }
      .container-fluid {
        max-width: 1100px;
        padding: 0 2rem;
      }

      /* ---- Header banner ---- */
      .app-header {
        background: linear-gradient(135deg, #3a6f99, #4682B4);
        color: #ffffff;
        padding: 1.6rem 2rem;
        margin: -15px -15px 1.5rem -15px;
        border-radius: 0 0 8px 8px;
      }
      .app-header h2 {
        font-weight: 700;
        font-size: 1.6rem;
        margin: 0 0 0.3rem 0;
      }
      .app-header p {
        font-size: 1.0rem;
        margin: 0;
        opacity: 0.9;
      }

      /* ---- Cards ---- */
      .card {
        background: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 1.25rem;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        margin-bottom: 1.25rem;
      }
      .card h4 {
        font-weight: 600;
        font-size: 1.05rem;
        color: #1a6b54;
        margin-top: 0;
        margin-bottom: 0.75rem;
        padding-bottom: 0.5rem;
        border-bottom: 2px solid #e8eef3;
      }
      .card p, .card li {
        font-size: 0.95rem;
        line-height: 1.6;
        color: #555;
      }
      .card ol {
        padding-left: 1.2rem;
      }
      .card ol li {
        padding: 0.2rem 0;
      }
      .card strong {
        color: #1a6b54;
      }

      /* ---- Sidebar controls ---- */
      .well {
        background: #ffffff !important;
        border: 1px solid #dee2e6 !important;
        border-radius: 8px !important;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05) !important;
        padding: 1.25rem !important;
      }
      .control-label {
        font-weight: 600;
        font-size: 0.9rem;
        color: #3a6f99;
      }
      .irs--shiny .irs-bar {
        background: #4682B4;
        border-top: 1px solid #3a6f99;
        border-bottom: 1px solid #3a6f99;
      }
      .irs--shiny .irs-single,
      .irs--shiny .irs-from,
      .irs--shiny .irs-to {
        background-color: #4682B4;
      }
      .irs--shiny .irs-handle {
        border: 1px solid #4682B4;
      }
      .radio label {
        font-size: 0.9rem;
        color: #555;
      }

      /* ---- Plot containers ---- */
      .plot-card {
        background: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 1rem;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        margin-bottom: 1.25rem;
      }

      /* ---- Results list ---- */
      .results-card {
        background: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 1.25rem;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        margin-bottom: 1.25rem;
      }
      .results-card .results-title {
        font-weight: 600;
        font-size: 1.05rem;
        color: #1a6b54;
        margin-top: 0;
        margin-bottom: 0.75rem;
        padding-bottom: 0.5rem;
        border-bottom: 2px solid #e8eef3;
      }
      .results-card li {
        font-size: 0.93rem;
        line-height: 1.6;
        color: #555;
        padding: 0.3rem 0;
        border-bottom: 1px solid #f0f0f0;
        list-style: none;
        padding-left: 0.2rem;
      }
      .results-card li:last-child {
        border-bottom: none;
      }
      .results-card ul {
        padding-left: 0;
        margin: 0;
      }

      /* ---- Footer ---- */
      .app-footer {
        text-align: center;
        color: #777;
        font-size: 0.85rem;
        padding: 1rem 0 1.5rem 0;
      }
      .app-footer a {
        color: #4682B4;
        text-decoration: none;
      }
      .app-footer a:hover {
        color: #1a6b54;
        text-decoration: underline;
      }
    "))
  ),

  # ---- Header ----
  div(class = "app-header",
    h2("Relational Duration and the Age of Extant Relationships"),
    p("An interactive simulation from the EpiModel ecosystem")
  ),

  # ---- Info panels ----
  fluidRow(
    column(6,
      div(class = "card",
        h4("Introduction"),
        p("This app demonstrates the connections between",
          strong("relational duration"), "(how long a relationship lasts) and",
          strong("relational age"), "(how old an ongoing relationship is when observed)."),
        p("In particular, it illustrates the counter-intuitive properties of",
          strong("memoryless"), "distributions. Since the model operates in discrete
           time, the relevant distribution is the",
          strong("geometric,"), "but the principle applies equally to
           continuous-time phenomena following the exponential distribution.")
      )
    ),
    column(6,
      div(class = "card",
        h4("How It Works"),
        p("The app simulates relationships that each begin at a random time
           across a configurable window. Durations are drawn from your chosen
           distribution. A random observation day is selected, and for all
           relationships existing on that day, the app computes:"),
        tags$ol(
          tags$li("The", strong("mean duration"), "of all relationships"),
          tags$li("The", strong("mean relational age"), "(time since start)"),
          tags$li("The", strong("mean time remaining"), "(time until end)"),
          tags$li("The", strong("mean duration of extant relationships"),
                  "(sum of age + time remaining)")
        )
      )
    )
  ),

  # ---- Simulation ----
  sidebarLayout(
    sidebarPanel(width = 3,
      tags$h4(style = "font-weight: 600; font-size: 1.05rem; color: #1a6b54;
                        margin-top: 0; margin-bottom: 0.75rem; padding-bottom: 0.5rem;
                        border-bottom: 2px solid #e8eef3;",
               "Parameters"),
      sliderInput("WindowSizeInput", "Window size",
                  min = 1000, max = 10000, value = 1000),
      sliderInput("ExpectedDurationInput", "Expected relational duration",
                  min = 2, max = 100, value = 50),
      sliderInput("NumRelationsInput", "Number of relations",
                  min = 100, max = 10000, value = 5000),
      radioButtons("DistInput", "Duration distribution",
                   choices = c("All equal", "Geometric", "Uniform"),
                   selected = "Geometric")
    ),
    mainPanel(width = 9,
      div(class = "plot-card",
        plotOutput("timeplot", height = "340px")
      ),
      div(class = "results-card",
        div(class = "results-title", "Simulation Results"),
        htmlOutput("recap")
      ),
      div(class = "plot-card",
        plotOutput("durhist", height = "420px")
      )
    )
  ),

  # ---- Footer ----
  div(class = "app-footer",
    p("Part of the",
      tags$a(href = "https://epimodel.org", "EpiModel"),
      "ecosystem \u2022 Powered by",
      tags$a(href = "https://posit-dev.github.io/r-shinylive/", "shinylive"))
  )
)


server <- function(input, output) {

  # ---- EpiModel-inspired plot palette ----
  col_steelblue <- "#4682B4"
  col_teal <- "#1a6b54"
  col_obs <- "#c0392b"

  ####### Generate the relationship start and end times #######
  exp_num_extant_ties <- reactive({
    input$NumRelationsInput * input$ExpectedDurationInput / input$WindowSizeInput
  })

  starts <- reactive({
    sample(1:input$WindowSizeInput, input$NumRelationsInput, replace = TRUE)
  })

  durs <- reactive({
    (input$DistInput == "All equal") *
      rep(input$ExpectedDurationInput, input$NumRelationsInput) +
    (input$DistInput == "Geometric") *
      (rgeom(input$NumRelationsInput, 1 / input$ExpectedDurationInput) + 1) +
    (input$DistInput == "Uniform") *
      sample(1:(2 * input$ExpectedDurationInput - 1),
             input$NumRelationsInput, replace = TRUE)
  })

  ends     <- reactive({ starts() + durs() })
  reltimes <- reactive({ cbind(starts(), ends()) })

  ####### Pick the observation day #######
  obs_day <- reactive({
    sample((2 * input$ExpectedDurationInput + 1):
           (input$WindowSizeInput - 2 * input$ExpectedDurationInput), 1)
  })

  ####### Metrics #######
  meandur            <- reactive({ mean(durs()) })
  rels_obs           <- reactive({ which(reltimes()[, 1] <= obs_day() &
                                         reltimes()[, 2] >  obs_day()) })
  rel_age            <- reactive({ obs_day() - starts()[rels_obs()] + 1 })
  mean_age           <- reactive({ mean(rel_age()) })
  time_remaining     <- reactive({ ends()[rels_obs()] - obs_day() - 1 })
  mean_time_remaining <- reactive({ mean(time_remaining()) })

  ####### Timeline plot #######
  output$timeplot <- renderPlot({
    par(family = "sans", mar = c(4, 4, 2, 1), bg = "#ffffff")
    plot(0, 0, xlim = c(0, input$WindowSizeInput),
         ylim = c(0, input$NumRelationsInput), col = "white",
         xlab = "Time", ylab = "Relationship #",
         main = "Simulated Relationships",
         col.main = col_teal, font.main = 2, cex.main = 1.2,
         col.lab = "#555", cex.lab = 1.0, col.axis = "#777")
    invisible(sapply(1:input$NumRelationsInput, function(x)
      lines(reltimes()[x, ], c(x, x), col = col_steelblue, lwd = 0.4)))
    abline(v = obs_day(), col = col_obs, lwd = 3, lty = 1)
    legend("topright",
           legend = paste("Observation day:", obs_day()),
           col = col_obs, lwd = 3, bty = "n", text.col = "#555")
  })

  ####### Results text #######
  output$recap <- renderUI({
    items <- c(
      sprintf("Expected mean relational duration is %s; actual mean is %s.",
              input$ExpectedDurationInput, round(meandur(), 1)),
      sprintf("Randomly selected observation day: %s (shown in red).",
              obs_day()),
      sprintf("Expected extant ties: %s. Observed on this day: %s.",
              round(exp_num_extant_ties(), 0), length(rels_obs())),
      sprintf("Mean relational age of extant ties: %s (%s%% of mean duration %s).",
              round(mean_age(), 1),
              round(100 * mean_age() / meandur(), 1),
              round(meandur(), 1)),
      sprintf("Mean time remaining for extant ties: %s (%s%% of mean duration %s).",
              round(mean_time_remaining(), 1),
              round(100 * mean_time_remaining() / meandur(), 1),
              round(meandur(), 1)),
      sprintf("Mean duration of extant ties: %s (%s%% of overall mean duration %s).",
              round(mean_age() + mean_time_remaining(), 1),
              round(100 * (mean_age() + mean_time_remaining()) / meandur(), 1),
              round(meandur(), 1))
    )
    tags$ul(lapply(items, tags$li))
  })

  ####### Duration histograms #######
  output$durhist <- renderPlot({
    par(family = "sans", mfrow = c(2, 1), mar = c(4, 4, 3, 1), bg = "#ffffff")

    all_durs    <- durs()
    extant_durs <- durs()[rels_obs()]
    fixed_xlim  <- if (input$DistInput == "All equal")
                     c(0, 2 * input$ExpectedDurationInput) else NULL

    hist(all_durs, xlab = "Duration", ylab = "# Relationships",
         main = "Distribution of All Relational Durations",
         col = col_steelblue, border = "#ffffff",
         col.main = col_teal, font.main = 2, cex.main = 1.1,
         col.lab = "#555", col.axis = "#777",
         xlim = fixed_xlim)

    hist(extant_durs, xlab = "Duration", ylab = "# Relationships",
         main = "Distribution of Durations for Extant Relations on Observation Day",
         col = "#2e7d9c", border = "#ffffff",
         col.main = col_teal, font.main = 2, cex.main = 1.1,
         col.lab = "#555", col.axis = "#777",
         xlim = fixed_xlim)
  })
}

shinyApp(ui = ui, server = server)
