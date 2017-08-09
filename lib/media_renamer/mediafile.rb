module MediaRenamer


  require 'streamio-ffmpeg'

  class Mediafile

    VIDEO_EXT = %w| .avi .mp4 .mkv .mov .divx|
    MUSIC_EXT = %w| .ogg .mp3 .aac .flac |
    SUB_EXT   = %w| .sub .srt .idx |
    IMAGE_EXT = %w| .jpeg .jpg .bmp .png .tiff|

    MIN_MOVIE_TIME = 60 * 60 # 1hr
    MIN_TV_TIME    = 20 * 60 # 20m

    attr_reader :filename, :path, :ext


    def initialize(filename)
      @file     = File.expand_path(filename)
      @exists   = File.exist?(@file)
      @ext      = File.extname(@file)
      @path     = directory? ? @file : File.dirname(@file)
      @filename = File.basename(@file)
      @ext      = File.extname(@file)
    end


    def file?
      File.file?(@file)
    end

    def directory?
      File.directory?(@file)
    end

    def video?
      VIDEO_EXT.include?(ext)
    end

    def subtitle?
      SUB_EXT.include?(ext)
    end

    def type
      return :directory if directory?
      case 
      when VIDEO_EXT.include?(ext)
        :video
      when MUSIC_EXT.include?(ext)
        :music
      when SUB_EXT.include?(ext)
        :subtitle
      when IMAGE_EXT.include?(ext)
        :image
      else
        :unknown
      end
    end

    def exists?
      @exists
    end

    def title
      @title ||= MediaRenamer::Utils.title_from_file(filename)
    end

    def year
      @year ||= MediaRenamer::Utils.year_from_file(filename)
    end

    def video_format
      @video_format ||= MediaRenamer::Utils.video_format(mediainfo.width, mediainfo.height)
    end

    def video_codec
      @video_codec ||= MediaRenamer::Utils.video_codec(mediainfo.video_codec)
    end

    def audio_codedc
      @audio_codec ||= MediaRenamer::Utils.audio_codec(mediainfo.audio_codec, mediainfo.audio_channels)
    end

    def duration
      mediainfo.duration
    end

    def filesize
      mediainfo.size
    end

    def to_hash
      return {} unless exists? && video? && mediainfo.valid?

      {
        title: title,
        year: year,
        filename: filename,
        duration: mediainfo.duration,
        filesize: mediainfo.size,
        width: mediainfo.width,
        height: mediainfo.height,
        video_format: video_format,
        video_codec: video_codec,
        audio_codec: audio_codec
      }
    end

    def to_json
      to_hash.to_json
    end


    private

    def raw_title
      return unless mediainfo.format_tags
      mediainfo.format_tags.fetch(:title, @filename)
    end

    def mediainfo
      @mediainfo ||= FFMPEG::Movie.new(@file)
    end
  end
end