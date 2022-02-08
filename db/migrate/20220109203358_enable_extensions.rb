# frozen_string_literal: true

# Enable extensions
class EnableExtensions < ActiveRecord::Migration[6.0]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS citext;'
    execute 'CREATE EXTENSION IF NOT EXISTS unaccent;'
    execute 'CREATE EXTENSION IF NOT EXISTS pg_trgm;'
    execute 'CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS citext;'
    execute 'DROP EXTENSION IF EXISTS unaccent;'
    execute 'DROP EXTENSION IF EXISTS pg_trgm;'
    execute 'DROP EXTENSION IF EXISTS fuzzystrmatch;'
  end
end
