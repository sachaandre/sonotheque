class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :filename
      t.integer :duration_seconds
      t.integer :year
      t.integer :play_count
      t.text :notes

      t.timestamps
    end
    add_index :songs, :filename, unique: true
  end
end
