### function single_words_df 

single_words_df <- function(pubmed_df){
  
  p <- pubmed_df
  
  for(i in 1:nrow(p)){
      print(i)
      
      a <- str_split(p[i,]$Abstract,boundary("sentence"))
      a <- str_replace_all(unlist(a),"[[:punct:]]","")
      b <- data_frame(paper = p[i,]$paper, sentence = a)
      if(!exists('b_df')){
        b_df <- data_frame(paper = b$paper, line = 1:length(b$sentence), text =b$sentence)  
      } else {
        b_df <- bind_rows(b_df,data_frame(paper = b$paper, line = 1:length(b$sentence), text =b$sentence))
      }
      
      #print(b_df)
  }
  
  # tidy text
  
  b_df <- b_df %>%
    unnest_tokens(word,text)
  
  # remove stop words
  
  data("stop_words")
  b_df <- b_df %>%
    anti_join(stop_words)
  
  # ver as palavras mais comuns
  b_df %>%
    count(word,sort=T) 
  
  return(b_df)
  
}