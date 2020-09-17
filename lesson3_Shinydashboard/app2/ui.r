dashHeader <- dashboardHeader(title = "Simple Dashboard")

dashSidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      text = "Home",
      tabName = "HomeTab",
      icon = icon("dashboard")
    ),
    menuItem(
      text = "Graphs",
      tabName = "GraphsTab",
      icon = icon("bar-chart-o")
    ),
    menuItem(
      text = "File Explorer",
      tabName = "FileExplorer",
      icon = icon("file-text")
    ),
    menuItem(
      text = "javscript",
      tabName = "JS",
      icon = icon('code')
    ),
    menuItem(
      text = 'Map',
      tabName = 'PizzaMap',
      icon = icon('map')
    )
  )
)


dashBody <- dashboardBody(
  shinyjs::useShinyjs(),
  tabItems(
    tabItem(
      tabName = "HomeTab",
      h1("Landing page!"),
      p("This is the landing page for the dashboard."),
      em("This text is emphasized.")
    ),
    tabItem(
      tabName = "GraphsTab",
      h1("Graphs!"),
      fluidRow(
        box(
          width = 3,
          collapsible = TRUE,
          title = "Controls",
          status = "primary", solidHeader = TRUE,
          #Selector for what to plot
          selectInput(
            inputId = "VarToPlot",
            label = "Select a variable to plot",
            choices = c("carat", "depth", "table", "price"),
            selected = "Price"
          ),
          
          #Choose number of bins
          sliderInput(
            inputId= "Histbins",
            label = "Choose number of bins",
            min = 5, max=100, value=30
          )
        ),
        tabBox(
          width = 9,
          tabPanel(
            title = "Histogram",
            #Placeholder for what to plot
            plotOutput(outputId = "HistPlot")
          ),
          tabPanel(
            title = "Density",
            plotOutput(outputId = "Densplot")
          ),
          tabPanel(
            title = "Table",
            DT::dataTableOutput(outputId = "theTable")
          )
          
        )
      )
    ),
    tabItem(
      tabName = "FileExplorer",
      fileInput(
        inputId= "fileUpload",
        label="Please upload your file",
        multiple = FALSE,
        accept = c("csv", "txt"),
        buttonLabel = "Upload",
        placeholder = "Waiting for file"
      ),
      fluidRow(
        box(
          width = 3,
          checkboxGroupInput(
            inputId = "colSelection",
            label = "waiting for data",
            choices = NULL
          )
        ),
        box(
          width = 9,
          DT::dataTableOutput(outputId = "fileTable")
        )
      )
      
    ),
    tabItem(
      tabName = 'JS',
      fluidRow(
        box(
          width = 4,
          height = 200,
          h1(id= "LeftText", 'Left')
        ),
        box(
          width = 4,
          height = 200,
          actionButton(
            inputId= "swapButton",
            label = 'swap'
          )
        ),
        box(
          width = 4,
          height = 200,
          shinyjs::hidden(h1(id="RightText", "Right"))
        )
      ),
      fluidRow(
        box(
          width = 4,
          textInput(
            inputId = 'NumGuest',
            label = NULL,
            placeholder = 'Guess a number'
          )
        ),
        box(
          width = 4,
          shinyjs::hidden(
            h3(id='LuckyNumber', 'You guessed correctly')
          )
        ),
        box(
          width = 4,
          actionButton(
            inputId= 'AlertButton',
            label = 'Ring',
            class= "btn-primary"
          )
        )
      )
    ),
    tabItem(
      tabName = 'PizzaMap',
      fluidRow(
        box(
          width = 12,
          downloadButton(outputId= 'Report', label = 'Generate Report')
        ),
        box(
          width = 6,
          DT::dataTableOutput(outputId = 'PizzaTable')
        ),
        box(
          width = 6,
          leafletOutput(outputId = 'PizzaMap')
        )
      )
    )
  )
)



dashboardPage(
  header = dashHeader,
  sidebar = dashSidebar,
  body = dashBody,
  title = "Example Dashborad",
  skin = "blue"
)
