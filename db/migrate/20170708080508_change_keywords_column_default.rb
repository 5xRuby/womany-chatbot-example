class ChangeKeywordsColumnDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :keywords, :group, :string, default: ''
    change_column :keywords, :context, :string, default: ''
    change_column :clients, :context, :string, default: ''
  end
end
