<!-- badges: start -->
  [![Travis build status](https://travis-ci.com/mettroh18/MettuSTAT302.svg?branch=master)](https://travis-ci.com/mettroh18/MettuSTAT302)
  [![Codecov test coverage](https://codecov.io/gh/mettroh18/MettuSTAT302/branch/master/graph/badge.svg)](https://codecov.io/gh/mettroh18/MettuSTAT302?branch=master)
<!-- badges: end -->

after_success:
  - Rscript -e 'covr::codecov()'

