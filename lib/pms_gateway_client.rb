#require "pms_gateway_client/version"

require 'curl'                  # Curl::Easy
require 'cgi'                   # CGI::escape

# Pms Gateway Client
class PmsGatewayClient

  attr_reader :gateway_url, :status, :called_url, :body_str
  attr_accessor :verbose
  # @param gateway_url [String] top level url of gateway
  # @param verbose[Boolean] whether to print out additional information
  def initialize(gateway_url, verbose=false)
    @gateway_url = gateway_url
    @verbose = verbose
  end

  # does a get request via Curl::Easy.  Stores status, body_string and called url via set_results
  # @param url_base [String]  base url
  # @param params [Hash]  to pass to url
  #
  # @return String body_str string of body returned
  def curl_get (url_base, params)
    c = Curl::Easy.new
    c.url = "#{url_base}?#{params_as_url(params)}"
    debug(c.url)
    set_ssl_options(c)
    c.perform
    set_results(c)
    @body_str
  end

  def debug(*args)
    puts(*args) if @verbose
  end

  # Stores status, body_string and called url from a Curl::Easy object
  # @param c [Curl::Easy] curl object
  def set_results(c)
    @status = c.status
    @body_str = c.body_str
    @called_url = c.url
  end

  # Set SSL options needed
  # @param c [Curl::Easy] curl object
  def set_ssl_options(c)
    c.ssl_version = 3
    c.ssl_verify_host = false
    c.ssl_verify_peer = false
    c.verbose = true if @verbose
  end

  # Convert params as url friendly
  def params_as_url(params)
    params.map { |key, value| "#{key}=#{CGI::escape(value.to_s)}"}.join("&")
  end

  # does a post request via Curl::Easy.  Stores status, body_string and called url via set_results
  # @param url_base [String]  base url
  # @param params [Hash]  to pass to url
  #
  # @return [String] body_str string of body returned
  def curl_post(url_base, params)
    puts "#{url_base} #{params.inspect}"
    c = Curl::Easy.new
    c.url = url_base
    set_ssl_options(c)
    c.http_post(params.map { |key, value| Curl::PostField.content(key, value)})
    set_results(c)
    c.body_str
  end

  # Makes a room query from PMS
  #
  # @param room_number [String]  the Room number, either real, or special account (House, Group, Member)
  # @param pms_number [String]  pms model number to know protocol
  # @param port [Integer]  the socket to communicate over
  #
  # @return [String] names as JSON string, if first string starts with a "/" the room cannot be changed, if it starts with "?" this is an error.  Example from hitting Mark's simulator: ["Name1forRoom:511", "Name2forRoom:511", "Name3forRoom:511", "Name4forRoom:511", "Name5forRoom:511"]
  def inquiry(room_number, pms_number, port)
    curl_get("#{@gateway_url}/inquiry", room_number: room_number, pms_number: pms_number, port: port)
  end


  # Posts a purchase to the pms
  #
  # @param room_number [String]  the Room number to be charged
  # @param guest_name [String]  the name of the guest
  # @param user_line_entry [Integer]  index of the guest in the returned query
  # @param port [Integer]  the port communicate on
  # @param amount [Float]  the amount of the purchase
  # @param sale_number [Integer]  0-9999
  # @param revenue_center_number [String]  String
  # @return String hash as JSON string, example from hitting Mark's emulator { :acceptance_denial_message=>"Name1forRoom:H24", :selection_field_information=>["                ", "                ", "                ", "                "] }

  def post( room_number, pms_model, guest_name, user_line_entry, port, amount, sale_number, revenue_center_number)
    curl_post("#{@gateway_url}/post",
         :room_number           => room_number,
         :pms_model             => pms_model,
         :guest_name            => guest_name,
         :user_line_entry       => user_line_entry,
         :port                  => port,
         :amount                => amount,
         :sale_number           => sale_number,
         :revenue_center_number => revenue_center_number,
         )
  end


end
