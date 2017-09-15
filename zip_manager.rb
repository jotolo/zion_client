require 'zipruby'
require 'fileutils'
class ZipManager

  def self.decompress_zip(buffer)
    Zip::Archive.open_buffer(buffer) do |archive|
      archive.each do |zip_file|
        if zip_file.directory?
          FileUtils.mkdir_p(zip_file.name)
        else
          dirname = File.dirname(zip_file.name)
          FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
          open(zip_file.name, 'wb') do |f|
            f << zip_file.read
          end
        end
      end
    end
  end
end