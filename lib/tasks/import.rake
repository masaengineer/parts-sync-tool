namespace :import do
  desc 'CSVファイルから注文データをインポートする'
  task :filtered_data_sheet, [:csv_path] => :environment do |_task, args|
    unless args[:csv_path]
      puts "使用方法: rake import:filtered_data_sheet[path/to/csv]"
      exit 1
    end

    begin
      puts "インポートを開始します..."
      importer = FilteredDataSheetImporter.new(args[:csv_path])
      importer.import
      puts "インポートが完了しました"
    rescue StandardError => e
      puts "エラーが発生しました: #{e.message}"
      puts e.backtrace
      exit 1
    end
  end
end
