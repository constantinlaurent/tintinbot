require 'facebook/messenger'

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])

Bot.on :message do |message|
  # message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
  # message.sender      # => { 'id' => '1008372609250235' }
  # message.sent_at     # => 2016-04-22 21:30:36 +0200
  # message.text        # => 'Hello, bot!'

  message_text = message.text

  if message_text.nil?
    begin
      message_text = KnownLocation.guess_known_location_by_coordinates(message.attachments.first['payload']['coordinates'].values)
    rescue => e
      puts '[debuz] got unhandlable facebook message: ' + e.message + ' :@: ' + message.to_json
    end
  end

  unless message_text.nil?
    puts "[debuz] got from Facebook... #{message.text}"
    ChatExtension.response(message_text, message.sender['id'])
  end
end

Bot.on :postback do |postback|
  # postback.sender    # => { 'id' => '1008372609250235' }
  # postback.recipient # => { 'id' => '2015573629214912' }
  # postback.sent_at   # => 2016-04-22 21:30:36 +0200
  # postback.payload   # => 'EXTERMINATE'

  if postback.payload == 'DEVELOPER_DEFINED_PAYLOAD_FOR_HELP'
    puts "[debuz] Human #{postback.recipient} marked for extermination"

    Bot.deliver(
      {
        recipient: postback.sender,
        message: {
          text: 'I can tell you the (1) Current Weather (2) 24-Hour Forecast (3) PSI  in different locations in Singapore. For example, you can ask me "What is the weather in Changi?"; "Is it raining in Bedok?"; "What is the forecast in the South?" or "What is the PSI in the North?"'
        }
      },
      access_token: ENV['ACCESS_TOKEN']
    )
  end
end