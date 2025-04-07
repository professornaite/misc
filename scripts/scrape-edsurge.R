####  Code to scrape org names from EdSurge site
# https://index.edsurge.com/my_list/

### A few notes
#1 I used Google Chrome to scrape data from the web with Chrome Elements
#2 Website 1 to be scraped: https://index.edsurge.com/products/
  # we want the list of all organizations without having to manually create a list
  # 
#3 When viewing a webpage in Chrome, you can see the underlying code using the Cmd+Option+C (Mac) or Ctrl+Shift+C (Windows)

# this is part of the tidyverse package
install.packages("rvest") 
install.packages("dplyr")
install.packages("XML") # not yet sure why we'll need this package
library(rvest)
library(XML) # see note above about XML package
library(dplyr)

# gather information from the webpage
ed.surge <- "https://index.edsurge.com/products/"
ed.surge <- read_html(ed.surge)
ed.surge
View(ed.surge)
str(ed.surge) # check the structure of the object

# focus on body; list nodes inside the body of the page
body_nodes <- ed.surge %>%
  html_node("body") %>%
  html_children()

body_nodes # check the object

# pipe one level deeper into the code
body_nodes %>%
  html_children() 

# peak at header; list nodes inside the heading of the page
header_nodes <- ed.surge %>%
  html_node("head") %>%
  html_children()

header_nodes

# use xml_find_all() to find all <> nodes in the body document 
# we want to identify those nodes that have the class names we want
## in this current case, we want ?????? <td>

odd <- ed.surge %>% 
  rvest::html_nodes('body') %>% 
  xml2::xml_find_all("//tr[contains(@class, 'odd')]") %>%  ## this line needs to be fixed
  rvest::html_text()
odd
even <- ed.surge %>% 
  rvest::html_nodes('body') %>% 
  xml2::xml_find_all("//tr[contains(@class, 'even')]") %>% ## this line needs to be fixed
  rvest::html_text()
even
chart_df <- data.frame(odd, even)

knitr::kable(
  chart_df %>% head(10))
