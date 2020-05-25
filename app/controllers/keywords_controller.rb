class KeywordsController < ApplicationController
  def show
    @keywords = Keyword.all    
  end
end
