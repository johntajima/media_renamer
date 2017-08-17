module MediaRenamer

  module Media
    extend self


    def find_movie(query, options = {})
      results = TMDb::Movie.search(query, options)
      sleep(0.5) # handle this better
      results.map {|entry| MediaRenamer::Movie.new(entry)}
    end

    def find_tv(query, options = {})
      results = TMDb::Movie.search(query, options)
      sleep(0.5) # handle this better
      results.map {|entry| MediaRenamer::TV.new(entry)}
    end
    
  end

end