include Facebook::Messenger

Bot.on :message do |message|
  text = message.text
  if text.end_with?('？')
    suggest = Suggest.order('length(text) DESC')
                     .find_by("? LIKE '%' || text || '%'", text[0..-2])

    if suggest
      message.reply(
        text: '你想說的是？',
        quick_replies: QuickReply.new(suggest.options.split(','))
      )
    else
      message.reply(text: 'What?')
    end
  else
    keyword = Keyword.order('length(text) DESC')
                     .where("? LIKE '%' || text || '%'", text)
                     .sample

    if keyword
      message.reply(text: keyword.reply)
    else
      message.reply(text: 'What?')
    end
  end
end
