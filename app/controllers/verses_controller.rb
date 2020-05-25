class VersesController < ApplicationController
  def show
    # take the keyword sent with the show,
    # get a list of bible references from the affirm db
    @k_id = params[:keyword_id]
    
    # CODEON: validate parameter

    @kword = Keyword.where(id: @k_id)

    # CODEON: validate returned list, including
    # CODEON: error if number of keyword records returned is 0

    kw = @kword[0].keyword;

    @results = {}

    Verse.initialize

    verse_ref_list = VerseRef.where(keyword_id: @k_id)
    verse_ref_list.each do |verse_ref|
      v = Verse.new
      p "In loop for " + verse_ref.verse_ref
      #p ":::" + 
      hashkey = verse_ref.verse_ref
      @results[hashkey] = v.get(hashkey)
    end

    p "results = #{@results}"

  end
end
