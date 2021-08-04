require "mock/client/version"
require 'grape'
require 'grape-swagger'
require_relative './client/exotel'
require_relative './client/config_helpers'

module Mock
  module Client
    class Root < Grape::API
      version 'v1', using: :header, vendor: 'exotel-client' # this can be path, vendor header, accept-version header, or param
      format :json

      mount Mock::Client::Exotel

      add_swagger_documentation
    end
  end
end


