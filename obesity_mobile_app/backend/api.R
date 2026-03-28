library(plumber)
library(jsonlite)

# Load ML models
rf_anthro <- readRDS("models/rf_anthro_model.rds")
rf_bio <- readRDS("models/rf_biochemical_model.rds")
rf_combined <- readRDS("models/rf_combined_model.rds")
logistic_model <- readRDS("models/logistic_model_composite_risk.rds")

# -------------------------------
# Anthropometric Model
# -------------------------------

#* Predict anthropometric obesity
#* @post /predict_anthro
function(req){

  data <- jsonlite::fromJSON(req$postBody)
  data <- as.data.frame(data)

  pred <- predict(rf_anthro, data)

  return(list(
    model = "anthropometric",
    prediction = pred
  ))

}

# -------------------------------
# Biochemical Model
# -------------------------------

#* Predict biochemical obesity
#* @post /predict_bio
function(req){

  data <- jsonlite::fromJSON(req$postBody)
  data <- as.data.frame(data)

  pred <- predict(rf_bio, data)

  return(list(
    model = "biochemical",
    prediction = pred
  ))

}

# -------------------------------
# Combined Model
# -------------------------------

#* Predict combined obesity
#* @post /predict_combined
function(req){

  data <- jsonlite::fromJSON(req$postBody)
  data <- as.data.frame(data)

  pred <- predict(rf_combined, data)

  return(list(
    model = "combined",
    prediction = pred
  ))

}

# -------------------------------
# Logistic Composite Risk
# -------------------------------

#* Predict obesity risk probability
#* @post /predict_risk
function(req){

  data <- jsonlite::fromJSON(req$postBody)
  data <- as.data.frame(data)

  risk <- predict(logistic_model, data, type="response")

  return(list(
    model = "logistic",
    risk_probability = risk
  ))

}

# -------------------------------
# Health check endpoint
# -------------------------------

#* Check if API is running
#* @get /health
function(){

  return(list(
    status = "API is running",
    models_loaded = TRUE
  ))

}