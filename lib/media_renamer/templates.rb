module MediaRenamer

  module Templates
    extend self

    def movie_template
      @movie_template ||= Liquid::Template.parse(SETTINGS['MOVIE_TEMPLATE'])
    end

    def tv_template
      @tv_template ||= Liquid::Template.parse(SETTINGS['TV_TEMPLATE'])
    end

    def render_movie(movie:, file_params:, target_path:)
      attributes = movie.merge(file_params).merge(target_path: target_path)
      movie_template.render(attributes.stringify_keys)
    end

    def render_tv()
    end
  end

end