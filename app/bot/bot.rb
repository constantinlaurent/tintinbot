require 'facebook/messenger'
include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

def started 
  Bot.on :message do |message|
      if message.text.include? "Bonjour"
         message.reply(text: "Salut mon grand") 
     elsif message.text.include? "Bonne nuit"
          message.reply(text: "Allez bonne nuit toi") 
      else
          message.reply(text: 'Reponse par defaut')
      end
  end
end
