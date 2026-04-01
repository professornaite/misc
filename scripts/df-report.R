df_report <- function(df, file = "df_report.pdf") {
  if (!is.data.frame(df)) stop("df must be a data.frame")
  
  pdf(file, width = 11, height = 8.5)
  par(mar = c(1, 1, 2, 1))
  
  add_page <- function(lines, title = NULL, cex = 0.85) {
    plot.new()
    y <- 0.98
    
    if (!is.null(title)) {
      text(0.02, y, title, adj = c(0, 1), font = 2, cex = 1.2)
      y <- y - 0.06
    }
    
    for (ln in lines) {
      if (y < 0.04) {
        plot.new()
        y <- 0.98
      }
      text(0.02, y, ln, adj = c(0, 1), family = "mono", cex = cex)
      y <- y - 0.03
    }
  }
  
  n <- nrow(df)
  p <- ncol(df)
  
  add_page(
    c(
      paste("Rows:", n),
      paste("Columns:", p),
      "",
      "Variable names:",
      paste(names(df), collapse = ", ")
    ),
    title = "Data Frame Overview"
  )
  
  var_info <- data.frame(
    variable = names(df),
    class = sapply(df, function(x) class(x)[1]),
    missing_n = sapply(df, function(x) sum(is.na(x))),
    unique_n = sapply(df, function(x) length(unique(x))),
    stringsAsFactors = FALSE
  )
  
  add_page(
    capture.output(print(var_info, row.names = FALSE)),
    title = "Variable Properties"
  )
  
  add_page(
    capture.output(summary(df)),
    title = "Overall Summary"
  )
  
  for (nm in names(df)) {
    x <- df[[nm]]
    lines <- c(
      paste("Variable:", nm),
      paste("Class:", class(x)[1]),
      paste("Missing:", sum(is.na(x))),
      paste("Unique values:", length(unique(x))),
      ""
    )
    
    if (is.factor(x) || is.character(x) || is.logical(x)) {
      lines <- c(lines, "Counts:")
      lines <- c(lines, capture.output(print(table(x, useNA = "ifany"))))
    } else {
      lines <- c(lines, "Summary:")
      lines <- c(lines, capture.output(print(summary(x))))
    }
    
    add_page(lines, title = paste("Variable Detail -", nm))
  }
  
  miss_counts <- sapply(df, function(x) sum(is.na(x)))
  add_page(
    capture.output(print(miss_counts)),
    title = "Missing Counts"
  )
  
  miss_mat <- is.na(df)
  miss_cross <- t(miss_mat) %*% miss_mat
  add_page(
    capture.output(print(miss_cross)),
    title = "Missing Data Cross-Table"
  )
  
  dev.off()
}

# produce report
# df_report(df, "df_report.pdf")