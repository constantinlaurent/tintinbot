require 'facebook/messenger'
include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'GET_STARTED_PAYLOAD'
  },
  greeting:[
  {
    "locale":"default",
    "text":"Hello! {{user_first_name}} "
  }, {
    "locale":"en_US",
    "text":"Timeless apparel for the masses."
  }
],
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
    postback.payload   # => 'GET_STARTED_PAYLOAD'
  
    if postback.payload == 'GET_STARTED_PAYLOAD'
      message.typing_on
      message.reply(text: "Salut je suis un Chatbot, allez commençons !")
    elsif postback.payload == 'WHAT'
      message.typing_on
      message.reply(text: "Un chatbot est un robot qui te parle :D")
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
      message.reply({
    "text": "Here is a quick reply!",
    "quick_replies":[
      {
        "content_type":"text",
        "title":"Search",
        "payload":"<POSTBACK_PAYLOAD>",
        "image_url":"http://www.stickpng.com/assets/images/58afdad6829958a978a4a693.png"
      },
      {
        "content_type":"location", }]})
    elsif postback.payload == 'BAD_MOOD'
      message.reply(text: "Hey, ne t'inquiete pas ! Tout va bien aller")
      message.reply ({
    "attachment":{
      "type":"template",
      "payload":{
        "template_type":"generic",
        "elements":[
           {
            "title":"Welcome!",
            "image_url":"https://petersfancybrownhats.com/company_image.png",
            "subtitle":"We have the right hat for everyone.",
            "default_action": {
              "type": "web_url",
              "url": "https://petersfancybrownhats.com/view?item=103",
              "webview_height_ratio": "tall",
            },
            "buttons":[
              {
                "type":"web_url",
                "url":"https://petersfancybrownhats.com",
                "title":"View Website"
              },{
                "type":"postback",
                "title":"Start Chatting",
                "payload":"DEVELOPER_DEFINED_PAYLOAD"
              }              
            ]      
          }
        ]
      }
    }
  })
    elsif postback.payload == 'GET_STARTED_PAYLOAD'
      message.typing_on
      message.reply(text: "Salut je suis un Chatbot, allez commençons !")
    elsif postback.payload == 'WHAT'
      message.typing_on
      message.reply(text: "Un chatbot est un robot qui te parle :D")
    end
  end
end

