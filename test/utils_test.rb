require 'test_helper'

class MediaRenamer::UtilsTest < ActiveSupport::TestCase

  SAMPLE_MOVIES = {
    "countdown.to.zero.2010.xvid-submerge.avi"    => "Countdown To Zero",
    "DrJn.2010.BRRip_mediafiremoviez.com.mkv"     => "Drjn",
    "Nim's.Island[2008]DvDrip-aXXo.avi"           => "Nim's Island",
    "Invictus.DVDSCR.xViD-xSCR.CD1.avi"           => "Invictus",
    "20000 Leagues Under The Sea.avi"             => "20000 Leagues Under The Sea",
    "Adoration 2008 DvdRip ExtraScene RG.avi"     => "Adoration",
    "America.2009.STV.DVDRip.XviD-ViSiON.avi"     => "America",
    "Balls of Fury[2007]DvDrip[Eng]-FXG.avi"      => "Balls Of Fury",
    "Defiance DvDSCR[2009] ( 10rating ).avi"      => "Defiance",
    "Einstein.And.Eddington.2008.DVDRip.XviD.avi" => "Einstein And Eddington",
    "ENEMY_OF_THE_STATE..DVDrip(vice).avi"        => "Enemy Of The State"
  }

  def setup
  end

  test "#title_from_file returns sanitized title based on filename" do
    SAMPLE_MOVIES.each_pair do |name, title|
      result = MediaRenamer::Utils.title_from_file(name)
      assert_equal result, title
    end
  end

  test "#year_from_file returns year of movie from filename" do
    title = "Balls of Fury[2007]DvDrip[Eng]-FXG.avi"
    assert_equal 2007, MediaRenamer::Utils.year_from_file(title)

    title = "Star War [1976].mkv"
    assert_equal 1976, MediaRenamer::Utils.year_from_file(title)

    title = "Interstellar (2014) [1080p].mkv"
    assert_equal 2014, MediaRenamer::Utils.year_from_file(title)

    title = "2012 (2007) [1080p].mkv"
    assert_equal 2007, MediaRenamer::Utils.year_from_file(title)

    title = "1492: Conquest of Paradise (1999) [1080p].mkv"
    assert_equal 1999, MediaRenamer::Utils.year_from_file(title)

    title = "2012 [1080p].mkv"
    assert_equal nil, MediaRenamer::Utils.year_from_file(title)
  end



end
