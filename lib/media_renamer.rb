$LOAD_PATH.unshift File.dirname(__FILE__)

require 'yaml'
require 'tmdb-api'
require 'liquid'
require 'logger'
require 'active_support'
require "media_renamer/version"
require "media_renamer/templates"
require "media_renamer/renamer"
require "media_renamer/mediafile"
require "media_renamer/utils"
require "media_renamer/title_processor"
require "media_renamer/agents/tmdb_agent"


module MediaRenamer

  USER_CONFIG    = "~/.media_renamer.yml"
  DEFAULT_CONFIG = File.join(File.dirname(__FILE__), "../config/media_renamer.yml")
  SETTINGS ||= begin
    default_config = YAML.load(File.open(DEFAULT_CONFIG).read)
    custom_config = if File.exist?(File.expand_path(USER_CONFIG))
      YAML.load(File.open(File.expand_path(USER_CONFIG)).read)
    else
      {}
    end
    default_config.merge(custom_config)
  end

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
