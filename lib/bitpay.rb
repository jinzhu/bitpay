$LOAD_PATH << File.dirname(__FILE__)

require "bitpay_ext"
require "bitpay/engine"
require 'uri'

class Bitpay
  def self.const(method_name, name, options)
    const      = BitpayExt::Integration::Base.get_const_with_name(name)
    const.try(:const_get, method_name.to_sym).try(:new, options)
  rescue
    puts $!
    puts "ERROR: seems #{name} doesn't support #{method_name}!"
    false
  end

  %w(Checkout Return Notification Verify Refund).map do |method|
    class_eval <<-RUBY
       def self.#{method} name, options={}
         const("#{method}", name, options)
       end
    RUBY
  end
end
