#' Linear Regression Modeling Function
#'
#' This function will take data and a desired formula and output a
#'   linear regression model.
#'
#' @param formula Formula input that describes the relationship
#'   being explored in this model.
#' @param input Numeric input that contains the data used for this model.
#'
#' @keywords regression, inference
#'
#' @return Table value with the estimated beta coefficient, std Error, test
#'   statistic, and p-value.
#'
#' @examples
#' data_x <- c(1, 2, 3, 3, 2, 3, 2, 1, 1, 1, 2, 1, 2, 3, 3)
#' data_x2 <- c(10, 50, 30, 30, 20, 30, 20, 10, 10, 10, 20, 10, 20, 30, 30)
#' data_x3 <- c(13, 22, 43, 83, 42, 73, 22, 13, 11, 41, 62, 91, 22, 53, 53)
#' data_x4 <- c(14, 23, 132, 123, 572, 123, 242, 641, 231, 651, 232, 541, 232, 163, 833)
#' data_y <- c(13, 72, 33, 43, 72, 83, 32, 21, 15, 12, 62, 31, 27, 33, 36)
#'
#' dataframe1 <- data.frame(data_x, data_x2, data_x3, data_x4, data_y)
#'
#' my_lm(data_x3~data_x2, dataframe1)
#' my_lm(data_y~data_x3 + data_x2, dataframe1)
#' my_lm(data_y~data_x + data_x2 + data_x3, dataframe1)
#'
#' @export

my_lm <- function(formula, input) {
  x <- model.matrix(formula, input)
  m_frame <- model.frame(formula = formula, data = input)
  y <- model.response(m_frame)

  #"Estimate" column
  b_coefficient <- as.vector(solve(t(x) %*% x) %*% t(x) %*% y)

  #"Std Error" Column
  #Begin by calculating the variance of each covariant
  df <- nrow(x) - ncol(x)
  var <- sum((y - x%*%b_coefficient)^2/df)
  se <- sqrt(diag(var * solve(t(x) %*% x)))

  #"T value" column
  #T value calculated using a mean value of 0 from a standard normal
  #distribution (most lm() computed against a std normal distribution)
  test_stat <- (b_coefficient / se)

  #"Pr(>|t|)" Column
  #Using a two sided test via pt() method and test value
  p <- pt(abs(test_stat), df = df, lower.tail = FALSE)
  p <- 2 * p

  returnVal <- (data.frame(b_coefficient, se, test_stat, p))
  colnames(returnVal) <- c("Estimate","Std. Error","t value", "Pr(>|t|)")
  return(returnVal)

}

