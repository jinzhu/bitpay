$LOAD_PATH << File.dirname(__FILE__)

require "bitpay_ext"
require "bitpay/engine"
require 'uri'

class Bitpay
  attr_accessor :options, :name

  def initialize(name=nil, opt=nil)
    self.name, self.options = name, opt
  end

  class Checkout < Bitpay
    def initialize(name=nil, opt=nil)
      super
    end
  end

  class Return < Bitpay
    def initialize(name=nil, opt=nil)
      super
    end
  end

  class Notification < Bitpay
    def initialize(name=nil, opt=nil)
      super
    end
  end

  class Verify < Bitpay
    def initialize(name=nil, opt=nil)
      super
    end
  end

  class Refund < Bitpay
    def initialize(name=nil, opt=nil)
      super
    end
  end
end
