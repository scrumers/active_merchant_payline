require 'net/http'
require 'net/https'

module ActiveMerchant
  module Billing
    module Integrations
      module Payline
        autoload :Helper,       File.dirname(__FILE__) + '/lib/helper.rb'
        autoload :Return,       File.dirname(__FILE__) + '/lib/return.rb'
        autoload :Notification, File.dirname(__FILE__) + '/lib/notification.rb'

        # Overwrite this if you want to change the Payline homologation url
        mattr_accessor :homologation_url
        self.homologation_url = 'https://homologation.payline.com/V4/services/DirectPaymentAPI'

        # Overwrite this if you want to change the Payline production url
        mattr_accessor :production_url 
        self.production_url = 'https://services.payline.com/V4/services/DirectPaymentAPI'

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
          when :production
            self.production_url    
          when :test
            self.homologation_url
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.notification(post)
          Notification.new(post)
        end

        def self.return(query_string, options = {})
          Return.new(query_string)
        end

        def build_do_web_payment
          xml= Builder::XmlMarkup.new
          xml.instruct!
          xmlns= { 
            'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
            'xmlns:impl' => 'http://impl.ws.payline.experian.com',
            'xmlns:obj' => 'http://obj.ws.payline.experian.com'
          }
          xml.tag! "soapenv:Envelope", xmlns do
            xml.tag! "soapenv:Header"
            xml.tag! "soapenv:Body" do
              do_web_payment_envelope(xml)
            end
          end
          
          http = Net::HTTP.new(self.service_url, 443)
          http.use_ssl = true
          data = xml.target!
          resp, data = http.post(path, data)
          puts resp.inspect
          puts data.inspect          
        end
        
        private
        def do_web_payment_envelope(xml)
          xml.tag! 'impl:doWebPaymentRequest' do
            xml.tag! 'impl:securityMode' do
              xml.text! 'SSL'
            end
            xml.tag! 'impl:languageCode'
            xml.tag! 'impl:customPaymentPageCode' do
            end
            add_urls(xml)
            add_payment(xml)
            add_order(xml)
            add_contract(xml)
            add_buyer(xml)      
          end
          xml
        end

        private
        def add_urls(xml)
          xml.tag! 'impl:returnURL' do

          end
          xml.tag! 'impl:cancelURL' do

          end
          xml.tag! 'impl:notificationURL' do

          end
          xml.tag! 'impl:customPaymentTemplateURL' do

          end
          xml
        end

        def add_payment(xml)
          xml.tag! 'impl:payment' do

          end
        end

        private
        def add_order(xml)
          xml.tag! 'impl:order' do

          end
        end

        private
        def add_contract(xml)
          xml.tag! 'impl:contract' do

          end
        end

        private
        def add_buyer(xml)
          xml.tag! 'impl:buyer' do

          end
        end
        
        
        
      end
    end
  end
end