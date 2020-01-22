FROM rocker/verse:3.6.1

  RUN R -e 'install.packages(c("haven", "rmarkdown", "here", "lme4", "ggplot2", \
  "sjmisc", "sjstats", "sjPlot", "remotes", "slackr"), dependencies=c("Depends", "Imports", \
  "LinkingTo"))'
  RUN R -e 'remotes::install_github("dzhw/aws.s3")' \
  && mkdir ~/data-raw
  COPY /report.Rmd /report.Rmd
  COPY /is_blank.R /is_blank.R
  COPY /knit_report.R /knit_report.R
  COPY /run.sh /run.sh
  ENTRYPOINT ["/run.sh"]
