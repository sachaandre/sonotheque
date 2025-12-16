namespace :songs do
  desc "Import MP3 files from storage directory"
  task :import, [:directory] => :environment do |t, args|
    directory = args[:directory] || '/home/debian/sonotheque/storage'
    
    unless Dir.exist?(directory)
      puts "Usage: rake songs:import[/path/to/mp3s]"
      exit
    end
    
    mp3_files = Dir.glob(File.join(directory, "**/*.mp3"))
    total = mp3_files.count
    
    puts "Found #{total} MP3 files"
    puts "Starting import..."
    
    imported = 0
    errors = 0
    
    mp3_files.each_with_index do |file_path, index|
      begin
        filename = File.basename(file_path)
        title = File.basename(file_path, ".mp3").gsub(/[-_]/, ' ').titleize
        
        if Song.exists?(filename: filename)
          puts "[#{index + 1}/#{total}] ⏭️  Skipped: #{filename}"
          next
        end
        
        song = Song.create!(title: title, filename: filename)
        
        song.audio_file.attach(
          io: File.open(file_path),
          filename: filename,
          content_type: 'audio/mpeg'
        )
        
        imported += 1
        puts "[#{index + 1}/#{total}] ✅ #{title}"
        
      rescue => e
        errors += 1
        puts "[#{index + 1}/#{total}] ❌ Error: #{e.message}"
      end
    end
    
    puts "\n=== Import Complete ==="
    puts "✅ Imported: #{imported} files"
    puts "❌ Errors: #{errors}"
  end
end