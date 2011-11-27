require 'digest/md5'
require 'active_support/core_ext/hash/indifferent_access'

module BitpayExt
  module Integration
    # Load Base
    require "bitpay/integration"

    Dir[File.dirname(__FILE__) + '/bitpay/integrations/*.rb'].each do |f|
      require f
    end
  end

  def self.log(str)
    puts str
    Rails.logger.debug str
  end

  def self.load_config(name)
    config = File.join(Rails.root, 'config/bitpay.yml')
    File.exist?(config) ? (YAML.load_file(config).with_indifferent_access[name] || {}) : {}
  end
end
