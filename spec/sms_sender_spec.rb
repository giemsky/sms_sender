require 'spec_helper'

include SmsSenderModule

describe SmsSender do
  it "manual test" do
    SmsSender::SmsApiSender.username = '...'
    SmsSender::SmsApiSender.password = 'admin1'
    #SmsSender::SmsApiSender.from = 'from'
    #SmsSender::SmsApiSender.sms_sender_test = true
    #SmsSender::SmsApiSender.sms_sender_eco = 1

    #send_sms('601...', 'test', :eco)
    #send_sms('601...', 'test')
  end
end
