library(aws.s3)
library(here)

source(here::here("is_blank.R"))
dir.create(file.path("data-raw"))

setwd(here("data-raw"))
if (is_blank(Sys.getenv("AWS_EXECUTION_ENV"))) {
  save_object(object = "data-raw/popular.dta",
  bucket = "continuous-report-delivery-ffm-public",
  region = "eu-central-1", ignore_credentials = TRUE)
} else {
  print("getting private data")
  save_object(object = "data-raw/popular.dta",
    bucket = "continuous-report-delivery-ffm-private", 
    region = "eu-central-1", verbose = TRUE)
}
rmarkdown::render(here::here("report.Rmd"))
if (is_blank(Sys.getenv("AWS_EXECUTION_ENV"))) {
  file.copy("report.html", "/tmp/report.html")
} else {
  put_object(file = "./report.html",
    object = "report.html",
    bucket = "continuous-report-delivery-ffm-private",
    region = "eu-central-1",
    verbose = TRUE)
}

