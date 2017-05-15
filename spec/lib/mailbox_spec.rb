require 'spec_helper'

describe MailRoom::Mailbox do
  describe "#deliver" do
    context "with arbitration_method of noop" do
      it 'arbitrates with a Noop instance' do
        mailbox = MailRoom::Mailbox.new({:arbitration_method => 'noop'})
        noop = stub(:deliver?)
        MailRoom::Arbitration['noop'].stubs(:new => noop)

        uid = 123

        mailbox.deliver?(uid)

        expect(noop).to have_received(:deliver?).with(uid)
      end
    end

    context "with arbitration_method of redis" do
      it 'arbitrates with a Redis instance' do
        mailbox = MailRoom::Mailbox.new({:arbitration_method => 'redis'})
        redis = stub(:deliver?)
        MailRoom::Arbitration['redis'].stubs(:new => redis)

        uid = 123
        
        mailbox.deliver?(uid)

        expect(redis).to have_received(:deliver?).with(uid)
      end
    end

    context "with delivery_method of noop" do
      it 'delivers with a Noop instance' do
        mailbox = MailRoom::Mailbox.new({:delivery_method => 'noop'})
        noop = stub(:deliver)
        MailRoom::Delivery['noop'].stubs(:new => noop)

        mailbox.deliver(stub(:attr => {'RFC822' => 'a message'}))

        expect(noop).to have_received(:deliver).with('a message')
      end
    end

    context "with delivery_method of logger" do
      it 'delivers with a Logger instance' do
        mailbox = MailRoom::Mailbox.new({:delivery_method => 'logger'})
        logger = stub(:deliver)
        MailRoom::Delivery['logger'].stubs(:new => logger)

        mailbox.deliver(stub(:attr => {'RFC822' => 'a message'}))

        expect(logger).to have_received(:deliver).with('a message')
      end
    end

    context "with delivery_method of postback" do
      it 'delivers with a Postback instance' do
        mailbox = MailRoom::Mailbox.new({:delivery_method => 'postback'})
        postback = stub(:deliver)
        MailRoom::Delivery['postback'].stubs(:new => postback)

        mailbox.deliver(stub(:attr => {'RFC822' => 'a message'}))

        expect(postback).to have_received(:deliver).with('a message')
      end
    end

    context "with delivery_method of letter_opener" do
      it 'delivers with a LetterOpener instance' do
        mailbox = MailRoom::Mailbox.new({:delivery_method => 'letter_opener'})
        letter_opener = stub(:deliver)
        MailRoom::Delivery['letter_opener'].stubs(:new => letter_opener)

        mailbox.deliver(stub(:attr => {'RFC822' => 'a message'}))

        expect(letter_opener).to have_received(:deliver).with('a message')
      end
    end

    context "without an RFC822 attribute" do
      it "doesn't deliver the message" do
        mailbox = MailRoom::Mailbox.new({:delivery_method => 'noop'})
        noop = stub(:deliver)
        MailRoom::Delivery['noop'].stubs(:new => noop)

        mailbox.deliver(stub(:attr => {'FLAGS' => [:Seen, :Recent]}))

        expect(noop).to have_received(:deliver).never
      end
    end

    context "with ssl options hash" do
      it 'replaces verify mode with constant' do
        mailbox = MailRoom::Mailbox.new({:ssl => {:verify_mode => :none}})

        expect(mailbox.ssl_options).to eq({:verify_mode => OpenSSL::SSL::VERIFY_NONE})
      end
    end
  end
end
