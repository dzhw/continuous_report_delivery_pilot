library(aws.s3)
source("is_blank.R")
knitr::knit("report.Rmd", output = "report.html")
if (is_blank(Sys.getenv("AWS_EXECUTION_ENV"))) {
  file.copy("report.html", "/tmp/report.html")
} else {
  put_object(file = "./report.html",
    object = "./report.html",
    bucket = "continuous-report-delivery-ffm-private",
    region = "eu-central-1")
}

