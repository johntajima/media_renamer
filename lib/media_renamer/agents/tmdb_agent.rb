module MediaRenamer
  module Agents


    module TmdbAgent

      extend self

      def search(query)
        tmdb.search(query)
      end

      def tmdb
        @tmdb ||= begin
          TMDb.api_key = MediaRenamer::SETTINGS['TMDB_API']
          TMDb::Movie
        end
      end
    end

  end
end