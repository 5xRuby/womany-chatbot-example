class KeywordBotResponse
  def initialize(message, client)
    @message = message
    @client = client
  end

  def reply
    key = keywords
    cxt = contexts
    Rails.logger.debug "Keywords: #{key.join(',')}"
    Rails.logger.debug "Contexts: #{cxt.join(',')}"
    keyword = Keyword.order('length(text) desc')
                     .where(group: cxt.push(@client.context))
                     .where(text: key).sample

    return { text: 'What?' } unless keyword.present?
    @client.update_attributes(context: keyword.context)
    {
      text: keyword.reply
    }
  end

  def keywords
    tagging = JiebaRb::Tagging.new
    tagging.tag(@message.text).reduce(&:merge).reject { |_, v| ['r'].include?(v) }.keys
  end

  def contexts
    vec = Word2Vec.new
    keywords.map { |word| vec.similar(word) }.flatten
  end
end
