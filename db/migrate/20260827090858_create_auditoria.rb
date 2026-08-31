class CreateAuditoria < ActiveRecord::Migration[8.1]
  def change
    create_table :auditoria do |t|
      t.references :theatre, null: false, foreign_key: true
      t.string :name, null: false
      t.string :screen_type
      t.integer :capacity, null: false

      t.timestamps
    end
  end
end
