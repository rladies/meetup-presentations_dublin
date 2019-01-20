
#wordclouds
library(wordcloud2)
(moby_word_count <- moby_tidy %>%
    count(term, sort = T))
wordcloud2(moby_word_count[1:300, ], size = .5)
wordcloud2(moby_word_count[1:300, ], size = .5, color = 'random-light', backgroundColor = 'grey')




#kernel density plots
moby_afinn <- inner_join(moby_tidy, afinn, by = c('term' = 'word'))
huck_afinn <- inner_join(huck_tidy, afinn, by = c('term' = 'word'))

all_df <- rbind(moby_afinn, huck_afinn)
ggplot(all_df, aes(x = score, fill = book)) + 
  geom_density(alpha = 0.3) + 
  theme_gdocs() +
  ggtitle('AFINN Score Densities')





#multiple documents polarity
all_book_polarity <- readRDS('all_books_polarity.rds')

ggplot(all_book_polarity, aes(x = book, y = polarity)) +
  geom_boxplot(fill = c('#bada55', '#F00B42', '#F001ED', '#BA6E15'), col = 'darkred') +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 0.02) +
  theme_gdocs() +
  ggtitle('Book Polarity')



#spiderweb (radar chart), 
library(radarchart)
moby_berry <- filter(all_books_tidy, book == 'tom_sawyer' | book == 'huck_finn' | book == 'moby_dick' | book == 'confidence_man' | book == 'ct_yankee')
books_sents <- inner_join(moby_berry, nrc, by = c('term' = 'word'))

books_pos_neg <- books_sents %>%
  filter(!grepl('positive|negative', sentiment))

books_tally <- books_pos_neg %>%
  group_by(book, sentiment) %>%
  tally()

scores <- books_tally %>%
  spread(book, n) 

# JavaScript radar chart
chartJSRadar(scores)

#why green so much bigger
dim(huck_tidy)
dim(moby_tidy)

