require 'rubygems'
require 'json'
require 'sinatra'
require_relative './parser.rb'
require_relative './fetcher.rb'

class Libro < Sinatra::Base
    before do
        headers \
        "Content-Type"   => "application/json"
    end

    post '/' do
        username, password = parse_request_params
        parser = Parser.new()
        fetcher = Fetcher.new()

        media_data = fetcher.fetch_media('https://opac.geesthacht-schwarzenbek.de/opax1/user.C', username, password)
        media_list = parser.media_list(media_data)

        media_list[1..-1].to_json
    end

    options "*" do
        response.headers["Allow"] = "POST"
        response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
        response.headers["Access-Control-Allow-Origin"] = "*"
        200
    end

    def parse_request_params
        request.body.rewind
        body = JSON.parse request.body.read

        response.headers["Access-Control-Allow-Origin"] = "*"
        return body['username'], body['password']
    end
end
