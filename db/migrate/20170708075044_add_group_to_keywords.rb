class AddGroupToKeywords < ActiveRecord::Migration[5.1]
  def change
    add_column :keywords, :group, :string
  end
end
