module MediaRenamer

  module Templates
    extend self

    def movie_template
      @movie_template ||= Liquid::Template.parse(SETTINGS['MOVIE_TEMPLATE'], error_mode: :strict)
    end

    def tv_template
      @tv_template ||= Liquid::Template.parse(SETTINGS['TV_TEMPLATE'],error_mode: :strict)
    end

    def render_movie(movie, mediafile, options = {})
      attributes = {
        title: movie.title,
        year: movie.year,
        video_format: mediafile.video_format,
        video_codec: mediafile.video_codec,
        audio_codec: mediafile.audio_codec,
        tag: mediafile.tag,
        ext: mediafile.ext,
        target_path: options[:target_path]
      }
      movie_template.render(attributes.stringify_keys)
    end

    def render_tv()
    end
  end

end