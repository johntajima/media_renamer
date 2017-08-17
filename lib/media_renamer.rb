$LOAD_PATH.unshift File.dirname(__FILE__)

require 'yaml'
require 'liquid'
require 'logger'
require 'active_support'
require 'tmdb-api'
require "media_renamer/version"
require "media_renamer/templates"
require "media_renamer/tmdb"
require "media_renamer/movie"
require "media_renamer/tv"
require 'media_renamer/file_parser'
require "media_renamer/mediafile"
require "media_renamer/utils"

module MediaRenamer

  USER_CONFIG    = File.expand_path("~/.media_renamer.yml")
  DEFAULT_CONFIG = File.join(File.dirname(__FILE__), "../config/media_renamer.yml")
  SETTINGS ||= begin
    default_config = YAML.load(File.open(DEFAULT_CONFIG).read)
    custom_config  = File.exist?(USER_CONFIG) ? YAML.load(File.open(USER_CONFIG).read) : {}
    default_config.merge(custom_config)
  end

  TMDb.api_key = MediaRenamer::SETTINGS['TMDB_API']

  extend self

  def logger
    @logger ||= begin
      logger = Logger.new(STDOUT)
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.strftime("%H:%M:%S")}: #{msg}\n"
      end
      logger
    end
  end

  class InvalidFileError < StandardError; end

end
