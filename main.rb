require './api_consumer'
require './zip_manager'

# Testing the API

sources = ['sentinels', 'sniffers', 'loopholes']

consumer = ApiConsumer::Resource.new('Kans4s-i$-g01ng-by3-bye', sources[2])

response = consumer.get_resource


puts response.code

# decompressing zip
data = ZipManager.decompress_zip(response.body)

puts data.inspect



