require './loophole_manager'
require './sniffer_manager'
require './sentinel_manager'

passphrase = 'Kans4s-i$-g01ng-by3-bye'

sentinel_manager = SentinelManager.new(passphrase)
puts 'IMPORTING SENTINELS...'
sentinel_manager.import
puts 'SENTINELS IMPORTED'
puts 'EXPORTING SENTINELS...'
sentinel_manager.export

loophole_manager = LoopholeManager.new(passphrase)
puts 'IMPORTING LOOPHOLES...'
loophole_manager.import
puts 'LOOPHOLES IMPORTED'
puts 'EXPORTING LOOPHOLES...'
loophole_manager.export

sniffer_manager = SnifferManager.new(passphrase)
puts 'IMPORTING SNIFFERS...'
sniffer_manager.import
puts 'SNIFFERS IMPORTED'
puts 'EXPORTING SNIFFERS...'
sniffer_manager.export

