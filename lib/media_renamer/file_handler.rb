module MediaRenamer
  class FileHandler

    attr_reader :file?, :dir?, :filename, :ext, :path, :title, :type

    VIDEO_EXT = %w| .avi .mp4 .mkv .mov .divx|
    MUSIC_EXT = %w| .ogg .mp3 .aac .flac |
    SUB_EXT   = %w| .sub .srt .idx |
    IMAGE_EXT = %w| .jpeg .jpg .bmp .png .tiff|

    def initialize(file)
      @file = File.expand_path(file)
    end

    def file?
      File.file?(@file)
    end

    def dir?
      File.directory(@file)
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



  end
end