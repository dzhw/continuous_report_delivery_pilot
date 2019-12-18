#!/bin/sh
R -e "knitr::knit('report.Rmd', output = 'report.html')"
