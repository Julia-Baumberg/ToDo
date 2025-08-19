class RenameBodyToContentInComments < ActiveRecord::Migration[7.1]
  def change
    rename_column :comments, :body, :content
  end
end
