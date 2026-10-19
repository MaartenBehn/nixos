{
  music-dir,
  cache-dir,
  playlist-dir,
  ...
}:
{
  directory = music-dir;
  library = "${cache-dir}/library.db";

  art_filename = "cover";

  plugins = [
    # Use m3u playlists
    #"playlist"

    # Build playlists based on Beets searches. Would be really
    # cool to make some DJ-oriented lists, as well as replicating
    # "newly released", "liked tracks", and "highly rated"
    # playlists.
    #"smartplaylist"

    # Build an m3u playlist based on newly imported music - a
    # "just in" playlist, basically.
    #"importfeeds"

    # This plugin will provide data to help normalise the audio.
    #"replaygain"

    # Apply permissions to imported tracks
    #"permissions"

    # Fetches and stores song lyrics from databases on the Web
    #"lyrics"

    # Interact with the listenbrainz service
    #"listenbrainz"

    # Retrieves album art images from various sources on the Web
    # and stores them as image files
    "fetchart"

    "lyrics"

    # Finds and lists duplicate tracks or albums in your
    # collection
    "duplicates"

    # identification
    "musicbrainz"
    "discogs"
    "fromfilename"
    #"beatport"


    # Submit fingerprints to acoustid for easier identification in
    # the future.
    # Use Chromaprint to fingerprint tracks
    "chroma"

    # Check for missing and corrupt files
    "badfiles"

    # Obtain low and high level musical information from your songs
    # (bpm, danceability, etc).
    #"xtractor"
    #"autobpm"

    # Useful template fields to customize your path formats in a more
    # lidarr way
    #"lidarrfields"

    # Verify and store checksums
    #"check"

    "info"

    "fish"
    "edit"

    "unimported"
  ];

  import = {
    move = false;
    copy = false;
    hardlink = true;
    write = true;
    autotag = true;
    threaded = false;

    resume = true;
    incremental = true;

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

  unimported = {
    ignore_extensions = "jpg png";
    ignore_subdirectories = "NonMusic data temp";
  };

  fetchart = {
    auto = true;
    minwidth = 500;
    maxwidth = 1200;
    enforce_ratio = true;
    sources = [
      "filesystem"
      "coverart"
      "itunes"
      "amazon"
      "albumart"
    ];
  };

  lyrics = {
    auto = true;
    sources = [
      "lrclib"
      "lrcmux"
    ];
    synced = true;
    fallback = "";
  };

  permissions = {
    file = "770";
    dir = "770";
  };

  musicbrainz = {
    ratelimit = 1;
    data_source_mismatch_penalty = 0.2;
    external_ids = {
      discogs = true;
      spotify = true;
      bandcamp = true;
      beatport = true;
      deezer = true;
      tidal = true;
    };
  };

  discogs = {
    data_source_mismatch_penalty = 0.3;
    user_token = "VLbHHdRPoocqxRnlSrhthdbWqJEMLqbYyhdMIXkt";
  };

  types = {
    
  };

  ui = {
    color = true;
    terminal_width = 140;
  };

  badfiles = {
    #check_on_import = true;
  };
}
