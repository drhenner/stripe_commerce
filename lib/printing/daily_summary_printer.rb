require 'printing/main_printer'
module DailySummaryPrinter
  include MainPrinter
  include ActionView::Helpers::NumberHelper

    # pdf = DailySummaryPrinter.print_form(start_time, end_time)
    # pdf.render_file('prawn.pdf')
    # pdf_file = TempFile.open('prawn.pdf')

    # export_doc = ExportDocument.new()
    # export_doc.doc = pdf_file
    # export_doc.info = "Summary for #{start_time}  to  #{end_time}"
    # export_doc.save
    def print_form(start_time = (Time.zone.now - 1.day).beginning_of_day, end_time = (Time.zone.now - 1.day).end_of_day)
      document = Prawn::Document.new do |pdf|
        print_summary_form(pdf, start_time, end_time)
        pdf#.render#_file card_name
      end # end of Prawn::Document.generate
      return document
    end # end of print_form method

    def print_summary_form( pdf, start_time, end_time)
      pdf.text "Daily Report: #{I18n.localize(start_time, :format => :us_time)} to #{I18n.localize(end_time, :format => :us_time)}"
      pdf.text " "
      order_count = Order.completed_between(start_time, end_time).count
      pdf.text "# of Orders: #{order_count}"
      pdf.text " "
      Variant.includes(:product).active.find_each do |variant|
        item_count = OrderItem.includes(:order).
                  where('order_items.variant_id = ?', variant.id).
                  where('orders.completed_at <= ?',   end_time).
                  where('orders.completed_at >= ?',   start_time).count
        pdf.text "#{variant.product_name}: SKU : #{variant.sku}"
        pdf.text "Number Sold: #{item_count}"
        pdf.text "Gross Revenue: #{number_to_currency(variant.price * item_count.to_f)}"
        pdf.text " "
      end
      pdf.start_new_page()
      print_order_items( pdf, start_time, end_time)
    end
    def print_order_items( pdf, start_time, end_time)
      count = 0
      Order.includes({:order_items => {:variant => :product} }).where('orders.completed_at <= ?',   end_time).
            where('orders.completed_at >= ?',   start_time).find_each do |order|
        pdf.text "Order: #{order.number}"
        order.order_items.each_with_index do |item, i|
          pdf.text "item #{i+1}: #{item.variant.product_name} "
        end
        pdf.text " "
        count += 1
        pdf.start_new_page() if count > 14
      end
    end
end
