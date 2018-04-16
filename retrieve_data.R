rm(list=ls())
setwd("//mokey/User41/u/u1562268/Desktop/eu_mpletter2018")
library(rvest)
library(data.table)

strReverse <- function(x) {
  sapply(lapply(strsplit(x, NULL), rev), paste, collapse="")
}


#titles <- html_text(html_nodes(read_html(paste0("http://www.imdb.com/search/title?genres=",category_name[w],"&explore=title_type,genres&pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3454807202&pf_rd_r=0XEGP27F1CM1BNSEE8GM&pf_rd_s=center-1&pf_rd_t=15051&pf_rd_i=genre&sort=num_votes,desc&page=",page,"&ref_=adv_nxt")), ".lister-item-header a"))
#retrieve list of links
list_links <- unique(html_attr(html_nodes(read_html("http://www.europarl.europa.eu/meps/en/full-list.html?filter=all&leg="),"#content_left a"), "href"))
list_links <- paste("http://www.europarl.europa.eu", list_links, sep = "")

names <- html_text(html_nodes(read_html("http://www.europarl.europa.eu/meps/en/full-list.html?filter=all&leg="), "#content_left a"))
names <- names[!(names %in% "\r\n\t\t\t\t")]

parties <- html_text(html_nodes(read_html("http://www.europarl.europa.eu/meps/en/full-list.html?filter=all&leg="), ".group"))

mp_data <- data.table("Name" = names, "Country" = "NA", "Party" = parties, "Committees" =list(c("NA","NA")), "Email" = "NA")

for(i in 1:length(list_links)) {

country <- html_text(html_nodes(read_html(list_links[i]),".noflag"))
country <- unlist(strsplit(country, split = "\r\n\t\t\t\t"))[1]

committees <- html_text(html_nodes(read_html(list_links[i]),"#mepPortfolioDiv :nth-child(4) li"))
committees <- gsub("\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t ", "", committees)
committees <- gsub("\r\n\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t", ", ", committees)
committees <- gsub("\r\n\t\t\t\t\t\t\t\t\t", "", committees)

email <- html_attr(html_nodes(read_html(list_links[i]), "#email-0"), "href")
email <- gsub("mailto:", "", email)
email <- strReverse(email)
email <- gsub("\\]ta\\[", "@", email)
email <- gsub("\\]tod\\[", ".", email)

mp_data[i, Country := country]
mp_data[i, Committees := list(list(committees))]
mp_data[i, Email := email]
print(i)
}
