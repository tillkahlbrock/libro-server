require 'rubygems'
require 'json'
require 'sinatra'
require 'jwt'

require_relative './parser.rb'
require_relative './fetcher.rb'

class Libro < Sinatra::Base

    def initialize
        @auth_secret = ENV['AUTH_SECRET']
        @base_url = ENV['BASE_URL']
        @hash_algorithm = 'HS256'
        @parser = Parser.new
        @fetcher = Fetcher.new
        super
    end

    post '/token/create' do
        set_headers
        username, password = credentials_from_request
        payload = {:username => username, :password => password}
        token = JWT.encode payload, @auth_secret, @hash_algorithm
        token.to_s
    end

    post '/' do
        set_headers
        token = assert_and_read_token
        decoded_token_payload = decode_token_payload token

        media_data = @fetcher.fetch_media(@base_url + '/user.C', decoded_token_payload['username'], decoded_token_payload['password'])
        media_list = @parser.media_list(media_data)

        media_list[1..-1].to_json
    end

    options "*" do
        response.headers["Allow"] = "POST"
        response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization"
        response.headers["Access-Control-Allow-Origin"] = "*"
        200
    end

    def decode_token_payload token
        decoded_token = JWT.decode token, @auth_secret, true, {:algorithm => @hash_algorithm }
        decoded_token[0]
    end

    def assert_and_read_token
        unless request.env['HTTP_AUTHORIZATION'].nil?
            match = request.env['HTTP_AUTHORIZATION'].match /^Bearer (.+)/
            return match[1].nil? ? '' : match[1]
        end
        raise 'no token found'
    end

    def set_headers
        headers "Content-Type" => "application/json"
        headers "Access-Control-Allow-Origin" => "*"
    end

    def credentials_from_request
        request.body.rewind
        body = JSON.parse request.body.read
        return body['username'], body['password']
    end
end
