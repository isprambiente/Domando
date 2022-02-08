# frozen_string_literal: true

# This migration manage users table
class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## CAS Authenticable
      t.string :username, null: false, default: '', index: { unique: true }

      ## User fields
      t.string :label, index: true, default: ''
      t.string :email, default: ''
      t.string :structure, index: true, default: ''
      t.jsonb :metadata

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip

      ## security role
      t.boolean :editor, index: true, default: false
      t.boolean :admin, index: true, default: false

      ## Lockable
      t.datetime :locked_at

      t.timestamps null: false
    end
  end
end
