class DataImportsController < ApplicationController
  def import_filtered_data_sheet
    importer = FilteredDataSheetImporter.new(params[:file].path)
    importer.import
    flash[:notice] = "Import completed successfully."
    redirect_to some_path
  rescue FilteredDataSheetImporter::MissingSkusError => e
    flash[:alert] = e.message
    redirect_to some_path
  end
end
