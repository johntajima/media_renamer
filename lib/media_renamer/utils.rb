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


    # move file from source => dest (rename file)
    def move_file(source, dest, options)
      return if source == dest
      dest_path = File.dirname(dest)
      if confirmation("mv \"#{File.basename(source)}\"\n=> \"#{dest}\"", options)
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
        log.debug "Path [#{file}] contains #{dir_files.count} files...skipping"
        return
      end
      if confirmation("rmdir #{file}", options)
        FileUtils.rm_rf file, verbose: true,noop: options[:preview]
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

    def rename_file(mediafile, file, params)
      if params[:tv]
        lookup = MediaRenamer::TMDB.method(:find_tv)
        renderer = MediaRenamer::Templates.method(:render_tv)
      else
        lookup = MediaRenamer::TMDB.method(:find_movie)
        renderer = MediaRenamer::Templates.method(:render_movie)
      end
 
      results = lookup.call(mediafile.title)
      results = manual_lookup(lookup) if results.count == 0
      target_files = results.map {|show| renderer.call(show, mediafile, params) }

      chosen_file = case results.count
        when 0 then nil
        when 1 then target_files.first
        else
          choose_option(target_files)
        end

      if chosen_file
        MediaRenamer::Utils.move_file(file, chosen_file, params)
      else
        puts "No valid result found. Skipping."
      end
    end


    private

    # allow user to manually enter new tv/movie name
    def manual_lookup(lookup)
      puts "Enter movie/tv name, eg: Star Wars"
      video_name = STDIN.gets.chomp
      return if video_name.blank?
      target_files = lookup.call(video_name)
    end

    # ([1], 2, 3, 4, 5), [N]one of the above, [S]kip
    def choose_option(files)
      files = files.slice(0,5)  # just take first 5
      files.to_enum.with_index(1) do |filename, index|
        puts "[#{index}] #{File.basename(filename)}"
      end
      puts "[N] None of the above (lookup manually)"
      puts "> Pick: 1*, #{(2..files.count).to_a.join(", ")}, [N]one of the above, [S]kip: "
      value = STDIN.getch
      case value
      when '1','2','3','4','5'
        i = value.to_i
        puts "---> #{files[i]}"
        return files[i]
      when "\r", "\n"
        puts "---> #{files.first}"
        return files.first
      when "n", "N"
        # allow manual selection
      else
        log.debug "None chosen. Skipping."
        nil
      end
    end

    def confirmation(msg, options)
      return true unless options[:confirmation_required] == true
      puts "> #{msg}?\nCONFIRM? [Y/n/q]"
      value = STDIN.getch
      case value
      when 'q', "Q", "\u0003"
        puts
        abort("Quitting...")
      when 'y', "Y", "\r", "\n"
        puts
        true
      else
        log.debug "Skipping."
        false
      end
    end



    def log
      MediaRenamer.logger
    end

  end

end