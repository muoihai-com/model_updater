module ModelUpdater
  class FileLib
    class << self
      def instance
        @instance ||= new
      end

      def read path
        instance.create_file_if_not_exists(path)
      end

      def write path, content
        instance.write_file_if_not_exists path, content
      end
    end

    def write_file_if_not_exists path, content
      if File.exist?(path)
        File.write(path, content)
      else
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, "w") do |file|
          file.puts content
        end
      end
    end

    def create_file_if_not_exists path
      if File.exist?(path)
        File.read(path)
      else
        yaml = YAML.dump([])
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, "w") do |file|
          file.puts yaml
        end

        yaml
      end
    end
  end
end
