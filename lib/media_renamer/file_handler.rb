module MediaRenamer
  class FileHandler

    VIDEO_EXT = %w| .avi .mp4 .mkv .mov .divx|
    MUSIC_EXT = %w| .ogg .mp3 .aac .flac |
    SUB_EXT   = %w| .sub .srt .idx |
    IMAGE_EXT = %w| .jpeg .jpg .bmp .png .tiff|

    attr_reader :file

    def initialize(file)
      @file = File.expand_path(file)
      raise InvalidFileError, "File or path '#{file}' does not exist" unless File.exist?(@file)
    end

    def file?
      File.file?(@file)
    end

    def dir?
      File.directory?(@file)
    end

    def path
      file? ? File.dirname(@file) : @file
    end

    def filename
      file? ? File.basename(@file) : nil
    end

    def ext
      File.extname(@file)
    end

    def type
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

    def mv(name, path = nil)
      # rename file if path is nil
      # move file to new path if 
    end

    def delete!
      # delete file
    end

  end
end