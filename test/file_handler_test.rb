require 'test_helper'

class MediaRenamer::FileHandlerTest < ActiveSupport::TestCase

  def setup
  end

  test "file? returns true for a valid file" do
    @f = MediaRenamer::FileHander.new("./file_handler_test.rb")
    p @f.file?
  end


end
