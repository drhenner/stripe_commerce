class Admin::Document::ExportDocumentsController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  def index
    @export_documents = ExportDocument.order(sort_column + " " + sort_direction).
                                       paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @export_document = ExportDocument.find(params[:id])
    respond_to do |format|
      format.html
      format.xml do
          send_data @export_document.doc ,
                    :filename => "export_document_#{@export_document.id}.xml",
                    :type     => "application/xml"
      end
    end
  end

  private

    def sort_column
      ExportDocument.column_names.include?(params[:sort]) ? params[:sort] : "export_type_id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
