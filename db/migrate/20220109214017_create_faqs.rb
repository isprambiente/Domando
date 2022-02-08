class CreateFaqs < ActiveRecord::Migration[6.0]
  def change
    create_table :faqs do |t|
      t.string  :title, index: true
      t.citext  :structure, index: true
      t.integer :counter, null: false, default: 0, index: true
      t.boolean :approve, null: false, default: false, index: true
      t.boolean :evidence, null: false, default: false, index: true
      t.boolean :active, null: false, default: true, index: true
      t.jsonb :metadata

      t.timestamps
    end
  end
end
