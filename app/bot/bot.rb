require 'facebook/messenger'
include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

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

  if message.text.include? "No"
    message.reply(text: "Wesh maggl") 
  else
    message.reply(text: "Je t'aime aussi")
  end
end