class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0.0
      t.integer :kind, null: false, default: 0

      t.timestamps
    end
  end
end
