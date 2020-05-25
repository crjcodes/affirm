# a pseudo-model acting as the encapsulation of the API query

# API expects
#   http://getbible.net/json?passage=Jn3:16

require 'net/https'

class Verse

  @@source = nil
  
  def self.initialize
    @@source = "https://getbible.net/json"
  end
  
  def get(verse_ref)
    
    # CODEON: validate @@source

    my_url = @@source

    p "uri to start ===#{my_url}==="

    my_url.concat "?passage=" + URI.encode(verse_ref)
    my_url.concat "&type=json"

    p "uri with parameters ===#{my_url}==="
    
    uri = URI(my_url)

    p "-------------------------------------"
    p "uri = " + "#{uri.request_uri}"
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    # THE RESPONSE WITH SOME LEVEL OF ERROR HANDLING
    begin
      response = http.request(request)

      # CODEON: maybe later, more in-depth error info here
      # CONVERSION FROM CODE TO OBJECT
      #   Net::HTTPResponse::CODE_TO_OBJ => {"100"=>Net::HTTPContinue, "101"=>Net::HTTPSwitchProtocol...      

      case response.code
      when 200..299
        puts "Success!"      
      when 300..499
        puts "Client error: #{response.code}"
        # CODEON: re-route to client error page and logging action
      when 500..599
        puts "Server error: #{response.code}"
        # CODEON: re-route to server error page
      when 100..199
        puts "Information message: #{response.code}"
        # CODEON: re-route to general error page, something went wrong
      else
        puts "Unknown error: #{response.code}"
      end

    rescue Errno::ECONNREFUSED
      puts "Affirm tried to talk to the Bible service, but it's not responding right now.  Try back later."
      # CODEON: re-route to server error page
      false
    rescue StandardError, Exception
      puts "Something went wrong"
      # call on Affirm's public page for "Unknown error -- Something went wrong"
      # CODEON: re-route to general error page, something went wrong
      false
    end   

    p "-------------------------------------"
    p "code=#{response.code}"
    p "message=#{response.message}"
    p "content_type=#{response.content_type}"
    p "body=#{response.body}"
    p "location=#{response.header['location']}"

    return response.body
  end
end
