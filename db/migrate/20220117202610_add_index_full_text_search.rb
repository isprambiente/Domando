class AddIndexFullTextSearch < ActiveRecord::Migration[6.1]
  def up
    # add_index :faqs, :title, using: :gin
    execute <<-SQL
      CREATE INDEX title_en_idx ON faqs USING GIN (to_tsvector('english', title));
      CREATE INDEX title_it_idx ON faqs USING GIN (to_tsvector('italian', title));
    SQL
  end

  def down
    remove_index :faqs, :title
  end
end
