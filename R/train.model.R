#' Train xgboost model.
#'
#' TODO: detailed description.
#' TODO: Parameter, test.matrix (?)
#' TODO: data_dir
#'
#' @param data_dir directory containing the files train.parameter,
#' feature.names, train.xgb.Dmatrix, test.xgb.Dmatrix (see \link{\code{import.data}})
#' @param output_dir directory to which results are written
#' @param nrounds number of training rounds
#' @import xgboost
#' @importFrom data.table fread
#' @export

train.model <- function(data_dir, output_dir, params=NA, nrounds = 20) {

  # check if output dir exists and create it if not
  if(!dir.exists(output_dir)) {
    message(paste("Creating output directory", output_dir))
    dir.create(output_dir, showWarnings = F, recursive = T)
  }
  if(is.na(params)){
    _objective <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "objective")
    _num_class <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "num_class")
    _eta <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "eta")
    _gamma <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "gamma")
    _max_depth <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "max_depth")
    _min_child_weight <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "min_child_weight")
    _subsample <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "subsample")
    _colsample_bytree <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "_colsample_bytree")
    _eval_metric <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "_eval_metric")
    _nthread <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "_nthread")
    params <- list(max_depth = _max_depth, eta = _eta, gamma = _gamma, verbose = 0, nthread = _nthread, objective = _objective, eval_metric = _eval_metric, num_class = _num_class, min_child_weight = _min_child_weight, subsample = _subsample, colsample_bytree = _colsample_bytree)
  }

  # read train and test data
  message("Reading training and test data ...")
  train.matrix <- xgb.DMatrix(paste(data_dir, "train.xgb.Dmatrix", sep="/"))
  test.matrix  <- xgb.DMatrix(paste(data_dir, "test.xgb.Dmatrix", sep="/"))
  message("... finished.")

  watchlist <- c(train = train.matrix, test = test.matrix)
  label <- fread(paste(data_dir, "feature.names", sep="/"), header = F)[[1]]

  # TODO check if num_class is correct?

  message("Training xgboost model ...")
  bst <- xgb.train(data = train.matrix,
                   watchlist = watchlist,
                   params = params,
                   nrounds = nrounds)
  message("... finished.")

  # Save results, TODO: message(...) which files are stored where
  message(paste("saving files to: ", output_dir, "...", sep = ""))
  xgb.save(bst, paste(output_dir, "xgb.model", sep="/"))
  message("...xgb.model saved")
  xgb.dump(bst, paste(output_dir, "xgb.dump.model", sep="/"), with_stats = TRUE)
  message("...xgb.dump.model saved")
  imp <- xgb.importance(model = bst, feature_names = label)
  write.csv(imp, paste(output_dir, "importance", sep="/"))
  message("...importance saved")
  message("...finished")
}
