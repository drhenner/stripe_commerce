require 'net/ftp'
require 'simple_xlsx'

namespace :reports do
  namespace :daily do
    # rake reports:daily:summary
    task :summary => :environment do
      include ActionView::Helpers::NumberHelper
      start_time  = (Time.zone.now - 1.day).beginning_of_day
      end_time    = start_time.end_of_day

      order_count         = Order.finished.completed_between(start_time, end_time).count
      order_item_count    = OrderItem.purchased.includes(:order).
          where('orders.completed_at <= ?',   end_time).
          where('orders.completed_at >= ?',   start_time).count
      order_gross_revenue = OrderItem.purchased.includes(:order).
          where('orders.completed_at <= ?',   end_time).
          where('orders.completed_at >= ?',   start_time).sum(:price)
file_time = Time.zone.now
      file_name = "DailySummaryReport_#{I18n.localize(file_time, :format => :file_time)}.xlsx"
      file_path_and_name = "#{Rails.root}/#{file_name}"

      serializer = SimpleXlsx::Serializer.new(file_name) do |doc|
        doc.add_sheet("DailySummaryReport_#{I18n.localize(file_time, :format => :file_time)}") do |sheet|
          sheet.add_row(["#{order_count} Orders"])
          sheet.add_row(['', 'SKU','# of Items', 'Gross Revenue'])
          sheet.add_row(["Total", '', "#{order_item_count}", "#{order_gross_revenue}"])
          Variant.includes(:product).active.find_each do |variant|
            item_count = OrderItem.includes(:order).
                      where('order_items.variant_id = ?', variant.id).
                      where('orders.completed_at <= ?',   end_time).
                      where('orders.completed_at >= ?',   start_time).count
            sheet.add_row(["#{variant.product_name}","#{variant.sku}", "#{item_count}", "#{variant.price * item_count.to_f}"])
          end

          sheet.add_row(['Orders'])
          sheet.add_row([''])
          sheet.add_row(['Order #', 'Product', 'SKU', 'Completed At', 'City', 'State'])
          Order.includes(:ship_address, {:order_items => :variant}).finished.completed_between(start_time, end_time).find_each do |order|
            order.order_items.each do |item|
              sheet.add_row([ "#{order.number}",
                              "#{item.variant.product_name}",
                              "#{item.variant.sku}",
                              "#{order.display_completed_at(:us_time)}",
                              "#{order.ship_address.try(:city)}",
                              "#{order.ship_address.try(:display_state_name)}"])
            end
          end
        end



      end

      file = File.open( file_name )
      export_doc = save_summary_doc(file, start_time, end_time)
      list = Settings.email_list.daily_report
      send_to_list(export_doc.id, list, "DailySummaryReport_#{I18n.localize(start_time, :format => :file_date)}" )
    end

    def send_to_list(export_doc_id, list, subject)
      Notifier.send_file_to_list(export_doc_id, list, subject).deliver
    end

    def save_summary_doc(file, start_time, end_time)
      export_doc = ExportDocument.new()
      export_doc.doc = file
      export_doc.export_type_id = ExportType::DAILY_SUMMARY_REPORT_ID
      export_doc.info = "Summary for #{start_time}  to  #{end_time}"
      export_doc.save
      export_doc
    end

    # rake reports:daily:pdf_summary
    task :pdf_summary => :environment do
      start_time  = (Time.zone.now - 1.day).beginning_of_day
      end_time    = start_time.end_of_day

      report = DailySummaryReport.new
      pdf = report.print_form(start_time, end_time)
      # uncomment to test locally
      # pdf.render_file('prawn.pdf')

      file = StringIO.new(pdf.render) #mimic a real upload file
      file.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
      file.original_filename = "my_report.pdf"
      file.content_type = "application/pdf"
      puts 'still good'
      save_summary_doc(file,start_time, end_time)
      if export_doc.errors.full_messages.blank?
        puts "IT WORKED!"
      else
        puts export_doc.errors.full_messages
      end
    end
  end
end
