class CreateAlbums < ActiveRecord::Migration[8.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.text :description
      t.string :web_link
      t.integer :year

      t.timestamps
    end
  end
end
