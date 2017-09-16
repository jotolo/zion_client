require './api_consumer'
require './zip_manager'
require './route'
class Sentinel
  attr_accessor :all
  def initialize(passphrase)
    @passphrase = passphrase
    @source = 'sentinels'
    @all = []
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
    #exporter = ApiConsumer::ResourceCreator.new()
  end

  private

  def convert_from_source(data)
    routes = data['routes']

    routes.each do |route_element|
      start_node = route_element ? route_element['node'] : nil
      start_time = route_element ? DateTime.iso8601(route_element['time']) : nil
      self.all << Route.new(@passphrase, @source, start_node, nil, start_time, nil)
    end
  end
end