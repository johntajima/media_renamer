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
    assert_equal :unknown, @media.type
    assert !@media.exists?
    assert !@media.file?
    assert !@media.directory?
  end


  # mediainfo

  test "#attributes returns hash if file is not valid or a movie" do
    @media = MediaRenamer::Mediafile.new(load_file("sample_files.txt"))
    expected = { type: :unknown }
    assert_equal expected, @media.to_hash
  end

  test "#attributes returns hash of type :directory if file is a path" do
    @media = MediaRenamer::Mediafile.new(load_file("./"))
    expected = { type: :directory }
    assert_equal expected, @media.to_hash
  end


end
