# == Schema Information
#
# Table name: export_documents
#
#  id               :integer          not null, primary key
#  export_type_id   :integer          not null
#  info             :text
#  doc_file_name    :string(255)
#  doc_content_type :string(255)
#  doc_file_size    :integer
#  doc_updated_at   :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ExportDocument < ActiveRecord::Base
  belongs_to :export_type
  attr_accessible :info, :export_type_id, :doc

  validates :export_type_id,        :presence => true

  has_attached_file :doc, {
      :storage        => :s3,
      #:styles        => { :preview => { :geometry => '135',  :format => :png } },
      :s3_protocol    => Settings.paperclip.s3_protocol ,
      #:s3_headers    => { 'Content-Disposition' => 'attachment' },
      :s3_credentials => Settings.paperclip.s3_credentials.to_hash,
      :path           => ":attachment/:style/:id-:basename.:extension",
      :bucket         => Settings.paperclip.bucket
  }

  def export_type_name
    Rails.cache.fetch("export_type-#{export_type_id}-name", :expires_in => 23.hours) do
      export_type.name
    end
  end
end
