module MediaRenamer


  require 'streamio-ffmpeg'

  class Mediafile

    VIDEO_EXT = %w| avi mp4 mkv mov divx|
    AUDIO_EXT = %w| ogg mp3 aac flac |
    SUB_EXT   = %w| sub srt idx |
    IMAGE_EXT = %w| jpeg jpg bmp png tiff|

    MIN_MOVIE_TIME = 60 * 60 # 1hr
    MIN_TV_TIME    = 20 * 60 # 20m

    attr_reader :file, :filename, :path, :ext, :type, :year, :title, :tag, :movie, :suggestions


    def initialize(filename)
      @file     = File.expand_path(filename)
      @filename = File.basename(@file)
      set_file_type
      parse_file
    end

    def file?
      File.file?(@file)
    end

    def directory?
      File.directory?(@file)
    end

    def exists?
      File.exist?(@file)
    end

    def video?
      VIDEO_EXT.include?(ext)
    end

    def movie?
      type == :movie
    end

    def tv?
      type == :tv
    end

    def subtitle?
      SUB_EXT.include?(ext)
    end

    def ext
      @ext ||= File.extname(@file).gsub(/\./,'')
    end

    def path
      @path ||= directory? ? @file : File.dirname(@file)
    end

    def video_format
      @video_format ||= MediaRenamer::Utils.video_format(mediainfo.width, mediainfo.height)
    end

    def video_codec
      @video_codec ||= MediaRenamer::Utils.video_codec(mediainfo.video_codec)
    end

    def audio_codec
      @audio_codec ||= MediaRenamer::Utils.audio_codec(mediainfo.audio_codec, mediainfo.audio_channels)
    end

    def duration
      mediainfo.duration
    end

    def filesize
      mediainfo.size
    end

    def movie
      movies.first
    end

    def movies
      @movies ||= begin
        return [] unless movie?
        MediaRenamer::Agents::TmdbAgent.search(title, year: year).slice(0,6)
      end
    end

    def suggestions
      movies
    end

    def attributes
      params = {
        file: file,
        type: type,
        filename: filename,
        ext: ext,
        path: path,
        title: title,
        year: year,
        tag: tag,
        movie: movie,
        suggestions: movies
      }
      if video?
        params.merge!(video_attributes)
      end
      params
    end

    def to_hash
      attributes
    end

    def to_json
      attributes.to_json
    end

    def to_liquid
      attributes.stringify_keys.to_liquid
    end

    private

    def video_attributes
      return {} unless video?
      {
        duration: mediainfo.duration,
        filesize: mediainfo.size,
        width: mediainfo.width,
        height: mediainfo.height,
        video_format: video_format,
        video_codec: video_codec,
        audio_codec: audio_codec        
      }
    end

    def parse_file
      parsed  = MediaRenamer::FileParser.new(@filename)
      @title  = parsed.title
      @year   = parsed.year
      @tag    = parsed.tag
    end

    def set_file_type
      @type ||= begin
        return :unknown if !exists?
        return :directory if directory?      
        case 
        when VIDEO_EXT.include?(ext)
          if duration >= MIN_MOVIE_TIME
            :movie
          elsif duration >= MIN_TV_TIME
            :tv
          else
            :unknown 
          end
        when AUDIO_EXT.include?(ext)
          :audio
        when SUB_EXT.include?(ext)
          :subtitle
        when IMAGE_EXT.include?(ext)
          :image
        else
          :unknown
        end
      end
    end

    def raw_title
      return unless mediainfo.format_tags
      mediainfo.format_tags.fetch(:title, @filename)
    end

    def mediainfo
      @mediainfo ||= FFMPEG::Movie.new(@file)
    end

  end
end