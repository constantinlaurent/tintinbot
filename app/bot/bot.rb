require 'facebook/messenger'
include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'Start'
  },
  persistent_menu: [
    {
      locale: 'default',
      composer_input_disabled: false,
      call_to_actions: [
        {
          title: 'My Account',
          type: 'nested',
          call_to_actions: [
            {
              title: 'Démarrer',
              type: 'postback',
              payload: 'GET_STARTED_PAYLOAD'
            },
            {
              title: 'What is a chatbot?',
              type: 'postback',
              payload: 'WHAT'
            }
          ]
        },
        {
          type: 'web_url',
          title: 'Get some help',
          url: 'http://www.google.com',
          webview_height_ratio: 'full'
        }
      ]
    },
  ]
  
}, access_token: ENV['ACCESS_TOKEN'])
  
Bot.on :postback do |postback|
    message.typing_on
    postback.sender    # => { 'id' => '1008372609250235' }
    postback.recipient # => { 'id' => '2015573629214912' }
    postback.sent_at   # => 2016-04-22 21:30:36 +0200
    postback.payload   # => 'Start'
  
    if postback.payload == 'Start'
      message.typing_on
      message.reply(text: "Salut je suis un Chatbot, allez commençons !") 
    elsif postback.payload == 'WHAT'
      message.typing_on
      message.reply(text: "Un chatbot est un robot qui te parle :D") 
    else
      message.typing_off
    end
end


Bot.on :message do |message|
  message.reply(
  attachment: {
    type: 'template',
    payload: {
      template_type: 'button',
      text: 'Comment vas-tu ?',
      buttons: [
        { type: 'postback', title: 'Bien', payload: 'GOOD_MOOD' },
        { type: 'postback', title: 'Pas top', payload: 'BAD_MOOD' }]}})

  Bot.on :postback do |postback|
    message.typing_on
    postback.sender    # => { 'id' => '1008372609250235' }
    postback.recipient # => { 'id' => '2015573629214912' }
    postback.sent_at   # => 2016-04-22 21:30:36 +0200
    postback.payload   # => 'GET_STARTED_PAYLOAD'
  
    if postback.payload == 'GOOD_MOOD'
      puts "Human #{postback.recipient} marked for extermination"
      message.reply(text: "Hey top, quoi de prévu en ce moment ?") 
    elsif postback.payload == 'BAD_MOOD'
      message.reply(text: "Hey, ne t'inquiete pas ! Tout va bien aller")
    elsif postback.payload == 'GET_STARTED_PAYLOAD'
      message.typing_on
      message.reply(text: "Salut je suis un Chatbot, allez commençons !")
    else
      message.typing_off
    end
  end
end