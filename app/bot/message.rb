include Facebook::Messenger

Bot.on :message do |message|
  text = message.text
  if text.end_with?('？')
    reply = SuggestBotResponse.new(message).reply
  else
    reply = KeywordBotResponse.new(message).reply
  end
  message.reply(reply)
end
