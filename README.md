<!-- badges: start -->
  [![Travis build status](https://travis-ci.com/mettroh18/MettuSTAT302.svg?branch=master)](https://travis-ci.com/mettroh18/MettuSTAT302)
  [![Codecov test coverage](https://codecov.io/gh/mettroh18/MettuSTAT302/branch/master/graph/badge.svg)](https://codecov.io/gh/mettroh18/MettuSTAT302?branch=master)
<!-- badges: end -->

after_success:
  - Rscript -e 'covr::codecov()'
  
# Installation
To download the MettuSTAT302 package, use the code below.

```
#install.packages("devtools")
devtools::install_github("mettroh18/MettuSTAT302")
library(MettuStat302)
```

#Use
The vignette demonstrates example usage of all main functions. Please file an issue if you have a request for a tutorial that is not currently included. You can see the vignette by using the following code (note that this requires a TeX installation to view properly):

```
# install.packages("devtools")
devtools::install_github("mettroh18/MettuSTAT302", build_vignette = TRUE, build_opts = c())
library(corncob)
# Use this to view the vignette in the corncob HTML help
help(package = "MettuSTAT302", help_type = "html")
# Use this to view the vignette as an isolated HTML file
utils::browseVignettes(package = "MettuSTAT302")
```

