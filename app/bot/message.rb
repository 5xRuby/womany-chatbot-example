include Facebook::Messenger

Bot.on :message do |message|
  text = message.text
  keyword = Keyword.where("? LIKE '%' || text || '%'", text)
                   .order('length(text) DESC').sample
  if keyword
    message.reply(text: keyword.reply)
  else
    message.reply(text: 'What?')
  end
end
