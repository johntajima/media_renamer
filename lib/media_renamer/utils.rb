module MediaRenamer

  require 'fileutils'
  module Utils

    DELETEABLE_PATH = "/_deleteable"

    extend self

    # given a width and height, returns back video format
    # 8k      7680x4320
    # 4k      4096x
    # 2k      2048x
    # 1080p   1920x1080
    # 720p    1280x720
    # 480p    640x480
    # 360p    480x360
    def video_format(width, height)
      return unless width && width
      if width >= 7600 || height >= 4300
        "8K"
      elsif width >= 3800 || height > 2100
        "4K"
      elsif width >= 1900 || height >= 1000
        "1080p"
      elsif width >= 1200 || height >= 700
        "720p"
      elsif width >= 640 || height >= 480
        "480p"
      elsif width >= 480 || height >= 360
        "360p"
      else
        "SD"
      end
    end

    # hevc, h264, mpeg4, msmpeg4, vc1
    def video_codec(codec)
      case codec
      when "h264"
        'H264'
      when "mpeg4"
        'MP4'
      when 'hevc', 'h265'
        "HEVC"
      else
        nil
      end
    end

    # "aac", "ac3", "dca", "mp3", "truehd", "wmav2"
    def audio_codec(codec, channels = nil)
      text = case codec
        when 'aac', 'ac3', 'mp3', 'dca'
          codec.upcase
        else
          'OTH'
        end
      channels ? "#{text} #{channels}ch" : text
    end


    # move file from source => dest
    def move_file(source, dest, options)
      return if source == dest
      dest_path = File.dirname(dest)
      if confirmation("mv #{source}\n => #{dest}", options)
        if !File.directory?(dest_path)
          FileUtils.mkdir_p dest_path, verbose: true, noop: options[:preview]
        end
        FileUtils.mv source, dest, verbose: true, noop: options[:preview]
      end
    end

    def delete_dir(file, options)
      return unless File.exist?(file) 

      dir_files = Dir.entries(file).reject {|x| x.start_with?('.')}
      if dir_files.count > 0
        p "dir #{file} not empty #{dir_files}"
        return
      end
      if confirmation("rmdir #{file}", options)
        FileUtils.rm_rf file, verbose: true, noop: options[:preview]
      end
    end

    def delete_file(file, options)
      return unless File.exist?(file) 
      if options[:delete_files]
        if confirmation("rm #{file}", options)
          FileUtils.rm_f file, verbose: true, noop: options[:preview]
        end
      else
        move_file(file, deleteable_file(file, options), options)
      end
    end

    def deleteable_file(file, options)
      path = file.split(options[:orig_path])
      File.join(options[:orig_path], DELETEABLE_PATH, path)
    end

    def confirmation(msg, options)
      return true unless options[:confirmation_required] == true
      puts "[CONFIRM] #{msg}? [Y/n/q]"
      value = STDIN.getch
      case value
      when 'q', "Q", "\u0003"
        puts
        exit
      when 'y', "Y", "\r", "\n"
        puts
        true
      else
        puts "Skipping."
        false
      end
    end

  end

end