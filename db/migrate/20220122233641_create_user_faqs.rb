class CreateUserFaqs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_faqs do |t|
      t.references :user, null: false
      t.references :faq, null: false

      t.timestamps
    end
    add_index :user_faqs, [ :user_id, :faq_id], :unique => true, order: { user_id: :asc, faq_id: :asc }
    add_foreign_key :user_faqs, :faqs, column: :faq_id, primary_key: :id, on_update: :cascade, on_delete: :cascade
    add_foreign_key :user_faqs, :users, column: :user_id, primary_key: :id, on_update: :cascade, on_delete: :cascade
  end
end
