module MediaRenamer
  module Agents

    module TmdbAgent

      extend self

      def search(query, options = {})
        results = tmdb.search(query, options)
        sleep(0.5)
        results.map {|entry| MediaRenamer::Movie.new(entry)}
      end

      private

      def tmdb
        @tmdb ||= begin
          TMDb.api_key = MediaRenamer::SETTINGS['TMDB_API']
          TMDb::Movie
        end
      end
    end

  end
end