module BitpayExt::Integration
  class Base
    attr_accessor :options
    @@attributes_alias_list, @@required_attrs_list, @@default_value_list = {}, [], {}

    def initialize(opt={})
      self.options = opt.merge(BitpayExt.load_config(self)).with_indifferent_access
    end

    private
    def self.basename(name=nil)
      @@basename = name if name.present?
      @@basename
    end

    def self.define_attribute(attr)
      define_method(attr) do |&blk|
        default_value = @@default_value_list[attr]
        alias_attr = @@attributes_alias_list.select {|key,value| value.to_s == attr }
        alias_attr = (alias_attr && alias_attr[0]) || @@attributes_alias_list[attr]

        options[attr] || (default_value.is_a?(Proc) ? default_value.call : default_value) || self.send(alias_attr)
      end

      define_method("#{attr}=") do |value|
        self.options[attr] = value
        self.options = self.options.with_indifferent_access
      end
    end

    def self.required_attrs(*args)
      @@required_attrs_list.concat args
    end

    def self.default_value_for(method_sym,value=nil,&block)
      @@default_value_list[method_sym] = block_given? ? block : value
      @@default_value_list = @@default_value_list.with_indifferent_access
    end

    def self.attributes_alias(attrs)
      @@attributes_alias_list.update(attrs)
      @@attributes_alias_list = @@attributes_alias_list.with_indifferent_access

      attrs.map do |key, value|
        alias_method key.to_sym, value.to_sym
        alias_method "#{key}=".to_sym, "#{value}=".to_sym
      end
    end

    def method_missing(method_sym, *args, &block)
      BitpayExt.log "== Warning: #{self.class} haven't defined method `#{method_sym}`"
      options[method_sym]
    end

    public
    %w(
      subject body order_id order_date expire_date amount display_amount
      return_url notify_url error_notify_url show_url
      pay_type payment_type sign_type sign input_charset currency language version merchant_id merchant_key gate_id
      paymethod default_bank
      buyer_id buyer_account_name buyer_email buyer_phone buyer_mobile buyer_ip
      seller_id seller_account_name seller_email
    ).map do |attr|
      self.define_attribute(attr)
    end
  end
end
