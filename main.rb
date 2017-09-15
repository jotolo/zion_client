require './api_consumer'
require './zip_manager'

# Testing the API

sources = ['sentinels', 'sniffers', 'loopholes']
consumer = ApiConsumer::Route.new('Kans4s-i$-g01ng-by3-bye', sources[2])

response = consumer.get_route

puts response.code

# decompressing zip
ZipManager.decompress_zip(response.body)

