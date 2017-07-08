class CreateSuggests < ActiveRecord::Migration[5.1]
  def change
    create_table :suggests do |t|
      t.string :text
      t.string :options

      t.timestamps
    end
  end
end
