require 'logger'

module SmsSender

  def create_sms_sender
    if defined? Rails
      env = Rails.env
    else
      env = nil
    end

    if defined? logger
      _logger = logger
    else
      _logger = Logger.new(STDOUT)
    end

    create_sms_sender_by_env(env, _logger)
  end

  def create_sms_sender_by_env(env, _logger)
    if env == "test"
      TestSender.new
    else
      SmsApiSender.new _logger
    end
  end

end

require "message"
require "test_sender"
require "sms_api_sender"
require "action_controller_ext"
require "active_record_base_ext"
require "sms_sender_module"