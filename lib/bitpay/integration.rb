module BitpayExt::Integration
  class Base
    attr_accessor :options
    @@required_attrs_list, @@default_value_list = [], {}

    def initialize(opt={})
      self.options = opt.with_indifferent_access
    end

    %w(
      subject body order_id order_date expire_date amount display_amount
      return_url notify_url error_notify_url show_url
      pay_type payment_type sign_type sign input_charset currency language version merchant_id merchant_key gate_id
      paymethod default_bank
      buyer_id buyer_account_name buyer_email buyer_phone buyer_mobile buyer_ip
      seller_id seller_account_name seller_email
    ).map do |attr|
      define_method(attr) do |&blk|
        default_value = @@default_value_list[attr]
        options[attr] || (default_value.is_a?(Proc) ? default_value.call : default_value)
      end
    end

    private
    def self.required_attrs(*args)
      @@required_attrs_list.concat args
      @@required_attrs_list = @@required_attrs_list.with_indifferent_access
    end

    def self.default_value_for(method_sym,value=nil,&block)
      @@default_value_list[method_sym] = block_given? ? block : value
      @@default_value_list = @@default_value_list.with_indifferent_access
    end

    def self.attributes_alias

    end

    def method_missing(method_sym, *args, &block)
      BitpayExt.log "== Warning: #{self.class} haven't defined method #{method_sym}"
      options[method_sym]
    end
  end
end
