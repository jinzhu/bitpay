$LOAD_PATH << File.dirname(__FILE__)

require "bitpay/engine" if  Object.const_defined?('Rails')

module BitpayExt
  module Integration
    # Load Base
    autoload :Base, "bitpay/integration"

    Dir[File.dirname(__FILE__) + '/integrations/*.rb'].each do |f|
      klass = File.basename(f, '.rb').gsub(/(?:^|_)(.)/) { $1.upcase }.to_sym
      autoload klass, f
    end
  end
end

class Bitpay
end
