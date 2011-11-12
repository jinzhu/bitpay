module BitpayExt
  module Integration
    # Load Base
    autoload :Base, "bitpay/integration"

    Dir[File.dirname(__FILE__) + '/bitpay/integrations/*.rb'].each do |f|
      klass = File.basename(f, '.rb').gsub(/(?:^|_)(.)/) { $1.upcase }.to_sym
      autoload klass, f
    end
  end

  def self.log(str)
    puts str
    Rails.logger.debug str
  end

  def self.load_config(obj)
    name   = obj.class.basename
    config = File.join(Rails.root, 'config/bitpay.yml')
    File.exist?(config) ? (YAML.load_file(config).with_indifferent_access[name] || {}) : {}
  end
end
