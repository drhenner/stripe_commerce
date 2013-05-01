require 'chronic'
require 'csv'

module ROReReports
  class Accounting
    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time   = end_time
      @ledgers = TransactionLedger.between(start_time, end_time).all
    end

    def self.generate_csv(start_time, end_time)

      csv_string = CSV.generate do |csv|
         csv << ["Id", "Account", "Debit","Credit", 'Tax', 'State', 'Period']
         TransactionLedger.between(start_time, end_time).find_each do |ledger|
           csv << [ ledger.id,
                    ledger.transaction_account_name,
                    ledger.debit,
                    ledger.credit,
                    ledger.tax_amount,
                    ledger.tax_state_name,
                    ledger.period ]
         end
      end

      puts "'##########################{Rails.env}###########################'"

      time_now = Time.zone.now
      file = Tempfile.new("accounting_#{time_now.year}_#{time_now.month}_#{time_now.day}_#{time_now.hour}_#{time_now.strftime("%M_%S")}.csv")
      file.write(csv_string)
      save_file(file)

      file.close
      file.unlink    # deletes the temp file
      puts "'######################### THATS ALL FOLKS ###########################'"
    end

    def self.save_file(file, file_type = ExportType::MONTHLY_ACCOUNTING_ID)
      new_doc = ExportDocument.new(
                        :export_type_id => file_type,
                        :doc            => file)
      new_doc.save
      if new_doc.errors.present?
        puts '-----------------------------------'
        puts ' new_doc.errors.full_messages'
        puts new_doc.errors.full_messages
        puts '-----------------------------------'
      end
      new_doc
    end

    def revenue
      @ledgers.sum(&:revenue)
    end

    def cash
      @ledgers.sum(&:cash)
    end

    def accounts_receivable
      @ledgers.sum(&:accounts_receivable)
    end

    def accounts_payable
      @ledgers.sum(&:accounts_payable)
    end

    def start_time
      @start_time
    end

    def end_time
      @end_time
    end
  end
end
