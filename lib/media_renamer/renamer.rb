module MediaRenamer

  module Renamer

    DELETABLE_PATH = "/.deleteable/"

    extend self


    def lookup(filename, params = {})
      file = MediaRenamer::Mediafile.new(filename)
      case file.type
      when :movie
        movies = movie_lookup(file.attributes)
        file.attributes.merge(movies: movies)
      when :tv, :audio, :directory, :unknown
        file.attributes
      else 
        # override images, subtitle files
        return file.attributes.merge(type: :unknown)
      end
    end


    def rename_file(source, dest, options = {})
      # given a params object,
      # rename the file based on the suggestion provided
    end

    def delete_file(source, options = {})
      # given a params object
      # delete or move to deleteable path
      # if obj is a dir, delete or move if empty

      # if move
        # move to deleteable path
        # if file already exists, move to -1 path
      # if delete
        # delete file
    end

    def movie_lookup(params)
      title = params.fetch(:title)
      year  = params.fetch(:year, nil)
      MediaRenamer::Agents::TmdbAgent.search(title, year: year).slice(0,6)
    end


    def log
      MediaRenamer.logger
    end
  end
end
