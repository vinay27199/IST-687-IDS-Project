#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body { 
        background: linear-gradient(to right, #ff7e5f, #feb47b);  /* WARM FLAME GRADIENT */
      },
      #predictButton { 
        background-color: #007BFF; /* Blue background */
        border: 1px solid #0056b3; /* Dark blue border */
        color: white;
        padding: 12px 24px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        margin: 4px 2px;
        cursor: pointer;
        border-radius: 8px;
        box-shadow: 2px 2px 5px grey; /* Add shadow for better 3D effect */
      }
      #predictButton:hover {
        background-color: #0056b3; /* Dark blue background on hover */
      }
    "))
  ),
  titlePanel("Prediction of Energy Consumption Using SVM Model "),
  
  fluidRow(
    column(4,
      selectInput("heating_setpoint", "Heating Setpoint",choices = c("72F","70F","75F","68F","65F","76F","55F","78F",
                                                                   "80F","67F","60F","62F")),
      textInput("dry_bulb_temp", "Dry Bulb Temperature (C)"),
      selectInput("lighting", "Lighting",choices = c("100% CFL","100% Incandescent","100% LED")),
      selectInput("misc_pool", "Misc Pool",choices = c("Has Pool" ,"None")),
      selectInput("misc_hot_tub_spa", "Hot Tub/Spa",choices = c("Electric","Gas","None")),
      selectInput("occupants", "Occupants",choices = c("1","2","3","4","5","6","7","8","9","10+")),
      selectInput("cooling_setpoint", "Cooling Setpoint",choices = c("60F","62F","65F","67F","68F","70F",
                                                                   "72F","75F","76F","78F","80F")),
      selectInput("cooling_setpoint_offset_magnitude", "Cooling Setpoint Offset Magnitude",choices = c("0F","2F","5F","9F")),
      selectInput("misc_gas_fireplace", "Misc Gas Fireplace",choices = c("Gas Fireplace","None"))),
    column(4,
      selectInput("window_areas", "Window Areas",choices = c("F12 B12 L12 R12","F18 B18 L18 R18","F9 B9 L9 R9",
                                                           "F6 B6 L6 R6","F15 B15 L15 R15","F30 B30 L30 R30")),
      selectInput("income", "Income",choices = c("100000-119999","80000-99999","200000+","30000-34999","60000-69999","10000-14999", 
                                               "45000-49999","50000-59999","25000-29999","<10000","40000-44999","70000-79999", 
                                               "160000-179999","20000-24999","15000-19999","120000-139999","140000-159999",
                                               "35000-39999","180000-199999")),
      selectInput("misc_freezer", "Misc Freezer",choices = c("EF 12, National Average","None")),
      selectInput("global_horizontal_radiation", "Global Horizontal Radiation (W/m2)",choices =c(0.0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0
                                                                                                  ,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.5,11.0,12.0,12.5,13.0,13.5,14.5)),
      selectInput("misc_pool_heater", "Misc Pool Heater",choices = c("Electric","Gas","None","Solar")),
      selectInput("sqft", "Square Footage",choices = c(328,633,885,1220,1690,2176,2663,3301,8194)),
      selectInput("cooking_range", "Cooking Range",choices = c("Electric, 100% Usage","Electric, 120% Usage","Electric, 80% Usage","Gas, 100% Usage",    
                                                               "Gas, 120% Usage","Gas, 80% Usage","None","Propane, 100% Usage",
                                                               "Propane, 120% Usage","Propane, 80% Usage")),
      numericInput("direct_normal_radiation", "Direct Normal Radiation (W/m2)", value = 0),
      numericInput("wind_speed", "Wind Speed (m/s)", value = 0)),
    column(4,
      selectInput("cooling_setpoint_offset_period", "Cooling Setpoint Offset Period",choices = c("Day and Night Setup","Day and Night Setup -1h",      
                                                                                                 "Day and Night Setup -2h","Day and Night Setup -3h",       
                                                                                                 "Day and Night Setup -4h","Day and Night Setup -5h",       
                                                                                                 "Day and Night Setup +1h","Day and Night Setup +2h",       
                                                                                                 "Day and Night Setup +3h","Day and Night Setup +4h",        
                                                                                                 "Day and Night Setup +5h","Day Setup",                      
                                                                                                 "Day Setup -1h","Day Setup -2h","Day Setup -3h","Day Setup -4h",                  
                                                                                                 "Day Setup -5h","Day Setup +1h","Day Setup +2h","Day Setup +3h",                  
                                                                                                 "Day Setup +4h","Day Setup +5h",                  
                                                                                                 "Day Setup and Night Setback","Day Setup and Night Setback -1h",
                                                                                                 "Day Setup and Night Setback -2h","Day Setup and Night Setback -3h",
                                                                                                 "Day Setup and Night Setback -4h","Day Setup and Night Setback -5h",
                                                                                                 "Day Setup and Night Setback +1h","Day Setup and Night Setback +2h",
                                                                                                 "Day Setup and Night Setback +3h","Day Setup and Night Setback +4h",
                                                                                                 "Day Setup and Night Setback +5h","Night Setback",                  
                                                                                                 "Night Setback -1h","Night Setback -2h","Night Setback -3h","Night Setback -4h",             
                                                                                                 "Night Setback -5h","Night Setback +1h","Night Setback +2h","Night Setback +3h",              
                                                                                                 "Night Setback +4h","Night Setback +5h","Night Setup","Night Setup -1h",                
                                                                                                 "Night Setup -2h","Night Setup -3h","Night Setup -4h","Night Setup -5h",               
                                                                                                 "Night Setup +1h","Night Setup +2h","Night Setup +3h","Night Setup +4h",                
                                                                                                 "Night Setup +5h","None")),
      selectInput("geometry_foundation_type", "Geometry Foundation Type",choices = c("Ambient","Heated Basement","Slab","Unheated Basement",  
                                                                                     "Unvented Crawlspace","Vented Crawlspace")),
      selectInput("misc_gas_grill", "Misc Gas Grill",choices = c("Gas Grill","None")),
      selectInput("misc_well_pump", "Misc Well Pump",choices = c("None","Typical Efficiency")),
      selectInput("ducts", "Ducts",choices = c( "0% Leakage, Uninsulated","10% Leakage, R-4","10% Leakage, R-6",        
                                                "10% Leakage, R-8","10% Leakage, Uninsulated","20% Leakage, R-4",       
                                                "20% Leakage, R-6","20% Leakage, R-8","20% Leakage, Uninsulated",
                                                "30% Leakage, R-4","30% Leakage, R-6","30% Leakage, R-8",        
                                                "30% Leakage, Uninsulated","None")),
      selectInput("in.insulation_wall", "Wall Insulation",choices = c("CMU, 6-in Hollow, R-7","Wood Stud, R-11","Brick, 12-in, 3-wythe, R-11",       
                                                                      "Wood Stud, R-7","Wood Stud, Uninsulated","Brick, 12-in, 3-wythe, R-7",
                                                                      "Wood Stud, R-19","CMU, 6-in Hollow, R-11","Wood Stud, R-15",                  
                                                                      "Brick, 12-in, 3-wythe, Uninsulated","Brick, 12-in, 3-wythe, R-19",      
                                                                      "CMU, 6-in Hollow, Uninsulated","Brick, 12-in, 3-wythe, R-15",     
                                                                      "CMU, 6-in Hollow, R-19","CMU, 6-in Hollow, R-15","CMU, 6-in Hollow, R-7")),
      selectInput("hot_water_fixtures", "Hot Water Fixtures",choices = c("100% Usage","200% Usage","50% Usage")),
      selectInput("extra_refrigerator", "Extra Refrigerator",choices = c("EF 10.2","EF 10.5","EF 15.9","EF 17.6","EF 19.9","EF 6.7","None"))
    ),
    mainPanel(
      actionButton("predict", "Predict Energy Consumption", class = "btn-primary", align = "center"),
      tags$h4("Your Predicted value is"),
      tags$h4(verbatimTextOutput("prediction"))
    )
  )
)

server <- function(input, output) {
  library(e1071)
  model <- readRDS("svm_model.rds")  # Load the pre-trained model
  
  data_predict <- reactive({
    data.frame(
      in.heating_setpoint = as.factor(input$heating_setpoint),
      Dry.Bulb.Temperature...C. = asinh(as.numeric(input$dry_bulb_temp)),
      in.lighting = as.factor(input$lighting),
      in.misc_pool = as.factor(input$misc_pool),
      in.misc_hot_tub_spa = as.factor(input$misc_hot_tub_spa),
      in.occupants = as.factor(input$occupants),
      in.cooling_setpoint = as.factor(input$cooling_setpoint),
      in.cooling_setpoint_offset_magnitude = as.factor(input$cooling_setpoint_offset_magnitude),
      in.misc_gas_fireplace = as.factor(input$misc_gas_fireplace),
      in.window_areas = as.factor(input$window_areas),
      in.income = as.factor(input$income),
      in.misc_freezer = as.factor(input$misc_freezer),
      Global.Horizontal.Radiation..W.m2. = asinh(as.numeric(input$global_horizontal_radiation)),
      in.misc_pool_heater = as.factor(input$misc_pool_heater),
      in.sqft = asinh(as.numeric(input$sqft)),
      in.cooking_range = as.factor(input$cooking_range),
      Direct.Normal.Radiation..W.m2. = asinh(as.numeric(input$direct_normal_radiation)),
      Wind.Speed..m.s. = asinh(as.numeric(input$wind_speed)),
      in.cooling_setpoint_offset_period = as.factor(input$cooling_setpoint_offset_period),
      in.geometry_foundation_type = as.factor(input$geometry_foundation_type),
      in.misc_gas_grill = as.factor(input$misc_gas_grill),
      in.misc_well_pump = as.factor(input$misc_well_pump),
      in.ducts = as.factor(input$ducts),
      in.insulation_wall = as.factor(input$in.insulation_wall),
      in.hot_water_fixtures = as.factor(input$hot_water_fixtures),
      in.misc_extra_refrigerator = as.factor(input$extra_refrigerator)
    )
  })
 
  observeEvent(input$predict, {
    data <- data_predict()
    output$prediction <- renderText({
      sinh(predict(model, newdata = data))
    })
  })
}
# Run the application 
shinyApp(ui = ui, server = server)
