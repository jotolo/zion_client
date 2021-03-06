require 'rubygems'
require 'httparty'

module  ApiConsumer
  class Resource
    include HTTParty
    base_uri 'challenge.distribusion.com/the_one'

    def initialize(passphrase, source)
      @options = { query: { passphrase: passphrase, source: source } }
    end

    def get_resource
      self.class.get('/routes', @options)
    end
  end

  class ResourceCreator
    include HTTParty
    base_uri 'challenge.distribusion.com/the_one'

    def initialize(passphrase, source, start_node, end_node, start_time, end_time)
      @options = { :body => {passphrase: passphrase, source: source, start_node: start_node, end_node: end_node, start_time: start_time, end_time: end_time} }
    end

    def create_route
      self.class.post('/routes', @options)
    end
  end
end