class AddActiveToDriver < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :active, :boolean, default: false, null: false
  end
end
