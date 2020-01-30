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
rmarkdown::render(here::here("report.Rmd"), output_format = c("html_document", "pdf_document"))
if (is_blank(Sys.getenv("AWS_EXECUTION_ENV"))) {
  file.copy("report.html", "/tmp/report.html")
  file.copy("report.pdf", "/tmp/report.pdf")
} else {
  print(getwd())
  put_object(file = here::here("report.html"),
    object = "report.html",
    bucket = "continuous-report-delivery-ffm-private",
    region = "eu-central-1",
    verbose = TRUE)
  put_object(file = here::here("report.pdf"),
    object = "report.pdf",
    bucket = "continuous-report-delivery-ffm-private",
    region = "eu-central-1",
    verbose = TRUE)
}
