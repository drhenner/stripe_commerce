class ThreePLSerializer
  require 'builder'

  #attr_accessor :attributes, :order_ids, :order_item_ids

  def initialize()
  end

  def build_xml(order_ids) ##  Moulton only supports one order at a time.
    builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
      Order.find_each(order_ids).each do |order|
        order_xml(xml, order)
      end
    end
    builder.to_xml
  end

  def order_xml(xml, order)
    xml.order(:version => "2.1") {
      order_header_xml(xml, order)
      order_detail_xml(xml, order)
      order_customer_info_xml(xml, order)
    }
  end

  def order_header_xml(xml, order)
    xml.OrderHeader {
      xml.GROUP_CODE( 'XXXX' )
      xml.DATE_ORD("#{order.display_completed_at(:moulton_date)}")
      xml.CL_NO('XX')
      xml.CSOURCE('TESTING')
      xml.CMEDIA('XXXX')
      xml.CREDCD('4111111111111111')
      xml.EXPDT('0415')
      xml.PROJECT('proj1')
      xml.AMTPAY()
      xml.MICRCODE()
      xml.PAY_TYPE('C')
      xml.NUM_PYMNTS(1)
      xml.EMAIL("#{order.email}")
      xml.COMPANY()
      xml.F_NAME("#{order.ship_address.try(:first_name)}")
      xml.L_NAME("#{order.ship_address.try(:last_name)}")
      xml.ADDR_1("#{order.ship_address.try(:address1)}")
      xml.ADDR_2("#{order.ship_address.try(:address2)}")
      xml.CITY("#{order.ship_address.try(:city)}")
      xml.ST("#{order.ship_address.try(:display_state_name)}")
      xml.ZIP("#{order.ship_address.try(:zip_code)}")
      xml.PHONE('')
      xml.PHONE_EXT('')
      xml.COUNTRY_CODE("#{order.ship_address.try(:country_code)}")
      xml.OPT_IN()
      xml.OPT_OUT()
      xml.ADJ_CODE()
      xml.AMT_DISC()
      xml.PURCHASE_ORDER()
      xml.BILL_TO_COMPANY()
      xml.BILL_TO_F_NAME("#{order.bill_address.try(:first_name)}")
      xml.BILL_TO_L_NAME("#{order.bill_address.try(:last_name)}")
      xml.BILL_TO_ADDR_1("#{order.bill_address.try(:address1)}")
      xml.BILL_TO_ADDR_2("#{order.bill_address.try(:address2)}")
      xml.BILL_TO_CITY("#{order.bill_address.try(:city)}")
      xml.BILL_TO_ST("#{order.bill_address.try(:display_state_name)}")
      xml.BILL_TO_ZIP("#{order.bill_address.try(:zip_code)}")
      xml.BILL_TO_COUNTRY_CODE("#{order.bill_address.try(:country_code)}")
      xml.UNIQUE-ID("#{order.number}-001")
      xml.HAS_FINANCIAL('Y')
      xml.HAS_GIFT_REC('')
      xml.HAS_CSTM('')
    }
  end
  def order_detail_xml(xml, order)
    xml.OrderDetail {
      xml.LineItem() {
        xml.QUANTITY_ORDERED(1)
        xml.OFFER_CODE('XXXXXX')
      }
    }
  end

  def order_customer_info_xml(xml, order)
    xml.CSTM {
      xml.CUSTOMER-NUMBER(order.user.number)
    }
  end
end
