class AddTwitterToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :twitter, :string
  end
end
