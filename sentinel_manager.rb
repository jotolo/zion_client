require './api_consumer'
require './zip_manager'
require './route'
class SentinelManager
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
      []
    end
  end

  def export
    self.all.each do |route|
      ac = ApiConsumer::ResourceCreator.new(@passphrase, @source, route.start_node, route.end_node, route.start_time, route.end_time)
      puts route.inspect
      response = ac.create_route
      if response.code == 200
        puts 'Successful creation'
      elsif response.code == 503
          puts 'Service Unavailable. Try again in a while'
      else
        puts 'Error in creation'
      end
    end
  end

  private

  def convert_from_source(data)
    routes = data['routes']

    routes.each do |route_element|
      start_node = route_element ? route_element['node'] : nil
      start_time = route_element ? DateTime.iso8601(route_element['time']).utc : nil
      self.all << Route.new(@passphrase, @source, start_node, nil, start_time, nil)
    end
    self.all
  end
end