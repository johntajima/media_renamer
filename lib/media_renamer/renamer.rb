module MediaRenamer

  class Renamer

    attr_reader :file


    def initialize(file_or_path, options = {})
      @file = File.expand_path(file_or_path)
      @options = options
    end

    def process!
      log.info("\n\nStarting...")

      # check if file is path or a file
      raise InvalidFileError, "File or path '#{@file}' does not exist." unless File.exists?(@file)

      if File.file?(@file)
        # process single file
      elsif File.directory?(@file)
        # get all files, and process each file
      else
        raise InvalidFileError, "Unknown file '#{@file}'"
      end
      log.info("Done.\n\n")

    rescue StandardError => e
      log.error("[Error] #{e.message}")
      raise
    end

    def process
      process!
    end


    def log
      MediaRenamer.logger
    end
  end

end