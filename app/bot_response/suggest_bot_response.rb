class SuggestBotResponse
  def initialize(message)
    @message = message
  end

  def reply
    suggest = Suggest.order('length(text) desc')
                     .find_by("? LIKE '%' || text || '%'", @message.text[0..-2])

    return { text: 'What?' } unless suggest.present?
    {
      text: '你想說的是？',
      quick_replies: QuickReply.new(suggest.options)
    }
  end
end
