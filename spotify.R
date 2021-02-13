library(spotifyr)
library(tidyverse)

# Method for working within 50-item API limit taken from:
# https://rpubs.com/womeimingzi11/how_my_spotify_looks_like

id <- 'my_client_id' # client ID from Spotify developer dashboard
secret <- 'my_client_secret' # client secret from Spotify developer dashboard
Sys.setenv(SPOTIFY_CLIENT_ID = id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = secret)
access_token <- get_spotify_access_token()

# Export a list of all songs from my playlists to CSV

my_playlists <- ceiling(get_my_playlists(include_meta_info = TRUE)[['total']] / 50) %>%
  seq() %>%
  map(function(x) {
    get_my_playlists(limit = 50, offset = (x - 1) * 50)
  }) %>%
  reduce(bind_rows) %>%
  filter(owner.id == "my_spotify_username") # to only get playlists created by me

playlist_tracks_tmp <- my_playlists %>%
  mutate(track_list = map(id, ~get_playlist_tracks(.)))

playlist_tracks_final <- playlist_tracks_tmp %>%
  unnest(track_list, names_repair = "unique") %>%
  mutate(
    artist = map(track.artists, pluck, 3)
  ) %>%
  mutate(
    artist = as.character(map(artist, toString))
  ) %>%
  select(playlist_name = name,
         total_tracks = tracks.total,
         artist = artist,
         track_name = track.name
  )

write_csv(playlist_tracks_final, "my_playlist_songs.csv")

# Export a list of all my saved songs to CSV

my_songs_tmp <- ceiling(get_my_saved_tracks(include_meta_info = TRUE)[['total']] / 50) %>%
  seq() %>%
  map(function(x) {
    get_my_saved_tracks(limit = 50, offset = (x - 1) * 50)
  }) %>%
  reduce(bind_rows)

my_songs_final <- my_songs_tmp %>%
  mutate(
    artist = map(track.artists, pluck, 3)
  ) %>%
  mutate(
    artist = as.character(map(artist, toString))
  ) %>%
  select(
    artist = artist,
    album = track.album.name,
    song = track.name,
    track_number = track.track_number,
    date_added = added_at
  ) %>%
  arrange(artist, album, track_number)

write_csv(my_songs_final, "my_saved_songs.csv")