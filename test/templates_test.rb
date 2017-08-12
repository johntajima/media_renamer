require 'test_helper'

class TemplatesTest < ActiveSupport::TestCase

  def setup
  end

  test "#render_movie renders liquid template of movie" do
    movie = {
      :title         => "Wonder Woman", 
      :year          => "2017", 
      :thumbnail_url => "http://image.tmdb.org/t/p/160w/imekS7f1OuHyUP2LAiTEM0zBzUz.jpg", 
      :popularity    => 12.331853
    }

    p MediaRenamer::Templates.render_movie(movie, {})
  end


end
