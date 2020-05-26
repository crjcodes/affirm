class KeywordsController < ApplicationController
  def show
    @keywords = Keyword.order(:keyword)    
  end
end
