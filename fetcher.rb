require 'net/http'
require 'openssl'

warn_level = $VERBOSE
$VERBOSE = nil
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
$VERBOSE = warn_level

class Fetcher
    def fetch_media uri, user, password
        uri = URI(uri)
        res = Net::HTTP.post_form(uri, 'LANG' => 'de', 'BENUTZER' => user, 'PASSWORD' => password, 'FUNC' => 'medk')
        res.body
    end
end
