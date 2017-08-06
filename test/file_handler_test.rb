require 'test_helper'

class MediaRenamer::FileHandlerTest < ActiveSupport::TestCase

  def setup
    @file = load_file("Skyfall.2012.1080p.BluRay.x264-TiMELORDS.mkv")
    @path = File.expand_path('./../files', __FILE__)
  end

  test "#new fails if file does not exist" do
    fn = load_file("filedoesntexist.mkv")
    assert_raise MediaRenamer::InvalidFileError do
      @fh = MediaRenamer::FileHandler.new(fn)
    end
  end


  # file?

  test "#file? returns true for a valid file" do
    @fh = MediaRenamer::FileHandler.new(@file)
    assert @fh.file?
    refute @fh.dir?
  end

  test "#file? returns false for a path" do
    @fh = MediaRenamer::FileHandler.new(@path)
    refute @fh.file?
  end


  # dir?

  test "#dir? returns true for valid directory" do
    @fh = MediaRenamer::FileHandler.new(@path)
    assert @fh.dir?
    assert_equal @path, @fh.path
    refute @fh.file?
  end

  test "#dir returns false for a path" do
    @fh = MediaRenamer::FileHandler.new(@file)
    refute @fh.dir?
  end


  # path

  test "#path returns path for a given file" do
    @fh = MediaRenamer::FileHandler.new(@file)
    assert_equal File.dirname(@file), @fh.path
  end

  test "#path returns path for given directory" do
    @fh = MediaRenamer::FileHandler.new(@path)
    assert_equal @path, @fh.path
  end


  # type

  test "#type returns :video if a valid video file extension" do
    %w| .avi .mp4 .mkv .divx |.all? do |ext|
      @fh = MediaRenamer::FileHandler.new(load_file("video#{ext}"))
      assert_equal :video, @fh.type
    end
  end

  test "#type returns :subtitle if a valid subtitle file extension" do
    %w| .sub .srt .idx |.all? do |ext|
      @fh = MediaRenamer::FileHandler.new(load_file("sub#{ext}"))
      assert_equal :subtitle, @fh.type
    end
  end

  test "#type returns :unknown if not a recognized file extension" do
     @fh = MediaRenamer::FileHandler.new(load_file("textfile.info"))
     assert_equal :unknown, @fh.type
  end


end
