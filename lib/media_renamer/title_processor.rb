module MediaRenamer

  # extracting possible title from filename for API lookup
  module TitleProcessor

    extend self

    INVALID_WORDS = %w| 
      dvdrip 
      dvdscr 
      screener 
      bluray 
      xvid 
      h264 
      h265 
      hevc 
      brrip 
      cd1 
      cd2 
      divx 
      1080p
      720p      
      |


    def movie_title(filename)
      # remove extension
      filename = File.basename(filename, ".*")

      # convert . to spaces
      filename = filename.gsub(/\./,' ')

      # add space infront of [] or ()
      filename = filename.gsub(/\[/, " [").gsub(/\(/, " (")

      # remove extra spaces
      filename = filename.gsub(/\s+/, ' ')

      # ignore anything after ( or [
      filename = filename.split(/\[|\(/).first
      
      # split after any keywords
      filename = filename.downcase.split(/#{INVALID_WORDS.join("|")}/).first

      # remove year if its the last word but not the only word
      words = filename.split(" ")
      filename = if words.last.match(/\d{4}/) && words.count > 1
        words[0..-2].join(" ")
      else
        words.join(" ")
      end

      # titleize remaining words and strip
      filename.strip.titleize
    end



  end

end