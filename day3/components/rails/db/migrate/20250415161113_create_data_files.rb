class CreateDataFiles < ActiveRecord::Migration[7.2]
  def change
    create_table :data_files do |t|
      t.string :file, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
