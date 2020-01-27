library(aws.s3)
library(here)
library(slackr)
source(here::here("is_blank.R"))
dir.create(file.path("data-raw"))
slackr_setup(here::here(".slackr"))
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
  print(getwd())
  put_object(file = here::here("report.html"),
    object = "report.html",
    bucket = "continuous-report-delivery-ffm-private",
    region = "eu-central-1",
    verbose = TRUE)
  slackr_setup(channel = "mdm-devops", username = "continuous-report-delivery-bot",
    icon_emoji = "", incoming_webhook_url = Sys.getenv("incoming_webhook_url"),
    api_token = Sys.getenv("slack_api_token"))
  textSlackr(paste0("Private report finished, download here: https://s3.console.aws.amazon.com/s3/buckets/continuous-report-delivery-ffm-private/?region=eu-central-1&tab=overview", 
  channel = "mdm-devops")

}
