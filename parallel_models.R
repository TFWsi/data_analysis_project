library(data.table)
library(parallel)

###################CONFIG#########################
no_cores <- detectCores()                        #
y_in <- 'Values_Y.csv'                           #
x_in <- 'SNPs_X.csv'                             #
path_out <- '/home/filip/Analiza_danych/results' #
##################################################

# LOAD DATA
val <- as.matrix(fread(y_in))
SNP <- as.matrix(fread(x_in))

# REMOVE COLUMNS WITH IND. ID'S
val <- val[,c(-1)]
SNP <- SNP[,c(-1)]

# CREATE VARIABLES WITH NO. OF COLUMNS IN EACH MATRIX
num_cols_y <- ncol(val)
num_cols_x <- ncol(SNP)

# CREATE VARIABLES WITH NAMES OF THE COLUMNS IN EACH MATRIX
val_nam <- colnames(val)
SNP_nam <- colnames(SNP)

# CREATE CLUSTER AND EXPORT NECESARRY VARIABLES
cl <- makeCluster(no_cores)
clusterExport(cl=cl,c("val", "SNP", 'val_nam', 'SNP_nam'))

# CREATE GRID WITH ALL POSSIBLE COMBINATIONS OF COLUMNS IN GIVEN MATRICES
formulas <- as.matrix(expand.grid(1:num_cols_y, 1:num_cols_x))

# IN PARALLEL, BASED ON GRID CREATE LIST WHICH WILL STORE INFO ABOUT LINEAR MODELS WE WANT TO CREATE
formulas <- parApply(cl,formulas, 1, function(z){
  y <- paste0("val[,'Y",z[1],"']")
  x <- paste0("SNP[,'SNP",z[2],"']")
  y_var <- val_nam[z[1]]
  x_var <- SNP_nam[z[2]]
  list(formula = as.formula(paste(y, "~", x)), variable = y_var, SNP = x_var)
})

# CREATE AND FIT MODELS BASED ON PREVIOUS LIST AND EXTRACT ONLY IMPORTANT INFO SUCH AS DEPENDENT AND INDEPENDENT VAR,
# PVALUE AND ESTIMATOR
models <- parLapply(cl, formulas, function(formula_info){
  fit <- lm(formula_info$formula)
  c(Y = formula_info$variable, X = formula_info$SNP, pvalue = summary(fit)$coef[2, 4], estimator = summary(fit)$coef[2])
})

# TERMINATE CLUSTER
stopCluster(cl)

# CONVERT OBTAINED LIST OF RESULTS INTO MATRIX AND EXPORT IT
output_matrix <- do.call(rbind, models)
write.table(output_matrix, file=path_out, sep='\t', row.names=FALSE)
