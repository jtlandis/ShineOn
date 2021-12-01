


download_r <- function(version = "latest", minor = NULL, location = NULL) {

  tmp_file <- location %||% tempfile(fileext = ".tar.gz")

  if (version == "latest") {
    message("downloading latest R version\n")
    download.file("https://cran.r-project.org/src/base/R-latest.tar.gz", tmp_file)
  } else {

    major <- as.integer(version)
    if (is.na(major)) stop(glue("cannot parse {version} into a major version\n"))

    # if minor is provided - check it is valid and then download version
    if (!is.null(minor)) {
      .min_match <- regexpr("[0-9]+\\.[0-9]+", minor)
      if (.min_match==-1L||attr(.min_match,"match.length")!=nchar(minor)) stop(glue("cannot parse {minor} into a minor version\n"))
    } else {
      minor <- "[0-9]+\\.[0-9]+"
    }

    .readCran <- readLines(glue("https://cran.r-project.org/src/base/R-{major}/"), warn = F)

    .matches <- regexpr(glue("R-{major}\\.{minor}.tar.gz"), .readCran)
    .keep <- which(.matches>0)

    .readCran <- .readCran[.keep]
    .matchLen <- attr(.matches,"match.length")[.keep]
    .matches <- .matches[.keep]
    if ((.n <- length(.keep))==0)
      stop(glue("could not find R-{major}.{minor}.tar.gz \n"))
    else if (.n>1L) {
      message(glue("multiple files matched to R-{major}-{minor}.tar.gz\nUsing the last"))
      .File <- substr(.readCran[.n], .matches[.n], .matches[.n] + .matchLen[.n] - 1L)
    } else {
      .File <- substr(.readCran, .matches, .matches + .matchLen - 1L)
    }

    message(glue("attempting to download: {.File}\n"))
    download.file(glue("https://cran.r-project.org/src/base/R-{major}/{.File}"), tmp_file)

  }

  return(tmp_file)
}
