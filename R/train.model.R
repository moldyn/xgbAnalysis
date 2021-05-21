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
    objective_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "objective")
    num_class_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "num_class")
    eta_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "eta")
    gamma_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "gamma")
    max_depth_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "max_depth")
    min_child_weight_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "min_child_weight")
    subsample_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "subsample")
    colsample_bytree_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "colsample_bytree")
    eval_metric_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "eval_metric")
    nthread_ <- get.parameter(params_table = paste(data, "train.parameter", sep = "/"), parameter = "nthread")
    params <- list(max_depth = max_depth_, eta = eta_, gamma = gamma_, verbose = 0, nthread = nthread_, objective = objective_, eval_metric = eval_metric_, num_class = num_class_, min_child_weight = min_child_weight_, subsample = subsample_, colsample_bytree = colsample_bytree_)
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
