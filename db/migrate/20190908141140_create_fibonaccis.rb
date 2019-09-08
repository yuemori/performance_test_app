class CreateFibonaccis < ActiveRecord::Migration[5.2]
  def change
    create_table :fibonaccis do |t|
      t.integer :number

      t.timestamps
    end
  end
end
