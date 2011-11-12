module BitpayExt
  module Integration
    # Load Base
    autoload :Base, "bitpay/integration"

    Dir[File.dirname(__FILE__) + '/bitpay/integrations/*.rb'].each do |f|
      klass = File.basename(f, '.rb').gsub(/(?:^|_)(.)/) { $1.upcase }.to_sym
      puts klass
      puts f
      autoload klass, f
    end
  end

  def self.log(str)
    puts str
    Rails.logger.debug str
  end
end
