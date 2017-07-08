class KeywordBotResponse
  def initialize(message, client)
    @message = message
    @client = client
  end

  def reply
    keyword = Keyword.order('length(text) desc')
                     .where(group: @client.context)
                     .find_by("? like '%' || text || '%'", @message.text)

    return { text: 'What?' } unless keyword.present?
    @client.update_attributes(context: keyword.context)
    {
      text: keyword.reply
    }
  end
end
