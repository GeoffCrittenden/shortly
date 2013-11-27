class CreateShortlys < ActiveRecord::Migration
  def change
    create_table :shortlies do |t|
      t.string :shortly
      t.string :longly
      t.string :url
      t.string :lead
      t.string :body

      t.timestamps
    end
  end
end
