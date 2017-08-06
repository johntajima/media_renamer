module MediaRenamer

  class Renamer

    attr_reader :file


    def initialize(file_or_path, options = {})
      @file = file_or_path
      @options = options
    end

    def process!
      log.info("\n\nStarting...")

      

      # check if file is path or a file
      # if file,
        # process single file
      # if path,
        # get all files, and process each file
      # if neither, 
        # display error message and quit

      log.info("Done.\n\n")
    end


    def log
      MediaRenamer.logger
    end
  end

end