FROM rstudio/plumber

WORKDIR /app

COPY . /app

RUN R -e "install.packages(c('plumber','randomForest','jsonlite'))"

EXPOSE 8000

CMD ["R", "-e", "pr <- plumber::plumb('api.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', 8000)))"]