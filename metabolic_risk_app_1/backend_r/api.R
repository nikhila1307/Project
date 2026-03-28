library(plumber)
library(randomForest)
library(jsonlite)

# -----------------------------
# CORS FILTER
# -----------------------------
#* @filter cors
function(req, res){
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Headers", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  if (req$REQUEST_METHOD == "OPTIONS") {
    return(list())
  }
  plumber::forward()
}

# -----------------------------
# LOAD MODELS
# -----------------------------
rf_anthro <- readRDS(file.path("models", "rf_anthro_model.rds"))
rf_bio <- readRDS(file.path("models", "rf_biochemical_model.rds"))
rf_combined <- readRDS(file.path("models", "rf_combined_model.rds"))

# -----------------------------
# Anthropometric
# -----------------------------
#* @post /predict_anthro
function(BMI, Waist, Hip, neck, WHR, wher){

  df <- data.frame(
    bmi = as.numeric(BMI),
    waist_circumference = as.numeric(Waist),
    hip_circumference = as.numeric(Hip),
    neck_circumference = as.numeric(neck),
    waist_hip_ratio = as.numeric(WHR),
    waist_height_ratio = as.numeric(wher)
  )

  pred <- predict(rf_anthro, df, type="prob")

  list(risk = pred[,2])
}

# -----------------------------
# Biochemical
# -----------------------------
#* @post /predict_bio
function(Glucose, HDL, TG, tyg, spise, aip, tghdl){

  df <- data.frame(
    triglycerides = as.numeric(TG),
    hdl = as.numeric(HDL),
    fasting_glucose = as.numeric(Glucose),
    tyg = as.numeric(tyg),
    spise = as.numeric(spise),
    aip = as.numeric(aip),
    tg_hdl  = as.numeric(tghdl)
  )

  pred <- predict(rf_bio, df, type="prob")

  list(risk = pred[,2])
}

# -----------------------------
# Combined
# -----------------------------
#* @post /predict_combined
function(BMI, Waist, Hip, Neck, WHR, wher, Glucose, HDL, TG, TyG, SPISE, AIP, TGHDL){

  df <- data.frame(
    bmi = as.numeric(BMI),
    waist_circumference = as.numeric(Waist),
    hip_circumference = as.numeric(Hip),
    neck_circumference = as.numeric(Neck),
    waist_hip_ratio = as.numeric(WHR),
    waist_height_ratio = as.numeric(wher),
    triglycerides = as.numeric(TG),
    hdl = as.numeric(HDL),
    fasting_glucose = as.numeric(Glucose),
    tyg = as.numeric(TyG),
    spise = as.numeric(SPISE),
    aip = as.numeric(AIP),
    tg_hdl  = as.numeric(TGHDL)
  )

  pred <- predict(rf_combined, df, type="prob")

  list(risk = pred[,2])
}

pr <- plumber::plumb("api.R")

cat("Starting API on port 8000...\n")

pr$run(host = "0.0.0.0", port = 8000)

# Health check
#* @get /health
function(){
  list(status = "API is running")
}