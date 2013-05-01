require 'net/http'
require 'uri'

namespace :threepl do
  task :send_new_order => :environment do
    #
    #url= URI.parse('https://qcmoultonordervision.com/Ws/ORDAPI.asmx/OrderNewAPITrackable')
    #url= URI.parse('https://qcmoultonordervision.com/ws/InventoryStatus.asmx/Inventory')
    #url= URI.parse('https://www.qcmoultonordervision.com/ws/OrderStatusWebService.asmx/OrderStatus')
    #url= URI.parse('https://www.qcmoultonordervision.com/ws/OrderStatusWebService.asmx/OrderStatus')
    request = Net::HTTP::Post.new(url.path)
    request.add_field 'Content-Type', 'application/xml'

    serializer = ThreePLSerializer.new(order_ids)
    request.body = xml_contents = serializer.build_xml
    response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
  end
end
