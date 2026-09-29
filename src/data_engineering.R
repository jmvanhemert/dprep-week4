# Load the data
library(tidyverse)

video_view <- read_csv("data/video_view.csv")
user_view <- read_csv("data/user_view.csv")
videos <- read_csv("data/videos.csv")
impressions <- read_csv("data/impressions.csv")
sessions <- read_csv("data/sessions.csv")
users <- read_csv("data/users.csv")
watch_events <- read_csv("data/watch_events.csv")
creators <- read_csv("data/creators.csv")

# Exercise 1
video_features <-video_view %>% mutate(watch_rate_rank = rank(-watch_rate),
    reach_band = case_when(
        impressions_n < 20 ~ "Low",
        impressions_n < 60 ~ "Medium",
        TRUE ~ "High"   
    ),
    high_quality = avg_watch_share >= 0.40) %>%
    distinct(video_id, .keep_all = TRUE) %>%
    arrange(watch_rate_rank)

write_csv(video_features, "temp/video_features.csv")

video_features <- video_view %>%
    mutate(watch_rate_rank = rank(-watch_rate),
        reach_band = case_when(
            impressions_n < 20 ~ "Low",
            impressions_n < 60 ~ "Medium",
            TRUE ~ "High"
        ),
        high_quality = avg_watch_share >= 0.40) %>%
        distinct(video_id, .keep_all = TRUE) %>%
        arrange(watch_rate_rank)


# Exercise 2
creator_summary <- video_features %>% group_by(creator_id) %>% 
    summarise(
        impressions_total = sum(impressions_n, na.rm = TRUE),
        watched_total = sum(watched_n, na.rm = TRUE),
        avg_watch_rate = mean(watch_rate, na.rm = TRUE),
        median_watch_seconds = median(avg_watch_seconds_when_watched, na.rm = TRUE),
        videos_n = n()
    ) %>%
    arrange(desc(impressions_total))

write_csv(creator_summary, "temp/creator_summary.csv")

engagement_by_band <- video_features %>%
    group_by(reach_band) %>%
    summarise (
        videos_n = n(),
        avg_watch_rate = mean(watch_rate, na.rm = TRUE)
    )

write_csv(engagement_by_band, "temp/engagement_by_band.csv")

# Exercise 3

video_enriched <- video_features %>%
    left_join(videos, by = c("video_id", "creator_id")) %>%
    left_join(creators, by = "creator_id") %>%
    select(video_id, creator_id, creator_name, impressions_n, watch_rate, watch_rate_rank, quality, posting_rate, publish_time)

write_csv(video_enriched, "temp/video_enriched.csv")

user_enriched <- user_view %>%
    left_join(users, by = "user_id") %>%   
    select(user_id, impressions_n, watched_n,
    watch_rate, like_n, follow_n, baseline_login, satiation_decay)

write_csv(user_enriched, "temp/user_enriched.csv")

# Exercise 4

watch_log <- impressions %>%
    left_join(watch_events, by = c("impression_id", "session_id", "user_id", "video_id", "creator_id")) %>%
    left_join(sessions, by = c("session_id", "user_id", "video_id", "creator_id")) %>%
    left_join(videos, by = c("video_id", "creator_id"))

# Exercise 5




