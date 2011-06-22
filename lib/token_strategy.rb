# A simple omniauth stragy for login in with a token 
# Useful if you forgot which identity you normally log in with

require 'omniauth/core'

module OmniAuth
  module Strategies
    class Token
      include OmniAuth::Strategy
      
      def request_phase
        return fail!(:missing_information) unless request[:token]
        env['REQUEST_METHOD'] = 'GET'
        env['PATH_INFO'] = request.path + '/callback'
        env['omniauth.auth'] = auth_hash(request[:token])
        call_app!
      end
      
      def auth_hash(token)
        OmniAuth::Utils.deep_merge(super(), {
          'uid' => token
        })
      end
      
      def callback_phase
        env['omniauth.auth'] = auth_hash(request[:token])
        call_app!
      end
      
    end
  end
end
