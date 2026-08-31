class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :duration_minutes
      t.date :release_date
      t.references :language, null: false, foreign_key: true
      t.string :certificate
      t.string :status
      t.string :poster_url
      t.string :trailer_url

      t.timestamps
    end
  end
end
