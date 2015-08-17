class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ucard_no
      t.string :surname
      t.string :forename
      t.string :job_title

      t.timestamps null: false
    end
  end
end
