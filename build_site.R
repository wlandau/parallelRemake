writeLines(c("include:", "  - .nojekyll"), "_config.yml")
pkgdown::build_site(path = ".")
