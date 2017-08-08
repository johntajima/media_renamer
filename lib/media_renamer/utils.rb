module MediaRenamer

  module Utils

    extend self

    TITLE_STOP_WORDS = %w| 
      xvid dvdrip dvdscr screener bluray brrip divx       
      h264 h265 hevc 
      cd1 cd2 
      rarbg stv yify
      1080p 720p |



    # given a width and height, returns back video format
    # 8k      7680x4320
    # 4k      4096x
    # 2k      2048x
    # 1080p   1920x1080
    # 720p    1280x720
    # 480p    640x480
    # 360p    480x360
    def video_format(width, height)
      if width >= 7600 || height >= 4300
        "8K"
      elsif width >= 4000
        "4K"
      elsif width >= 2000
        "2K"
      elsif width >= 1900 || height >= 1000
        "1080p"
      elsif width >= 1200 || height >= 700
        "720p"
      elsif width >= 640 || height >= 480
        "480p"
      elsif width >= 480 || height >= 360
        "360p"
      else
        "SD"
      end
    end

    # hevc, h264, mpeg4, msmpeg4, vc1
    def video_codec(codec)
      case codec
      when "h264"
        'H264'
      when "mpeg4"
        'MP4'
      when 'hevc', 'h265'
        "HEVC"
      else
        nil
      end
    end

    # "aac", "ac3", "dca", "mp3", "truehd", "wmav2"
    def audio_codec(codec, channels = nil)
      text = case codec
        when 'aac', 'ac3', 'mp3', 'dca'
          codec.upcase
        else
          'OTH'
        end
      channels ? "#{text} #{channels}ch" : text
    end

    def title_from_file(filename)
      # remove extension
      filename = File.basename(filename, ".*")

      # convert . to spaces
      filename = filename.gsub(/\./,' ')

      # add space infront of [] or ()
      filename = filename.gsub(/\[/, " [").gsub(/\(/, " (")

      # remove extra spaces
      filename = filename.gsub(/\s+/, ' ')

      # ignore anything after ( or [
      filename = filename.split(/\[|\(/).first.strip
      
      # get filename before any stop words
      filename = filename.downcase.split(/#{TITLE_STOP_WORDS.join("|")}/).first || ""

      # remove year if its the last word but not the only word
      words = filename.split(" ")
      if words.count > 0
        filename = if words.last.match(/\d{4}/) && words.count > 1
          words[0..-2].join(" ")
        else
          words.join(" ")
        end
      else
        filename
      end

      # titleize remaining words and strip
      filename.strip.titleize
    end

    # extract the year from filename
    def year_from_file(filename)
      filename = File.basename(filename, ".*")

      # grab year in () or []
      if result = /(\[|\()(\d{4})(\]|\))/.match(filename)
        return result[2].to_i
      end


      # find year as last word in filename
      filename = filename.gsub(/\./,' ').gsub(/\s+/, ' ')
      filename = filename.split(/\[|\(/).first.strip
      filename = filename.downcase.split(/#{TITLE_STOP_WORDS.join("|")}/).first || ""

      words = filename.split(" ")
      if words.count > 1 && result = words.last.match(/(\d{4})/)
        return result[1].to_i
      end
    end

  end

end