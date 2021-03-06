require './api_consumer'
require './zip_manager'
require './route'
require 'date'
require 'byebug'
class LoopholeManager
  attr_accessor :all
  def initialize(passphrase)
    @passphrase = passphrase
    @source = 'loopholes'
    @all = []
  end

  def import
    consumer = ApiConsumer::Resource.new(@passphrase, @source)
    response = consumer.get_resource

    if response.code == 200
      data = ZipManager.decompress_zip_memory(response.body)
      convert_from_source(data)
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
      else
        puts 'Error in creation'
      end
    end
    self.all
  end

  private

  def convert_from_source(data)
    routes = data['routes']
    node_pairs = data['node_pairs']

    routes.each do |route_element|
      node_object = node_pairs.select{|np| np['id'].to_i == route_element['node_pair_id'].to_i}.first
      start_node = node_object ? node_object['start_node'] : nil
      end_node = node_object ? node_object['end_node'] : nil
      start_time = DateTime.iso8601(route_element['start_time'])
      end_time = DateTime.iso8601(route_element['end_time'])
      self.all << Route.new(@passphrase, @source, start_node, end_node, start_time, end_time)
    end
  end
end