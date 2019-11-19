class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.datetime :startday
      t.datetime :endday
      t.string :title
      t.text :content
      t.text :diary
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
