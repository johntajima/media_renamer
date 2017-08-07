require 'test_helper'

class MediaRenamer::TitleProcessorTest < ActiveSupport::TestCase

  def setup
    @movies = File.readlines(load_file("sample_files.txt")).map(&:strip)
  end

  test "#movie_title returns sanitized title based on filename" do
    
    @movies.each do |filename|
      puts filename
      puts MediaRenamer::TitleProcessor.movie_title(filename)
    end
  end


end
