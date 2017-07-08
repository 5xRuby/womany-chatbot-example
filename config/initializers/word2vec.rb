begin
  require Rails.root.join('ext', 'distance').to_s
rescue LoadError
  raise 'You must to compile ./ext to enable word2vec'
end

class Word2Vec
  class << self
    def distance
      return @distance if @distance
      @distance = Distance.new
      @distance.open(Rails.root.join('lib', 'vector.bin').to_s)
      @disance
    end
  end

  def initialize
    @distance = self.class.distance
  end

  def similar(word)
    @distance.caliculate(word).force_encoding('UTF-8')&.split || []
  end
end

# Preload Word2Vec data
Word2Vec.distance
