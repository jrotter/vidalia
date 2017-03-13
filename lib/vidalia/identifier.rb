module Vidalia

  class Identifier

    attr_reader :value
    @@max_id = 0

    def initialize
      @value = @@max_id
      @@max_id += 1
    end

    def ==(o)
      o.class == self.class and o.value == self.value
    end

    def >(o)
      o.class == self.class and self.value > o.value
    end

    def <(o)
      o.class == self.class and self.value < o.value
    end

  end

end
