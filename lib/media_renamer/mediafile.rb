module MediaRenamer

  require 'streamio-ffmpeg'
  require 'ostruct'

  class Mediafile

    include FileParser

    attr_reader :type, :filename, :ext, :exists, :directory,
                :title, :year, 
                :tv_season, :tv_episode, 
                :video_format, :video_codec, :audio_codec, :tags

    def initialize(filename)
      @filename = File.expand_path(filename)
      @file     = sanitize_filename(filename)
      @ext      = File.extname(@filename).gsub(/\./,'')
      @type     = get_file_type(@filename)

      @title    = extract_title(@file)
      @year     = extract_year(@file)
      @tags     = extract_tags(@file)
      if type == :tv
        @tv_season = extract_season(@file)
        @tv_episode = extract_episode(@file)
      end
      extract_media_info if video?
    end

    def video?
      VIDEO_EXT.include?(ext)
    end

    def exists?
      File.exist?(filename)
    end

    def directory?
      File.directory?(filename)
    end

    def attributes
      {
        type: type,
        filename: filename,
        ext: ext,
        exists: exists?,
        directory: directory?,
        title: title,
        year: year,
        tv_season: tv_season,
        tv_episode: tv_episode,
        video_format: video_format,
        video_codec: video_codec,
        audio_codec: audio_codec,
        tags: tags
      }
    end

    def to_liquid
      attributes.stringify_keys
    end

    private

    def duration
      mediainfo.duration
    end      

    def extract_media_info
      @video_format ||= MediaRenamer::Utils.video_format(mediainfo.width, mediainfo.height)
      @video_codec  ||= MediaRenamer::Utils.video_codec(mediainfo.video_codec)
      @audio_codec  ||= MediaRenamer::Utils.audio_codec(mediainfo.audio_codec, mediainfo.audio_channels)
    end

    def mediainfo
      @mediainfo ||= exists? ? FFMPEG::Movie.new(filename) : OpenStruct.new
    end
  end

end