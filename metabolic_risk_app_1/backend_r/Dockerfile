FROM rstudio/plumber

RUN R -e "install.packages(c('plumber','randomForest','jsonlite','cors'), repos='https://cloud.r-project.org/')"

WORKDIR /app
COPY . /app

EXPOSE 8000

CMD ["Rscript", "api.R"]