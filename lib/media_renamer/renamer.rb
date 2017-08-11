module MediaRenamer

  class Renamer

    DELETABLE_PATH = "/.deleteable/"

    def initialize(fp, options = {})
      parent_path = File.pathname(fp)
      @target_path = options.fetch(:target, )
    end

#    extend self

    def process(file_or_path, options = {})
      file_or_path = File.expand_path(file_or_path)

      process_entry(file_or_path)
      return unless File.exist?(file_or_path)

      if File.directory?(file_or_path)
        # dir handler
      else
        # file handler
      end
      log.debug("Done #{file_or_path}")
    end

    def log
      MediaRenamer.logger
    end

    def file_handler(file)
    end

    def dir_handler(dir)
    end

    # if -d option passed, delete file,
    # otherwise move to <target>/.deletable/ path
    def mark_as_deleted(file)
    end

  end
end

#     attr_reader :file


#     def initialize(file_or_path, options = {})
#       @file = File.expand_path(file_or_path)
#       @options = options
#     end

#     def process!
#       log.info("\n\nStarting...")

#       # quit if file doesn't exist
#       # if file is a directory
#         # dir glob all files in that directory
#         # for each file
#           # process!
#         # if dir is now empty,
#           # mark as deletable
#         # else
#           # quit
#       # if file is file
#         # case file type
#           # when tv
#             # process tv files
#           # when movie
#             # process movie file
#           # when audio
#             # do something
#           # else
#             # mark as deleteable
#       # 
#             # 
#         # quit if not empty
#       # mark as deleteable if file is not 
#       # if file is directory, 
#         # check if directory is empty, if so move to deleteable
#       # if file is 

#       # check if file is path or a file
#       raise InvalidFileError, "File or path '#{@file}' does not exist." unless File.exists?(@file)

#       if File.file?(@file)
#         # process single file
#       elsif File.directory?(@file)
#         # get all files, and process each file
#       else
#         raise InvalidFileError, "Unknown file '#{@file}'"
#       end
#       log.info("Done.\n\n")

#     rescue StandardError => e
#       log.error("[Error] #{e.message}")
#       raise
#     end

#     def process
#       process!
#     end


#     def log
#       MediaRenamer.logger
#     end
#   end

# end

