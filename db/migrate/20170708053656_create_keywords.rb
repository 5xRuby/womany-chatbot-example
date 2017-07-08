class CreateKeywords < ActiveRecord::Migration[5.1]
  def change
    create_table :keywords do |t|
      t.string :text
      t.string :reply

      t.timestamps
    end
  end
end
