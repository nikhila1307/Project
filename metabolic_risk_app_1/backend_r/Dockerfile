FROM rstudio/plumber

WORKDIR /app

COPY . /app

RUN R -e "install.packages(c('plumber','randomForest','jsonlite'))"

EXPOSE 8000

CMD ["Rscript", "run_api.R"]