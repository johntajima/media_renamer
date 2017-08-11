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

> media_renamer <path> [options]
> media_renamer -f <file> [options]

-y, --force     (no confirmation required)
-D, --delete    (delete invalid files/empty dir - otherwise move to <target>/deletable )
-d, --dest-path=<destination path> | <source path>
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

> execute with <file>|<dir>

- if param is <dir>,
  - Dir.glob all files in sorted reverse order (deepest first)
  - for each <file>
    - if valid file (video/audio/...)
        process file
      if invalid
        move to <target>./deleteable
      if dir,
        move to <target>./deleteable if dir is empty

Process File:
- if movie,
  - get metadata and determine title
  - do Tmdb api lookup to get movie title
  - move to <dest> with new name
  - if parent path is empty, move parent path to deletable

- if TV,
  <tba>
- else
  move to deleteable



> media_renamer rename /downloads/avatar (2012)/avatar (2012).mkv

> media_renamer rename /downloads/avatar (2012) -p /downloads
  - process this path and all files in the path, and delete this path

> media_renamer rename /downloads
  - process all files found in this path, but keep downloads file as the parent
  - don't delete this path