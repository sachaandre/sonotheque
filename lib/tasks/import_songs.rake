namespace :songs do
  desc "Import MP3 files from a directory"
  task :import, [:directory] => :environment do |t, args|
    directory = args[:directory]
    
    unless directory && Dir.exist?(directory)
      puts "Usage: rake songs:import[/path/to/mp3s]"
      exit
    end
    
    mp3_files = Dir.glob(File.join(directory, "*.mp3"))
    total = mp3_files.count
    
    puts "Found #{total} MP3 files"
    puts "Starting import..."
    
    imported = 0
    errors = 0
    
    mp3_files.each_with_index do |file_path, index|
      begin
        filename = File.basename(file_path)
        title = File.basename(file_path, ".mp3").titleize
        
        # Vérifie si le fichier existe déjà
        if Song.exists?(filename: filename)
          puts "[#{index + 1}/#{total}] ⏭️  Skipped: #{filename} (already exists)"
          next
        end
        
        song = Song.new(title: title, filename: filename)
        song.audio_file.attach(
          io: File.open(file_path),
          filename: filename,
          content_type: 'audio/mpeg'
        )
        
        if song.save
          imported += 1
          puts "[#{index + 1}/#{total}] ✅ Imported: #{title}"
        else
          errors += 1
          puts "[#{index + 1}/#{total}] ❌ Error: #{song.errors.full_messages.join(', ')}"
        end
        
      rescue => e
        errors += 1
        puts "[#{index + 1}/#{total}] ❌ Exception: #{e.message}"
      end
    end
    
    puts "\n=== Import Complete ==="
    puts "✅ Imported: #{imported}"
    puts "❌ Errors: #{errors}"
    puts "⏭️  Skipped: #{total - imported - errors}"
  end
end