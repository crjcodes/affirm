# a pseudo-model acting as the encapsulation of the API query

# API expects
#   http://getbible.net/json?passage=Jn3:16

require 'net/https'
require 'json'

class Verse

  SOURCE = "https://getbible.net/json".freeze
  
  # this parses what is received back from the external api,
  # forming the verses into one usually longer passage
  def get_passage(verse_ref)

    check_result = get(verse_ref)
  
    result = ""
    if check_result["success"] == true
      json = check_result["result"]
      item = json["book"][0]["chapter"]

      item.each do |key, val|      
        item[key].each do |k2, v2|
          if k2 == "verse"
            result.concat(v2)
          end
        end
      end
    else
      json = ""
    end
#    Rails.logger.debug "result= #{result}"     
    return result
  end

  # performs the call to the external api to bring back
  # the Bible passage requested

  def get(verse_ref)
       
    my_url = String.new(Verse::SOURCE)
    my_url.concat "?passage=" + URI.encode(verse_ref)
    my_url.concat "&type=json"
   
    uri = URI(my_url)
   
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    # THE RESPONSE WITH SOME LEVEL OF ERROR HANDLING
    begin
      response = http.request(request)

      Rails.logger.info "GET request uri with parameters=#{my_url} and response = #{response.code}"
      # CODEON: maybe later, more in-depth error info here
      # CONVERSION FROM CODE TO OBJECT
      #   Net::HTTPResponse::CODE_TO_OBJ => {"100"=>Net::HTTPContinue, "101"=>Net::HTTPSwitchProtocol...      
      # CODEON: switch Net:: return values, i.e. HTTPSuccess, Net::HTTPUnauthorized, Net::HTTPServerError

      case response.code.to_i
      when 200..299
#        Rails.logger.info "GET query response successful for #{uri.inspect}"      
      when 300..499
        Rails.logger.error "Client error: #{response.code}"
        # CODEON: re-route to client error page and logging action
      when 500..599
        Rails.logger.error "Server error: #{response.code}"
        # CODEON: re-route to server error page
      when 100..199
        Rails.logger.info "Information message: #{response.code}"
        # CODEON: re-route to general error page, something went wrong
      else
        Rails.logger.error "Unknown error: #{response.code}"
      end

    rescue Errno::ECONNREFUSED
      Rails.logger.error "Affirm tried to talk to the Bible service, but it's not responding right now.  Try back later."
      # CODEON: re-route to server error page
      false
    rescue StandardError, Exception
      Rails.logger.error "Something went wrong"
      # call on Affirm's public page for "Unknown error -- Something went wrong"
      # CODEON: re-route to general error page, something went wrong
      false
    end   

#    Rails.logger.debug "response.body=#{response.body}"
    
    if response.body != "NULL"
      # the external API isn't parsed successfully by the JSON because
      # of the parentheses and semicolon that come with the response
      response.body = response.body.gsub(/[\(\);]/,"")

#      Rails.logger.debug "cleaned up body = #{response.body}"

      json = { 
        "result" => JSON.parse(response.body), 
        "success" => true
      }
    else
      json = { 
        "result" => "", 
        "success" => false
      }
    end

#    Rails.logger.debug "response json=#{json}"

    return json
  end
end
