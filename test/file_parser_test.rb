require 'test_helper'

class MediaRenamer::FileParserTest < ActiveSupport::TestCase

  MOVIES = [
    {
      file: "countdown.to.zero.2010.xvid-submerge.avi",
      title: "Countdown To Zero",
      year: "2010",
      tag: nil
    },
    {
      file: "Nim's.Island[2008]DvDrip-aXXo.avi",
      title: "Nim's Island",
      year: "2008",
      tag:  nil
    },
    {
      file: "Kingdom of Heaven 2005 DC Roadshow (1080p Bluray x265 HEVC 10bit AAC 5.1 Tigole)",
      title: "Kingdom Of Heaven",
      year: "2005",
      tag: "Directors Cut"
    },
    {
      file: "Defiance DvDSCR[2009] ( 10rating ).avi",
      title: "Defiance",
      year: "2009",
      tag: nil
    },
    {
      file: "Adoration 2008 DvdRip ExtraScene RG.avi",
      title: "Adoration",
      year: "2008",
      tag: nil
    }
  ]

  def setup
  end

  test "#extract_tags returns back expected tag" do
    f = "Kingdom of Heaven 2005 DC Roadshow (1080p Bluray x265 HEVC 10bit AAC 5.1 Tigole)"
    @parser = MediaRenamer::FileParser.new(f)
    assert_equal "Directors Cut", @parser.tag

    f = "Kingdom of Heaven 2005 Director's Cut (1080p Bluray x265 HEVC 10bit AAC 5.1 Tigole)"
    @parser = MediaRenamer::FileParser.new(f)
    assert_equal "Directors Cut", @parser.tag

    f = "Kingdom of Heaven 2005 (extended version)"
    @parser = MediaRenamer::FileParser.new(f)
    assert_equal "Extended", @parser.tag

    f = "Kingdom of Heaven 2005 unrated dc (1080p)"
    @parser = MediaRenamer::FileParser.new(f)
    assert_equal "Unrated Directors Cut", @parser.tag
  end

  test "#extract_tags does not return tag if tag words are within a word" do
    f = "the dcators"
    @parser = MediaRenamer::FileParser.new(f)
    assert_nil @parser.tag
  end

  test "#extract_year returns back first valid year found in filename" do
    MOVIES.each do |movie|
      parser = MediaRenamer::FileParser.new(movie[:file])
      assert_equal movie[:title], parser.title
      assert_equal movie[:year], parser.year
      assert_equal movie[:tag], parser.tag
    end
  end

end