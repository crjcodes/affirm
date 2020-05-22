# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

VerseRef.destroy_all
Keyword.destroy_all

keywords_to_seed = {
  "anxiety"=>[ "Proverbs 3:26" ],
  "community"=>[ "1 John 1:7", "Hebrews 13:1-2", "1 Peter 4:9", "Hebrews 10:24-25", "1 Thessalonians 5:14", "Matthew 18:20"],
  "encouragement"=>[ "Proverbs 3:26", "Psalm 51:10", "Hebrews 13:15" ],
  "fear"=>[ "Isaiah 41:10" ],
  "endurance"=>[ "Psalm 51:10"],
  "giving"=>["2 Corinthians 9:6-7"],
  "loneliness"=>[ "Hebrews 13:15" ],
  "thought"=>[ "2 Timothy 2:7" ]
}


keywords_to_seed.each do |kw, refs|

  # COW: TO-DO: error handling for invalid keyword returned
  # from either call

  if not Keyword.exists?(keyword: kw)
    a_keyword = Keyword.create(keyword: kw)
  else
    a_keyword = Keyword.find_by(keyword: kw)
  end

  refs.each do | bible_ref |
    vr = VerseRef.create(verse_ref: bible_ref, keyword_id: a_keyword.id)
  end
end


p "Created #{Keyword.count} affirm keywords"
p "Created #{VerseRef.count} affirm verse references"




