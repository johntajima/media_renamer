module MediaRenamer

  module Templates
    extend self

    def movie_template
      @movie_template ||= Liquid::Template.parse(SETTINGS['MOVIE_TEMPLATE'])
    end

    def tv_template
      @tv_template ||= Liquid::Template.parse(SETTINGS['TV_TEMPLATE'])
    end
  end

end