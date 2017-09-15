require './api_consumer'

# Testing the API

sources = ['sentinels', 'sniffers', 'loopholes']
consumer = ApiConsumer::Route.new('Kans4s-i$-g01ng-by3-bye', sources.sample)

response = consumer.get_route

puts response.code