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
        },
        {
          title: 'My Account',
          type: 'nested',
          call_to_actions: [
            {
          type: 'postback',
          title: 'Coordinates lookup',
          payload: 'COORDINATES'
        },
        {
          type: 'postback',
          title: 'Postal address lookup',
          payload: 'FULL_ADDRESS'
        },
        {
          type: 'postback',
          title: 'Location lookup',
          payload: 'LOCATION'
        }
          ]
        }
            
      ]
    },
  ]
  
}, access_token: ENV['ACCESS_TOKEN'])




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
        "content_type":"location",
        "payload":"LOCATION"}]})
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
    elsif postback.payload == 'LOCATION'
      message.reply(text :"Hey tu es à <USER_LOC>")
    else
      message.typing_off
    end
  end
end

Bot.on :postback do |postback|
  sender_id = postback.sender['id']
  case postback.payload
  when 'START' then show_replies_menu(postback.sender['id'], MENU_REPLIES)
  when 'COORDINATES'
    say(sender_id, IDIOMS[:ask_location], TYPE_LOCATION)
    show_coordinates(sender_id)
  when 'FULL_ADDRESS'
    say(sender_id, IDIOMS[:ask_location], TYPE_LOCATION)
    show_full_address(sender_id)
  when 'LOCATION'
    lookup_location(sender_id)
  end
end


def lookup_location(sender_id)
  say(sender_id, 'Let me know your location:', TYPE_LOCATION)
  Bot.on :message do |message|
    if message_contains_location?(message)
      handle_user_location(message)
    else
      message.reply(text: "Please try your request again and use 'Send location' button")
    end
    wait_for_any_input
  end
end

def message_contains_location?(message)
  if attachments = message.attachments
    attachments.first['type'] == 'location'
  else
    false
  end
end


def handle_user_location(message)
  coords = message.attachments.first['payload']['coordinates']
  lat = coords['lat']
  long = coords['long']
  message.type
  # make sure there is no space between lat and lng
  parsed = get_parsed_response(REVERSE_API_URL, "#{lat},#{long}")
  address = extract_full_address(parsed)
  message.reply(text: "Coordinates of your location: Latitude #{lat}, Longitude #{long}. Looks like you're at #{address}")
  wait_for_any_input
end

