namespace :songs do
  desc "Import MP3 files from a directory with size limit"
  task :import, [:directory, :max_size_mb] => :environment do |t, args|
    directory = args[:directory]
    max_size = (args[:max_size_mb] || 750).to_i * 1024 * 1024 # Converti en bytes
    
    unless directory && Dir.exist?(directory)
      puts "Usage: rake songs:import[/path/to/mp3s,750]"
      exit
    end
    
    mp3_files = Dir.glob(File.join(directory, "*.mp3"))
    total = mp3_files.count
    
    puts "Found #{total} MP3 files"
    puts "Max size: #{max_size / 1024 / 1024}MB"
    puts "Starting import..."
    
    imported = 0
    errors = 0
    total_size = 0
    
    mp3_files.each_with_index do |file_path, index|
      file_size = File.size(file_path)
      
      # Vérifie si on dépasse la limite
      if total_size + file_size > max_size
        puts "\n⚠️  Size limit reached! (#{total_size / 1024 / 1024}MB)"
        puts "Imported #{imported} files before hitting limit"
        break
      end
      
      begin
        filename = File.basename(file_path)
        title = File.basename(file_path, ".mp3").gsub(/[-_]/, ' ').titleize
        
        if Song.exists?(filename: filename)
          puts "[#{index + 1}/#{total}] ⏭️  Skipped: #{filename}"
          next
        end
        
        song = Song.new(title: title, filename: filename)
        song.audio_file.attach(
          io: File.open(file_path),
          filename: filename,
          content_type: 'audio/mpeg'
        )

        if song.save
          total_size += file_size
          imported += 1
          puts "[#{index + 1}/#{total}] ✅ #{title} (#{file_size / 1024 / 1024}MB) - Total: #{total_size / 1024 / 1024}MB"
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
    puts "✅ Imported: #{imported} files"
    puts "📊 Total size: #{total_size / 1024 / 1024}MB"
    puts "❌ Errors: #{errors}"
  end
end