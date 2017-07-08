class KeywordBotResponse
  def initialize(message)
    @message = message
  end

  def reply
    keyword = Keyword.order('length(text) desc')
                     .find_by("? like '%' || text || '%'", @message.text)

    return { text: 'What?' } unless keyword.present?
    {
      text: keyword.reply
    }
  end
end
