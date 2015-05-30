#!/usr/bin/env Rscript
library(knitr)

# Get the filename given as an argument in the shell.
# args = commandArgs(TRUE)
#filename = args[1]

# Check that it's a .Rmd file.
if(!grepl(".Rmd", filename)) {
  stop("You must specify a .Rmd file.")
}



# Knit and place in _posts.
dir = paste0("../_posts/", Sys.Date(), "-")
output = paste0(dir, sub('.Rmd', '.md', filename))
#
base.url = "/"
opts_knit$set(base.url = base.url)
fig.path <- paste0("../figure/", sub(".Rmd$", "", basename(filename)), "/")
opts_chunk$set(fig.path = fig.path)
#
knit(filename, output)

# # Copy .png files to the images directory.
# fromdir = "./figure"
# todir = "../figure"

# If you find the "{{ site.url }}" directory within the _drafts directory terribly unsightly, 
# you can add the following line to the above script:  
unlink("{{ site.url }}", recursive=T)

