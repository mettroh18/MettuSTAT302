#' T Test function
#'
#' This function takes input to perform a t test on the desired data
#'   with the desired parameters.
#'
#' @param x Numeric input data to perform the t test on.
#' @param alternative String input to determine the direction of
#'   the test: less, greater, or two.sided.
#' @param mu Numeric input of the population mean value.
#'
#' @keywords test, inference
#'
#' @return List value containing the test statistic, p value, degrees
#' of freedom, and the \code{alternative} type.
#'
#' @examples
#' my_ttest(c(1,2,3,4,5), "less", 0)
#' my_ttest(c(0,0,0,-13), "two.sided", -2)
#'
#' @export

my_ttest <- function(x, alternative, mu) {
  if (alternative %in% c("two.sided","less", "greater") == FALSE) {
    stop("alternative parameter must be two.sided, less, or greater")
  }

  #Calculate test statistic using standard error calculation
  std_error <- sd(x) / sqrt(length(x))
  test_stat <- ((mean(x) - mu) / (std_error))

  #perform initial p test for absolute value of t value
  p <- pt(abs(test_stat), df = length(x) - 1, lower.tail = FALSE)

  #if two sided test, then multiply p value by 2 (one for each side)
  if (alternative == "two.sided") {
    p <- 2 * p
  } else if (alternative == "less") {
    if (mean(x) - mu > 0) {
      p <- 1 - p
    }
  } else if (alternative == "greater") {
    if (mean(x) - mu < 0) {
      p <- 1 - p
    }
  }


  x <- list("test_stat" = test_stat,
            "df" = length(x) - 1,
            "alternative" = alternative,
            "p_val" = p)
  return (x)
}
