require './api_consumer'
require './zip_manager'
require './route'
require 'active_support/time'
require 'active_support/duration'

class SnifferManager
  attr_accessor :all
  def initialize(passphrase)
    @passphrase = passphrase
    @source = 'sniffers'
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
      response = ac.create_route
      if response.code == 200
        puts 'Successful creation'
      else
        puts 'Error in creation'
      end
    end
  end

  private

  def convert_from_source(data)
    routes = data['routes']
    node_times = data['node_times']
    sequences = data['sequences']

    sequences.each do |sequence_element|
      route_id = sequence_element['route_id']
      node_time_id = sequence_element['node_time_id']
      route_element = routes.select{|r| r['route_id'] == route_id}.first
      node_time_element = node_times.select{|nt| nt['node_time_id'] == node_time_id}.first

      start_node = node_time_element ? node_time_element['start_node'] : nil
      end_node = node_time_element ? node_time_element['end_node'] : nil
      start_time = route_element ? DateTime.iso8601(route_element['time']) : nil
      end_time = node_time_element ? start_time + (node_time_element['duration_in_milliseconds'].to_i / 1000).seconds : nil
      self.all << Route.new(@passphrase, @source, start_node, end_node, start_time, end_time)
    end
    self.all
  end
end