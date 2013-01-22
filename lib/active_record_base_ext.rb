module ActiveRecord

  class Base

    include SmsSender

    def send_sms(telephone, text, type = nil, from = nil)
      message = Message.new telephone, text
      sender = create_sms_sender
      sender.send_sms message
    end

  end

end