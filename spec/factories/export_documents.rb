# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :export_document do
    export_type { ExportType.first }
    info        "This is a great document requested by the account department."
  end
end
