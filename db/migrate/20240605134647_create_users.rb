class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :full_name, null: false, default: ''
      t.string :cpf, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :password, null: false, default: ''
      t.integer :kind, null: false, default: 0

      t.timestamps
    end

    add_index :users, :cpf, unique: true
    add_index :users, :email, unique: true
    add_index :users, :full_name, unique: true
  end
end
