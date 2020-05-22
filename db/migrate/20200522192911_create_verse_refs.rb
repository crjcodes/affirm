class CreateVerseRefs < ActiveRecord::Migration[6.0]
  def change
    create_table :verse_refs do |t|
      t.string :ref
      t.Keyword :belongs_to

      t.timestamps
    end
  end
end
