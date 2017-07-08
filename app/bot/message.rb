include Facebook::Messenger

Bot.on :message do |message|
  text = message.text
  if text.end_with?('？')
    reply = SuggestBotResponse.new(message).reply
  else
    client = Client.find_or_create_by(uid: message.sender['id'])
    reply = KeywordBotResponse.new(message, client).reply
  end
  message.reply(reply)
end
