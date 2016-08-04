class AddParentsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :parent_email, :string
    add_column :users, :parent_verified, :boolean
    add_column :users, :parent_verify_token, :string
  end
end
