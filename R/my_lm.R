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
#' my_lm(y~x, data)
#' my_lm(weight~height + gender, myData)
#' my_lm(temp~latitude + humidity + pollution, worldData)
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

