module MediaRenamer
  module Agents


    module TmdbAgent

      extend self

      def search(query, options = {})
        results = tmdb.search(query, options)
        sleep(0.5)
        sanitize_results(results)
      end

      def sanitize_results(results)
        return [] if results.nil? || results.empty?
        results.map {|entry| MediaRenamer::Movie.new(entry)}
      end
      # poster path http://image.tmdb.org/t/p/<width>w/URL

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