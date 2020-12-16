#' K Nearest Neighbors Cross Validation
#'
#' This function takes input to perform a k-nearest neighbors cross validation
#' to suggest the best data model to use for prediction.
#'
#' @param train Numeric input data to train and perform cross validation on.
#' @param cl String input that represents the column being predicted
#'   (the true class).
#' @param k_nn Integer value that represents the number of neighbors.
#' @param k_cv Integer value that represents the number of yhat predictions.
#'
#' @keywords cross-validation, prediction
#'
#' @import dplyr
#' @import class
#'
#' @return List value containing the average Cross Validation (misclass) error,
#'   the predicted class values, and the training misclassification error.
#'
#' @examples
#' my_knn_cv(data, "height", 1, 5)
#' my_knn_cv(data, "height", 3, 5)
#' my_knn_cv(data, "height", 5, 5)
#'
#' @export

my_knn_cv <- function(train, cl, k_nn, k_cv) {

  #assigning folds to training data
  data_knn <- train
  n <- nrow(data_knn)
  inds <- sample(rep(1:k_cv, length = n))
  fold <- inds
  cbind(data_knn, fold)

  #setting aside the true values of class
  true_class <- data_knn %>% select(cl)
  true_class <- true_class[,1, drop = TRUE]

  #running cross validation on k nearest neighbors
  #tracking misclassifications using true test/training values
  #and yhat/predictions
  misclass <- c()
  for (i in 1:k_cv) {
    data_train <- data_knn %>% filter(fold != i) %>% select(-cl, -fold)
    train_class <- data_knn %>% filter(fold != i) %>% select(cl)
    train_class <- train_class[,1, drop = TRUE]

    data_test <- data_knn %>% filter(fold == i) %>% select(-cl, -fold)
    test_values <- data_knn %>% filter(fold == i) %>% select(cl)
    test_values <- test_values[,1, drop = TRUE]

    yhat_class <- class::knn(data_train, data_test, as.numeric(train_class), k=k_nn, prob=TRUE)
    misclass_rate <- sum(as.numeric(test_values) != yhat_class) / length(test_values)

    misclass <- append(misclass, misclass_rate)
  }
  cv_err <- mean(misclass)
  pred_class <- class::knn(train %>% select (-cl), train %>% select (-cl), as.numeric(true_class), k=k_nn)
  train_err <- sum(pred_class != as.numeric(true_class)) / length(true_class)
  returnList <- list("train_misclass" = train_err,
                     "cv_misclass" = cv_err,
                     "predicted" = pred_class)
  return(returnList)
}
