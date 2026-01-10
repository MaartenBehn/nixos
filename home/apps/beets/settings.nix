{
  essentia-extractor,
  keyfinder-cli,
  music-dir,
  cache-dir,
  playlist-dir,
  essentia-extractor-SVM-models-dir ? "${cache-dir}/svm_models",
  ...
}:
{
  directory = music-dir;
  library = "${cache-dir}/library.db";

  art_filename = "cover";
  per_disc_numbering = true; # For better alignment with lidarr's format

  plugins = [
    # Re-arrange paths to account for the outsized number of album
    # artists with names starting with "the"
    "the"

    # Use m3u playlists
    "playlist"

    # Build playlists based on Beets searches. Would be really
    # cool to make some DJ-oriented lists, as well as replicating
    # "newly released", "liked tracks", and "highly rated"
    # playlists.
    "smartplaylist"

    # Build an m3u playlist based on newly imported music - a
    # "just in" playlist, basically.
    "importfeeds"

    # This plugin will provide data to help normalise the audio.
    "replaygain"

    # Apply permissions to imported tracks
    #"permissions"

    # Fetches and stores song lyrics from databases on the Web
    #"lyrics"

    # Interact with the listenbrainz service
    #"listenbrainz"

    # Detect the musical key of a track from its audio data and
    # store it in the initial_key field of the beets database.
    #
    # Could be really cool to use this:
    #  - To add key metadata to all files
    #  - To Build smart playlists by BPM + Key
    "keyfinder"

    # If you tag your music using MusicBrainz, you’ll have tracks
    # in your library like “Tellin’ Me Things” by the artist
    # “Blakroc feat. RZA”. If you prefer to tag this as “Tellin’
    # Me Things feat. RZA” by “Blakroc”, then this plugin is for
    # you.
    "ftintitle"

    # Retrieves album art images from various sources on the Web
    # and stores them as image files
    "fetchart"

    # Finds and lists duplicate tracks or albums in your
    # collection
    "duplicates"

    # Find matches using Discogs
    #"discogs"

    # Submit fingerprints to acoustid for easier identification in
    # the future.
    # Use Chromaprint to fingerprint tracks
    "chroma"

    # Check for missing and corrupt files
    #"badfiles"

    # Obtain low and high level musical information from your songs
    # (bpm, danceability, etc).
    #"xtractor"

    # Useful template fields to customize your path formats in a more
    # lidarr way
    "lidarrfields"

    # Verify and store checksums
    #"check"
  ];

  keyfinder = {
    bin = "${keyfinder-cli}/bin/keyfinder-cli";
  };

  xtractor = {
    essentia_extractor = "${essentia-extractor}/bin/streaming_extractor_music";
    output_path = "${cache-dir}/xtractor-extraction-data";
    extractor_profile = {
      highlevel = {
        svm_models =
          map (model: "${essentia-extractor-SVM-models-dir}/${model}")
            [
              "danceability.history"
              "gender.history"
              "genre_rosamerica.history"
              "mood_acoustic.history"
              "mood_aggressive.history"
              "mood_electronic.history"
              "mood_happy.history"
              "mood_sad.history"
              "mood_party.history"
              "mood_relaxed.history"
              "voice_instrumental.history"
              "moods_mirex.history"
            ];
      };
    };
  };

  ui = {
    color = true;
    terminal_width = 140;
  };

  badfiles = {
    check_on_import = true;
  };

  permissions = {
    file = "777";
    dir = "777";
  };

  importfeeds = {
    relative_to = music-dir;
    playlist_dir = playlist-dir;
    absolute_path = false;
    formats = [
      "m3u"
      "echo"
    ];
    m3u_name = "${playlist-dir}/just-in.m3u";
  };

  smartplaylist = {
    relative_to = music-dir;
    playlist_dir = playlist-dir;
    forward_slash = false;
    playlists = [
      # TODO: Build some amazing playlists here
      # https://beets.readthedocs.io/en/stable/plugins/smartplaylist.html
      {
        name = "all.m3u";
        query = "";
      }
    ];
  };

  playlist = {
    relative_to = music-dir;
    playlist_dir = playlist-dir;
    auto = false;
    forward_slash = false;
  };

  musicbrainz = {
    external_ids = {
      #discogs = true;
      spotify = true;
      bandcamp = true;
      beatport = true;
      deezer = true;
      tidal = true;
    };
  };

  paths = {
    # For better alignment with lidarr's format
    default = "%the{$releasegroupartist}/$lidarralbum ($year)/%if{$audiodisctotal,$disc - }$\{track}. $title";
  };

  import = {
    move = false;
    copy = false;
    write = false;

    resume = false;
    incremental = false;

    # Controlling whether skipped directories are recorded in the
    # incremental list. When set to yes, skipped directories won’t
    # be recorded, and beets will try to import them again
    # later. When set to no, skipped directories will be recorded,
    # and skipped later. Defaults to no.
    incremental_skip_later = true;

    # Specifies what should happen during an interactive import
    # session when there is no recommendation. Useful when you are
    # only interested in processing medium and strong
    # recommendations interactively.
    none_rec_action = "skip";

    #  Controls how duplicates are treated in import task. “skip”
    #  means that new item(album or track) will be skipped; “keep”
    #  means keep both old and new items; “remove” means remove old
    #  item; “merge” means merge into one album; “ask” means the
    #  user should be prompted for the action each time. The default
    #  is ask.
    duplicate_action = "skip";
  };
}
