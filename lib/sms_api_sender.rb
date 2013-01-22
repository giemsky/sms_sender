require 'net/http'
require 'net/https'
require 'digest/md5'


module SmsSender
  class AuthenticationError < StandardError; end
  class NoCreditError < StandardError; end
  class ApiError < StandardError; end

  class SmsApiSender
    SMS_API_URL = 'https://ssl.smsapi.pl/send.do'

    attr_writer :from, :test, :eco, :login, :password

    def initialize(logger)
      @logger = logger
    end

    def send_sms(message)
      url = URI.parse(SMS_API_URL)
      req = Net::HTTP::Post.new(url.path)
      params = basic_params message
      add_extra_params(params)
      override_params(params, message)
      req.set_form_data(params)
      @logger.info "Requesting sms api to send message: ''#{truncated_text(message)}', params #{params.inspect}"
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      if defined? Rails and Rails.configuration.respond_to?('sms_sender_ca_path')
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.ca_path = Rails.configuration.sms_sender_ca_path
      else
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      res = http.start { |http| http.request(req) }
      @logger.info 'Sms api request finished processing with response %s' % res.body
      if sms_not_sent? res
        # http://www.smsapi.pl/sms-api/kody-bledow
        @logger.error "Sms send error #{res.inspect}"
        
        case res.body.split(':').last.to_i
        when 101..102 then raise AuthenticationError
        when 103 then raise NoCreditError
        else raise ApiError
        end
       else
        parse_response(res)
      end
    end

    # without rails configuration
    def self.username=(username)
      @@username = username
    end

    def self.password=(password)
      @@password = password
    end

    def self.from=(from)
      @@from = from
    end

    def self.sms_sender_test=(test)
      @@sms_sender_test = test
    end

    def self.sms_sender_eco=(eco)
      @@sms_sender_eco = eco
    end

    def self.username
      return @@username if defined? @@username
      return Rails.configuration.sms_sender_login
    end

    def self.password
      return @@password if defined? @@password
      return Rails.configuration.sms_sender_password
    end

    def self.from
      return @@from if defined? @@from
      return Rails.configuration.sms_sender_from if defined? Rails and Rails.configuration.respond_to?(:sms_sender_from)
      return nil
    end

    def self.sms_sender_test
      return @@sms_sender_test if defined? @@sms_sender_test
      return Rails.configuration.respond_to?(:sms_sender_test) if defined? Rails
      return nil
    end

    def self.sms_sender_eco
      return @@sms_sender_eco if defined? @@sms_sender_eco
      return Rails.configuration.respond_to?(:sms_sender_eco) if defined? Rails
      return nil
    end

    private

    def basic_params message
      {
        'username' => self.class.username,
        'password' => Digest::MD5.hexdigest(self.class.password),
        'to' => message.telephone,
        'message' => truncated_text(message),
        'encoding' => 'utf-8'
      }
    end

    def add_extra_params(params)
      params.merge! 'from' => self.class.from unless self.class.from.nil?
      params.merge! 'test' => '1' if self.class.sms_sender_test
      params.merge! 'eco' => '1' if self.class.sms_sender_eco
    end

    def override_params(params, message)
      case message.type.to_s
        when "eco" then
          params.delete('pro') # pro
          params.delete('from') # pro
          params.delete('test') # test
          params['eco'] = 1
        when "pro", "normal" then
          params.delete('eco') # eco
          params.delete('test') # test
          params['from'] = message.from
        when "test" then
          params.delete('pro') # pro
          params.delete('from') # pro
          params.delete('eco') # eco
          params['pro'] = 1
      end
    end

    def sms_not_sent? response
      !response.is_a?(Net::HTTPSuccess) || !(response.body =~ /.*OK.*/)
    end

    def parse_response response
      Hash[[:message_id, :credits].zip(response.body.split(':')[1..-1])]
    end

    def truncated_text message
      text = message.text
      length = [text.length, max_len_of_text(text)].min
      text[0, length]
    end

    def max_len_of_text text
      if text.match(/[^@\u00A3\$\u00A5\u00E8\u00E9\u00F9\u00EC\u00F2\u00C7\u00D8\u00F8\u00C5\u00E5_\^\{\}\[~\]\|\u00C6\u00E6\u00DF\u00C9!'#\u00A4%&'\(\)\*\+\,\-\.\/0-9:;<=>\?A-Z\u00C4\u00D6\u00D1\u00DC\u00A7\u00BFa-z\u00E4\u00F6\u00F1\u00FC\u00E0 \r\n]/)
        return 201
      else
        return 457
      end
    end
  end
end
