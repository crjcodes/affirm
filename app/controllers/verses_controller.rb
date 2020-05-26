class VersesController < ApplicationController
  def show
    # take the keyword sent with the show,
    # get a list of bible references from the affirm db
    @k_id = params[:keyword_id]
    
    # CODEON: validate parameter

    @kword = Keyword.where(id: @k_id)

    # CODEON: validate returned list, including
    # CODEON: error if number of keyword records returned is 0

    @keyword = @kword[0].keyword;

    @results = Hash.new

    Verse.initialize

    verse_ref_list = VerseRef.where(keyword_id: @k_id)
    verse_ref_list.each do |verse_ref|
      v = Verse.new
      hashkey = verse_ref.verse_ref
      @results[hashkey] = v.get_passage(hashkey)

      Rails.logger.debug "In loop for " + verse_ref.verse_ref
    end

    @results.each do | br, v |
      Rails.logger.debug "br=#{br}, verse=#{v}"
    end

  end
end
