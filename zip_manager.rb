require 'zipruby'
require 'fileutils'
require 'csv'
require 'json'
require 'byebug'

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
            f << zip_file.read.gsub(/"/,'').gsub(' ', '')
            #.read.gsub(/"/,"'")
          end
        end
      end
    end
  end

  def self.decompress_zip_memory(buffer)
    result = {}
    Zip::Archive.open_buffer(buffer) do |archive|
      archive.each do |zip_file|
        # directory or hidden files
        if zip_file.directory? || zip_file.name.split('/').last.start_with?('.')
          next
        else
          if zip_file.name.end_with?('csv')
            key_name = zip_file.name.split('/').last.split('.').first
            result[key_name] = []
            CSV.foreach(zip_file.name,:headers => :first_row) do |row|
              result[key_name] << row.to_h
            end
          elsif zip_file.name.end_with?('json')
            result.merge!(JSON.parse(zip_file.read))
          end
        end
      end
    end
    result
  end

end