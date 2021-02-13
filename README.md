# export-spotify-data
Some rough R code for exporting a list of Spotify songs to CSV, specifically: songs in playlists you've created, and any songs you've saved. Uses the spotifyr package.

#### Notes:
- Installing spotifyr from CRAN didn't work for me, I had to use devtools.
- You'll need to create a Spotify developer account and create an application (e.g. "My Test App") in the developer dashboard. That gives you your client ID and client secret.
- Also in the developer dashboard, edit your test application's settings and set `http://localhost:1410/` as the callback URI.

#### Helpful links:
- https://github.com/charlie86/spotifyr
- https://rpubs.com/womeimingzi11/how_my_spotify_looks_like
