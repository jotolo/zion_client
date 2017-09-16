require './api_consumer'
require './zip_manager'
require './route'
class Sentinel

  def initialize(passphrase)
    @passphrase = passphrase
    @source = 'sentinels'
  end

  def import
    consumer = ApiConsumer::Resource.new(@passphrase, @source)
    response = consumer.get_resource

    if response.code == 200
      data = ZipManager.decompress_zip_memory(response.body)
      result = convert_from_source(data)
      result
    else
      return nil
    end
  end

  def export
    exporter = ApiConsumer::ResourceCreator.new()
  end

  private

  def convert_from_source(data)

  end
end