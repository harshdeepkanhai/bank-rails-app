class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.integer :amount
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :bank_accounts, [:user_id, :created_at]
  end
end
