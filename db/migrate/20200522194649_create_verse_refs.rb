class CreateVerseRefs < ActiveRecord::Migration[6.0]
  def change
    create_table :verse_refs do |t|
      t.string :verse_ref
      t.belongs_to :keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end
