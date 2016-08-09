class AddMaxToEvents < ActiveRecord::Migration
  def change
    add_column :events, :max_participants, :integer
  end
end
