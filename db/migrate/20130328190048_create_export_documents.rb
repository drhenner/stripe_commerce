class CreateExportDocuments < ActiveRecord::Migration
  def change
    create_table :export_documents do |t|
      t.references :export_type
      t.text :info
      t.has_attached_file :doc

      t.timestamps
    end
    add_index :export_documents, :export_type_id
  end
end
