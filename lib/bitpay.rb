$LOAD_PATH << File.dirname(__FILE__)

require "bitpay_ext"
require "bitpay/engine"
require 'uri'

class Bitpay
  attr_accessor :options, :name

  def initialize(name=nil, opt={})
    self.name, self.options = name, opt
    const
  end

  def const
    const      = BitpayExt::Integration::Base.get_const_with_name(name)
    class_name = Bitpay::Checkout.name.sub(/^#{Bitpay::Checkout.superclass.name}::/,'')
    const.try(:const_get, class_name.to_sym).try(:new, options)
  end

  class Checkout < Bitpay
    def initialize(name=nil, opt={})
      super
    end
  end

  class Return < Bitpay
    def initialize(name=nil, opt={})
      super
    end
  end

  class Notification < Bitpay
    def initialize(name=nil, opt={})
      super
    end
  end

  class Verify < Bitpay
    def initialize(name=nil, opt={})
      super
    end
  end

  class Refund < Bitpay
    def initialize(name=nil, opt={})
      super
    end
  end
end
