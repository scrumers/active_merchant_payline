require 'active_merchant'


module ActiveMerchant
  module Billing
    module Integrations
      module Payline
        
        def mock_request
          build_request
        end
        
        def build_request(body, options)
          xml = Builder::XmlMarkup.new :indent => 2
            xml.instruct!
            xml.tag! 's:Envelope', {'xmlns:s' => 'http://schemas.xmlsoap.org/soap/envelope/'} do
              xml.tag! 's:Header' do
                xml.tag! 'wsse:Security', {'s:mustUnderstand' => '1', 'xmlns:wsse' => 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'} do
                  xml.tag! 'wsse:UsernameToken' do
                    xml.tag! 'wsse:Username', @options[:login]
                    xml.tag! 'wsse:Password', @options[:password], 'Type' => 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText'
                  end
                end
              end
              xml.tag! 's:Body', {'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema'} do
                xml.tag! 'requestMessage', {'xmlns' => 'urn:schemas-cybersource-com:transaction-data-1.32'} do
                  add_merchant_data(xml, options)
                  xml << body
                end
              end
            end
          xml.target! 
        end
        
      end
    end
  end
end