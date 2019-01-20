library(ggthemes)
library(qdap)
library(ggplot2)
library(magrittr)
library(tm)
library(dplyr)
library(tidytext)
library(tidyr)

?qdap
?tidytext



my_sentence <- 'Rladies are awesome and great for learning'
(positivity <-polarity(my_sentence))
(which_are_positive <- counts(positivity))

bos_reviews <- readRDS('bos_reviews.rds')
bos_pol <- readRDS('bos_pol.rds')


bos_reviews %$% polarity(comments)


all_books_tidy <- readRDS('all_books_tidy.rds')
all_books_tdm <- readRDS('all_books_tdm.rds')



moby_tidy <- filter(all_books_tidy, book == 'moby_dick')

#with BING
bing <- get_sentiments('bing')

(moby_bing_words <- inner_join(moby_tidy, bing, by = c('term' = 'word')))

moby_bing_words %>%
  count(sentiment)

#how words contribute to polarity
(moby_tidy_sentiment <- moby_bing_words %>% 
  count(term, sentiment, wt = count) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(polarity = positive - negative))

#plot the above
moby_tidy_small <- moby_tidy_sentiment %>% 
  filter(abs(polarity) >= 50)

moby_tidy_pol <- moby_tidy_small %>% 
  mutate(
    pol = ifelse(polarity > 0, 'positive', 'negative')
  )

ggplot(
  moby_tidy_pol, 
  aes(reorder(term, polarity), polarity, fill = pol)
) +
  geom_bar(stat = 'identity') + 
  ggtitle('Moby Dick: Sentiment Word Frequency') + 
  theme_gdocs() +
  theme(axis.text.x = element_text(angle = 90, vjust = -0.1))




#comapring diferent docs
nrc <- get_sentiments('nrc')
books_sents <- all_books_tidy %>% inner_join(nrc, by = c('term' = 'word'))
books_pos_neg <- books_sents %>%
  filter(grepl('positive|negative', sentiment))

(books_sent_count <- books_pos_neg %>%
  count(book, sentiment))

book_pos <- books_sent_count %>%
  group_by(book) %>% 
  mutate(percent_positive = n / sum(n) * 100)

ggplot(book_pos, aes(x = book, y = percent_positive, fill = sentiment)) +  
  geom_bar(stat = 'identity')




(afinn <- get_sentiments('afinn'))

huck_tidy <- filter(all_books_tidy, book == 'huck_finn')

(huck_afinn <- huck_tidy %>% 
  inner_join(afinn, by = c('term' = 'word')))


(huck_nrc <- huck_tidy %>% inner_join(nrc, by = c('term' = 'word')))

(huck_plutchik <- huck_nrc %>% 
  filter(!sentiment %in% c('positive', 'negative')) %>%
  group_by(sentiment) %>% 
  summarise(total_count = sum(count)))

ggplot(huck_plutchik, aes(x = sentiment, y = total_count)) +
    geom_col()
