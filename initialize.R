### Pubmed NLP ###

# libraries needed

library(RISmed)
library(dplyr)
library(tidytext)
library(stringr)

# source the purpose created functions
source(file = "functions/functions_general.R")

### variables ###

#1 search query for pubmed # example: septic shock, human studies, past 5 years
topic_query <-  '("shock, septic"[MeSH Terms] OR ("shock"[All Fields] AND "septic"[All Fields]) OR "septic shock"[All Fields] OR ("septic"[All Fields] AND "shock"[All Fields])) AND ("2013/04/24"[PDat] : "2018/04/24"[PDat] AND "humans"[MeSH Terms])'

#2 number of papers retrieved # example: newest 100
papers_num <- 100


### retrieve data and metadata from pubmed ###
# uses the RISmed library

#1 query pubmed
q <-  EUtilsSummary(topic_query, retmax= papers_num, db = "pubmed", type = "esearch")
records <- EUtilsGet(q)

#2 create a data_frame with PMID, title and abstract
pubmed_data <- data_frame('paper'= 1:papers_num,'PMID' = PMID(records),'Title'=ArticleTitle(records),'Abstract'=AbstractText(records))
#clean the Abstract column from ,
pubmed_data$Abstract <- as.character(pubmed_data$Abstract)
pubmed_data$Abstract <- gsub(",", " ", pubmed_data$Abstract, fixed = TRUE)
# remove lines with empty Abstract
pubmed_data <- pubmed_data[!(pubmed_data$Abstract == ""),]

#3 create tidy data_frame for NLP analysis of single words
pmd_singlew_df <- single_words_df(pubmed_df = pubmed_data)
