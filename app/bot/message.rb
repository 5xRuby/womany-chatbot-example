include Facebook::Messenger

Bot.on :message do |message|
  text = message.text
  keyword = Keyword.find_by('text LIKE ?', "%#{text}%")
  if keyword
    message.reply(text: keyword.reply)
  else
    message.reply(text: 'What?')
  end
end
