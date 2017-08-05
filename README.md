# MediaRenamer

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/media_renamer`. To experiment with that code, run `bin/console` for an interactive prompt.

Media Renamer will analyze and rename your media files based on whether it's a movie or TV file. It will lookup movie information, and rename it against the templates specified.
It can almost move files to different locations based on the type of file, file size, attributes, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'media_renamer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install media_renamer

## Usage

TODO: Write usage instructions here


## HLD

> media_renamer <path/to/files> [options]

-f, --force     (no confirmation required)
-t, --template=<file of liquid templates>
    --dry-run


## config file
~/.media_rename.yml

TMDB_API: 
MOVIE_TEMPLATE:
TV_TEMPLATE:

### Templates

Movie:

/Movies/The Terminator (1983) [1080p] Extended Cut [HEVC]/The Terminator (1983) [1080p] Extended Cut [HEVC] [AAC 6ch].mkv
/Movies/Blade Runner (1983) [1080p] Final Cut/Blade Runner (1983) [1080p] Final Cut [AC3 2ch].mkv
/Movies/Parenthood (1999) [720p]/Parenthood (1999) [720p] [AC3 2ch].mkv


## High Level Design

- recursively go through provided directory and find all media files 
  (video files, subtitle files)
  - delete all other files (txt, image, info, etc files)?

- for each video file
  - reject if too short (< 10 min)
  - get mediainfo on file
  - if 0-60min => tv, 60+ => movie
  - if movie
    - api lookup at tmdb api and get file info
    if TV
    - api lookup at ...
  - if api match(es) found,
    - populate models and preview new file name/location for each match
    - allow user to select which to use (dflt is first one)
  - make change and delete old folder


### models

#### SourceFile
  - path
  - name
  - format

#### MediaInfo
  - filename
  - resolution (1080p, 720p, 480p, 360p, 320p, 2160p, 4k, ...)
  - width
  - height
  - format [hevc, x265, x264, avi, mpeg4, mp4, ...]
  - audio_codec (aac, ac3, dts, ...)
  - video_codec (...)
  - duration
  - bitrate
  - tags [directors cut, extended, ....]


### Movie / TV record
  - name
  - year
  - genres
  - 