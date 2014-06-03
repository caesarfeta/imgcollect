class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :name
      t.text :path
      t.text :original
      t.text :thumb
      t.integer :license
      t.integer :copyright
      t.integer :uploaded_by

      t.timestamps
    end
  end
end
