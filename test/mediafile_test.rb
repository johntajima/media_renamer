require 'test_helper'

class MediaRenamer::MediafileTest < ActiveSupport::TestCase

  def setup
    @file = load_file("Skyfall.2012.1080p.BluRay.x264-TiMELORDS.mkv")
    @path = File.expand_path('./../files', __FILE__)
  end

  test "#create creates a mediafile object for a file" do
    @media = MediaRenamer::Mediafile.new(@file)
    assert !@media.directory?
    assert @media.file?
    assert_equal "Skyfall.2012.1080p.BluRay.x264-TiMELORDS.mkv", @media.filename
    assert_equal File.expand_path('./../files',__FILE__), @media.path
    assert_equal ".mkv", @media.ext
    assert @media.exists?
    assert_equal :video, @media.type
  end

  test "#create creates a mediafile object for a directory" do
    @media = MediaRenamer::Mediafile.new(@path)
    assert @media.directory?
    assert !@media.file?
    assert_equal File.expand_path('./../files',__FILE__), @media.path
    assert_equal "", @media.ext
    assert @media.exists?
    assert_equal :directory, @media.type
  end

  test "#create a mediafile for file that doesn't exist" do
    @file = load_file("not-valid-file.avi")
    @media = MediaRenamer::Mediafile.new(@file)
    assert_equal :video, @media.type
    assert !@media.exists?
    assert !@media.file?
    assert !@media.directory?
    assert !@media.exists?
    assert_equal "not-valid-file.avi", @media.filename
    assert_equal File.expand_path('./../files',__FILE__), @media.path
    assert_equal ".avi", @media.ext
  end


  # type

  test "#type returns :video for all video file extensions" do
    %w| .avi .mp4 .mkv .divx |.all? do |ext|
      @media = MediaRenamer::Mediafile.new(load_file("video#{ext}"))
      assert_equal :video, @media.type
    end
  end

  test "#type returns :subtitle for all subtitle file extensions" do
    %w| .sub .srt .idx |.all? do |ext|
      @media = MediaRenamer::Mediafile.new(load_file("video#{ext}"))
      assert_equal :subtitle, @media.type
    end
  end

  test "#type returns :unknown for all other file extensions" do
    %w| .txt .info |.all? do |ext|
      @media = MediaRenamer::Mediafile.new(load_file("video#{ext}"))
      assert_equal :unknown, @media.type
    end
  end

  test "#type returns :directory for directory" do
    @media = MediaRenamer::Mediafile.new(load_file(""))
    assert_equal :directory, @media.type
  end


  # mediainfo

  test "#to_hash returns hash of media info for valid file" do
    @media = MediaRenamer::Mediafile.new(load_file("RARBG.mp4"))
    p @media.to_hash
  end

  test "#to_hash returns empty hash if file is not valid or a movie" do
    @media = MediaRenamer::Mediafile.new(load_file("sample_files.txt"))
    assert_equal Hash.new, @media.to_hash
  end

end
