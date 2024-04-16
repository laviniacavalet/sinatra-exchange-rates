require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do

    # build the API url, including the API key in the query string
    api_url = "http://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATES_KEY']}"
    
    #response = HTTP.get(api_url)
    #@parsed = JSON.parse(response.to_s)

    @parsed_data = JSON.parse(HTTP.get(api_url).to_s)
    @parsed = @parsed_data["currencies"]
    erb(:homepage)
end

get("/:currency") do
  @original_currency = params.fetch("currency")
  api_key = ENV['EXCHANGE_RATES_KEY']
  
  raw_data = HTTP.get("http://api.exchangerate.host/list?access_key=#{api_key}")
  raw_data_string = raw_data.to_s
  
  parsed_data = JSON.parse(raw_data_string)
  @parsed = parsed_data["currencies"]
  
  erb(:currency)
  end

  get("/:from_currency/:to_currency") do
    api_key = ENV['EXCHANGE_RATES_KEY']
    @original_currency = params.fetch("from_currency")
    @destination_currency = params.fetch("to_currency")
    
    api_url = "http://api.exchangerate.host/convert?access_key=#{api_key}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
    
    aw_data = HTTP.get(api_url).to_s
    
    parsed_data = JSON.parse(raw_data_string)
    @converted = parsed_data["currencies"]
    
    erb(:rate)
    end
