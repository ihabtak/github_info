class CreateSearchHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :search_histories do |t|
      t.string :q_username
      t.string :name

      t.timestamps
    end
    add_index :search_histories, :q_username, unique: true
  end
end
