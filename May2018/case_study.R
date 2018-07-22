bos_reviews <- readRDS('bos_reviews.rds')
bos_pol <- readRDS('bos_pol.rds')


#polarity of the reviews
ggplot(bos_pol$all, aes(x = polarity, y = ..density..)) +
  theme_gdocs() + 
  geom_histogram(binwidth = 0.25, fill = "#bada55", colour = "grey60") +
  geom_density(size = 0.75)



#comparison cloud
library(wordcloud)

bos_reviews_with_pol <- bos_reviews %>% 
  mutate(polarity = bos_pol$all$polarity)

pos_comments <- bos_reviews_with_pol %>% 
  filter(polarity > 0) %>% 
  pull(comments)
neg_comments <- bos_reviews_with_pol %>% 
  filter(polarity < 0) %>% 
  pull(comments)
pos_terms <- paste(pos_comments, collapse = " ")
neg_terms <- paste(neg_comments, collapse = " ")
all_terms <- c(pos_terms, neg_terms)

all_corpus <- all_terms %>% 
  VectorSource() %>% 
  VCorpus()

all_tdm <- TermDocumentMatrix(
  all_corpus, 
  control = list(
    weighting = weightTfIdf, 
    removePunctuation = T, 
    stopwords = stopwords(kind = "en")
  )
)
all_tdm_m <- as.matrix(all_tdm)
colnames(all_tdm_m) <- c('positive words', 'negative words')
order_by_pos <- order(all_tdm_m[, 1], decreasing = T)
order_by_neg <- order(all_tdm_m[ ,2], decreasing = T)

comparison.cloud(
  all_tdm_m, 
  max.words = 500,
  colors = c("#013b63","#b70e4d")
)


# Scaled comparison cloud 
bos_reviews$scaled_polarity <- scale(bos_pol$all$polarity) 
pos_comments <- subset(bos_reviews$comments, bos_reviews$scaled_polarity > 0)
neg_comments <- subset(bos_reviews$comments, bos_reviews$scaled_polarity < 0)
pos_terms <- paste(pos_comments, collapse = " ")
neg_terms <- paste(neg_comments, collapse = " ")
all_terms<- c(pos_terms, neg_terms)
all_corpus <- VCorpus(VectorSource(all_terms))
all_tdm <- TermDocumentMatrix(
  all_corpus, 
  control = list(
    weighting = weightTfIdf, 
    removePunctuation = TRUE, 
    stopwords = stopwords(kind = "en")))

all_tdm_m <- as.matrix(all_tdm)
colnames(all_tdm_m) <- c("positive", "negative")
comparison.cloud(all_tdm_m, 
                   max.words = 100,
                   colors = c("darkblue", "darkred"))



#results in different places
load('geocoded_tweets.rda')
tweets_bing <- inner_join(geocoded_tweets, bing)
tweets_bing %>% 
  group_by(state, sentiment) %>%
  summarize(freq = mean(freq)) %>%
  spread(sentiment, freq) %>%
  ungroup() %>%
  mutate(ratio = positive / negative,
         state = reorder(state, ratio)) %>%
  ggplot(aes(state, ratio)) +
  geom_point() +
  coord_flip()




#climate change in the news (how sentiment change over time)
library(tidytext)
library(lubridate)

load('climate_text.rda')

tidy_tv <- climate_text %>%
  unnest_tokens(word, text)

sentiment_by_time <- tidy_tv %>%
  mutate(date = floor_date(show_date, unit = "6 months")) %>%
  group_by(date) %>%
  mutate(total_words = n()) %>%
  ungroup() %>%
  inner_join(get_sentiments("nrc"))

sentiment_by_time %>%
  filter(sentiment %in% c("positive", "negative")) %>%
  count(date, sentiment, total_words) %>%
  ungroup() %>%
  mutate(percent = n / total_words) %>%
  ggplot(aes(x = date, y = percent, colour = sentiment)) +
  geom_line(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, lty = 2) +
  expand_limits(y = 0)


tidy_tv %>%
  mutate(date = floor_date(show_date, unit = "1 month")) %>%
  filter(word %in% c("threat", "hoax", "denier",
                     "real", "warming", "hurricane")) %>%
  count(date, word) %>%
  ungroup() %>%
  ggplot(aes(date, n, color = word)) +
  facet_wrap(~word) +
  geom_line(size = 1.5, show.legend = FALSE) +
  expand_limits(y = 0)

