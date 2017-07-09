class KeywordBotResponse
  def initialize(message, client)
    @message = message
    @client = client
    @tags = []
  end

  def reply
    key = keywords
    cxt = contexts
    nums = numbers
    Rails.logger.debug "Keywords: #{key.join(', ')}"
    Rails.logger.debug "Contexts: #{cxt.join(', ')}"
    Rails.logger.debug "Numbers: #{nums.join(', ')}"
    keyword = Keyword.order('length(text) desc')
                     .where(group: cxt.push(@client.context))
                     .where(text: key).sample

    return { text: 'What?' } unless keyword.present?
    @client.update_attributes(context: keyword.context)
    reply = keyword.reply
    reply = reply + "\n\n包含數值： #{nums.join(', ')}" unless nums.empty?
    {
      text: reply
    }
  end

  def keywords
    tagging = JiebaRb::Tagging.new
    @tags = tagging.tag(@message.text).reduce(&:merge)
    @tags.reject { |_, v| ['r'].include?(v) }.keys
  end

  def contexts
    vec = Word2Vec.new
    keywords.map { |word| vec.similar(word) }.flatten
  end

  def numbers
    @tags.select { |_, v| ['m', 'mq'].include?(v) }.keys.map { |m| ChineseNumber.extract(m) }
  end
end
