class Keyword < ApplicationRecord

  def to_s
    kw = self.keyword
    i = self.id
    "Keyword: #{kw}, ID:#{i}"
  end
end
