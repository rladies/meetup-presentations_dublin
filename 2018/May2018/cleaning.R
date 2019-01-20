text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

library(dplyr)

#lowercase letters
(text <- tolower(text))


(text_df <- data_frame(line = 1:4, text = text))


#onto tidy format
library(tidytext)
(text_tidy <- text_df %>%
  unnest_tokens(word, text))


?removePunctuation
?stripWhitespace
?replace_abbreviation
?replace_contraction
?stopwords

library(tm)
stopwords()

(text_tidy_nostop <- anti_join(text_tidy, stop_words))
