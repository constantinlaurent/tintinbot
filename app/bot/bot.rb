require 'facebook/messenger'
include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'GET_STARTED_PAYLOAD'
  },
  persistent_menu: [
    {
      locale: 'default',
      composer_input_disabled: true,
      call_to_actions: [
        {
          title: 'My Account',
          type: 'nested',
          call_to_actions: [
            {
              title: 'What is a chatbot?',
              type: 'postback',
              payload: 'EXTERMINATE'
            },
            {
              title: 'History',
              type: 'postback',
              payload: 'HISTORY_PAYLOAD'
            },
            {
              title: 'Contact Info',
              type: 'postback',
              payload: 'CONTACT_INFO_PAYLOAD'
            }
          ]
        },
        {
          type: 'web_url',
          title: 'Get some help',
          url: 'https://github.com/hyperoslo/facebook-messenger',
          webview_height_ratio: 'full'
        }
      ]
    },
    {
      locale: 'zh_CN',
      composer_input_disabled: false
    }
  ]
  
}, access_token: ENV['ACCESS_TOKEN'])
  

Bot.on :message do |message|
  message.reply(
  attachment: {
    type: 'template',
    payload: {
      template_type: 'button',
      text: 'Human, do you like me?',
      buttons: [
        { type: 'postback', title: 'Yes', payload: 'HARMLESS' },
        { type: 'postback', title: 'No', payload: 'EXTERMINATE' }]}})

  Bot.on :postback do |postback|
    message.typing_on
    postback.sender    # => { 'id' => '1008372609250235' }
    postback.recipient # => { 'id' => '2015573629214912' }
    postback.sent_at   # => 2016-04-22 21:30:36 +0200
    postback.payload   # => 'EXTERMINATE'
  
    if postback.payload == 'EXTERMINATE'
      puts "Human #{postback.recipient} marked for extermination"
      message.reply(text: "Fais gaffe à toi !") 
    elsif postback.payload == 'HARMLESS'
      message.reply(text: "Moi aussi je t'aime") 
    end
  end
end