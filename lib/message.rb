module SmsSender

  class Message

    attr_accessor :text, :telephone, :type, :from

    def initialize telephone, text, type = nil, from = nil
      @text = text
      @telephone = normalized_telephone telephone
      @type = type
      @from = from
    end

    def == other
      ((other.text || "") == self.text) && ((other.telephone || "") == self.telephone)
    end

    def to_s
      "#{@telephone} - #{@text}"
    end

    private

    def normalized_telephone telephone
      telephone.gsub(/[^\d]/, "")
    end

  end

end
