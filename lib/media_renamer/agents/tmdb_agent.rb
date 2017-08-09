module MediaRenamer
  module Agents


    module TmdbAgent

      extend self

      TMBD_IMAGE_PATH = "http://image.tmdb.org/t/p/"
      THUMBNAIL_PATH  = "160w"


      def search(query, options = {})
        results = tmdb.search(query, options)
        sleep(0.5)
        sanitize_results(results)
      end

      def sanitize_results(results)
        results.map do |entry|
          year = entry.release_date.present? ? Date.parse(entry.release_date).year : nil
          {
            title: entry.title,
            year: year,
            id: entry.id,
            popularity: entry.popularity,
            thumbnail: [TMBD_IMAGE_PATH, THUMBNAIL_PATH, entry.poster_path].compact.join
          }
        end
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