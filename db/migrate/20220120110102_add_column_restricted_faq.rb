class AddColumnRestrictedFaq < ActiveRecord::Migration[7.0]
  def up
    add_column :faqs, :visibility, :integer, default: 0, index: true
  end

  def down
    remove_column :faqs, :visibility
  end
end
