# MediaRenamer

MediaRenamer is a gem and CLI that will rename your video files.

It will scan recursively through the path you provide and if it finds a video file, it will guess the movie name, lookup in Tmdb API and rewrite the filename based on the movie in the target folder you designate. It will also remove unrelated files such as screenshots, sub files, and text files.

You can specify the format of the rewritten file using liquid template stored in the config file.

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

    media_renamer rename <path|file> [options]

    Options:
      -f, [--force]                              # Force renaming, 
                                                   without prompting for confirmation
      -p, [--root-path=ROOT_PATH]                # Root path (default is path passed in)
      -t, [--target-path=TARGET_PATH]            # Specify target directory to save 
                                                   renamed files in
      -D, [--delete-files], [--no-delete-files]  # delete files and empty directories 
                                                   (default moves them to ~/.deleteable)
          [--debug], [--no-debug]                # Debug mode
          [--preview], [--no-preview]            # Dry run - don't actually make changes
      --tv,                                      # video files are assumed TV shows

-f will skip the confirmation step. With confirmation, Y or enter will confirm the action, any other character will skip that action, q or Ctrl-C will quit.

-t=<path> defines what the target path is. This will be used as the target path in the template when used to generate the destination file

-D will delete empty directories and invalid files, otherwise it will move them to the <root_path>/.deletable/<orig filename> path for later manual deletion/review

--preview will not do anything, just print out what action would take place


## config file
    ~/.media_rename.yml

    TMDB_API: <your API key>
    MOVIE_TEMPLATE: {{target_path}}/{{title}} ({{year}}) [{{video_format}}]/\
                    {{title}} ({{year}}) [{{video_format}}].{{ext}}
    TV_TEMPLATE: {{target_path}}/{{title}}/{{title}} Season {{season}}/\
                 {{title}} S{{season}}E{{episode}}.{{ext}}

### Templates

Templates use liquid template language.
Variables are:

    title           # name of the movie: eg: Avatar
    year            # year of the movie
    video_format    # format: 1080p, 720p, 4K, 2K, 480p, 360p, SD
    video_codec     # video codec: HEVC, H264, MP4
    audio_codec     # audio codec and channels: AAC 6ch, AC3 2ch, MP3 7ch
    ext             # file extension: mp4, avi, divx, mkv
    tag             # tags: eg: Extended, Directors Cut, ...
    target_path     # the root absolute path of where renamed files should go

### TO DO

~Only movies are recognized right now.~
~TV shows will be coming soon.~ Done.

Audio files are recognized but skipped.

All other files (including sub files) are considered deleteable. This means image files, sub files, text files and all others are considered deleteable.

Tests are not working or need updating!