class CreateUsers < ActiveRecord::Migration[5.1]
  def change
  create_table :users do |t|
  t.string :username
  t.string :password_digest
  t.boolean :edit
  t.boolean :admin
  t.timestamps null:false
  end

User.create(username: "Admin", password: "admin", edit: true, admin: true)	  



end
end

