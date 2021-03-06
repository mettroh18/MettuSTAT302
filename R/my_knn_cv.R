#' K Nearest Neighbors Cross Validation
#'
#' This function takes input to perform a k-nearest neighbors cross validation
#' to suggest the best data model to use for prediction.
#'
#' @param train Numeric input data to train and perform cross validation on.
#' @param true_cl String input that represents the column being predicted
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
#' data_x <- c(1, 2, 3, 3, 2, 3, 2, 1, 1, 1, 2, 1, 2, 3, 3)
#' data_x2 <- c(10, 50, 30, 30, 20, 30, 20, 10, 10, 10, 20, 10, 20, 30, 30)
#' data_x3 <- c(13, 22, 43, 83, 42, 73, 22, 13, 11, 41, 62, 91, 22, 53, 53)
#' data_x4 <- c(14, 23, 132, 123, 572, 123, 242, 641, 231, 651, 232, 541, 232, 163, 833)
#' data_y <- c(13, 72, 33, 43, 72, 83, 32, 21, 15, 12, 62, 31, 27, 33, 36)
#'
#' dataframe1 <- data.frame(data_x, data_x2, data_x3, data_x4, data_y)
#'
#' my_knn_cv(dataframe1, "data_y", 1, 5)
#' my_knn_cv(dataframe1, "data_x3", 3, 5)
#' my_knn_cv(dataframe1, "data_x2", 5, 5)
#'
#' @export

my_knn_cv <- function(train, true_cl, k_nn, k_cv) {

  #assigning folds to training data
  data_knn <- train
  n <- nrow(data_knn)
  inds <- sample(rep(1:k_cv, length = n))
  fold <- inds
  cbind(data_knn, fold)

  #setting aside the true values of class
  true_class <- data_knn %>% dplyr::select(true_cl)
  true_class <- true_class[,1, drop = TRUE]

  #running cross validation on k nearest neighbors
  #tracking misclassifications using true test/training values
  #and yhat/predictions
  misclass <- c()
  for (i in 1:k_cv) {
    data_train <- data_knn %>% dplyr::filter(fold != i) %>% dplyr::select(-true_cl, -fold)
    train_class <- data_knn %>% dplyr::filter(fold != i) %>% dplyr::select(true_cl)
    train_class <- train_class[,1, drop = TRUE]

    data_test <- data_knn %>% dplyr::filter(fold == i) %>% dplyr::select(-true_cl, -fold)
    test_values <- data_knn %>% dplyr::filter(fold == i) %>% dplyr::select(true_cl)
    test_values <- test_values[,1, drop = TRUE]

    yhat_class <- class::knn(data_train, data_test, as.numeric(train_class), k=k_nn, prob=TRUE)
    misclass_rate <- sum(as.numeric(test_values) != yhat_class) / length(test_values)

    misclass <- append(misclass, misclass_rate)
  }
  cv_err <- mean(misclass)
  pred_class <- class::knn(train %>% select (-true_cl), train %>% select (-true_cl), as.numeric(true_class), k=k_nn)
  train_err <- sum(pred_class != as.numeric(true_class)) / length(true_class)
  returnList <- list("train_misclass" = train_err,
                     "cv_misclass" = cv_err,
                     "predicted" = pred_class)
  return(returnList)
}
