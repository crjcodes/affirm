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

    verse_ref_list = VerseRef.where(keyword_id: @k_id)
    verse_ref_list.each do |verse_ref|
      v = Verse.new
      passage = v.get_passage(verse_ref.verse_ref)
      if !passage.empty?
        @results[verse_ref.verse_ref] = passage
      else
        Rails.logger.error "'#{verse_ref.verse_ref}' not found."
      end
    end

    if @results.empty?
      Rails.logger.error "No results!"
      # CODEON: redirect to error page if no results
    end
  end
end
