class Route
  attr_accessor :passphrase, :source, :start_node, :end_node, :start_time, :end_time
  def initialize(passphrase, source, start_node, end_node, start_time, end_time)
    @passphrase = passphrase
    @source = source
    @start_node = start_node
    @end_node = end_node
    @start_time = start_time
    @end_time = end_time
  end

end