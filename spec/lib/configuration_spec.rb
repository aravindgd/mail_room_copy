require 'spec_helper'

describe MailRoom::Configuration do
  let(:config_path) {File.expand_path('../fixtures/test_config.yml', File.dirname(__FILE__))}

  describe 'set_mailboxes' do
    it 'parses yaml into mailbox objects' do
      MailRoom::Mailbox.stubs(:new).returns('mailbox1', 'mailbox2')

      configuration = MailRoom::Configuration.new(:config_path => config_path)

      expect(configuration.mailboxes).to eq(['mailbox1', 'mailbox2'])
    end

    it 'sets mailboxes to an empty set when config_path is missing' do
      MailRoom::Mailbox.stubs(:new)

      configuration = MailRoom::Configuration.new

      expect(configuration.mailboxes).to eq([])

      expect(MailRoom::Mailbox).to have_received(:new).never
    end
  end
end
