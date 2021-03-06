module BitpayExt::Integration
  class Base
    attr_accessor :options, :raw_options
    class_attribute :attributes_alias_list, :required_attrs_list, :suggestion_attrs_list, :default_value_list
    self.attributes_alias_list, self.required_attrs_list, self.suggestion_attrs_list, self.default_value_list = {}, [], [], {}
    @@basename = nil

    def initialize(opt={})
      self.raw_options = opt
      opt              = Rack::Utils.parse_query(opt) if opt.is_a? String
      default_opt      = {:test_mode => false}
      name             = self.class.parent.class_variable_get("@@basename")
      opt              = default_opt.merge(BitpayExt.load_config(name).merge(opt))
      self.options     = opt.with_indifferent_access
    end

    private
    def self.get_const_with_name(name)
      BitpayExt::Integration.constants.select do |x|
        const = BitpayExt::Integration.const_get(x)
        return const if const.class_variable_get("@@basename").to_s.downcase == name.to_s.downcase
      end
      nil
    end

    def self.define_attribute(attr)
      define_method(attr) do
        default_value = self.default_value_list[attr]
        alias_attr = self.attributes_alias_list.select {|key,value| value.to_s == attr.to_s }
        alias_attr = (alias_attr && alias_attr.keys[0]) || self.attributes_alias_list[attr]

        options[attr] || (alias_attr.blank? ? nil : options[alias_attr]) || (default_value.is_a?(Proc) ? default_value.call : default_value)
      end

      define_method("#{attr}=") do |value|
        self.options[attr] = value
        self.options = self.options.with_indifferent_access
      end
    end

    def self.required_attrs(attrs=[])
      self.required_attrs_list += attrs
    end

    def self.suggestion_attrs(attrs=[])
      self.suggestion_attrs_list += attrs
    end

    def self.default_value_for(method_sym,value=nil,&block)
      self.default_value_list[method_sym] = block_given? ? block : value
      self.default_value_list = self.default_value_list.with_indifferent_access
    end

    def self.attributes_alias(attrs={})
      self.attributes_alias_list = self.attributes_alias_list.merge(attrs).with_indifferent_access

      attrs.map do |key, value|
        alias_method key.to_sym, value.to_sym
        alias_method "#{key}=".to_sym, "#{value}=".to_sym
      end
      self.attributes_alias_list
    end

    def method_missing(method_sym, *args, &block)
      return self.class.parent.send(method_sym, self, *args) if self.class.parent.respond_to?(method_sym)

      BitpayExt.log "== Warning: #{self.class} haven't defined method `#{method_sym}`"
      options[method_sym]
    end

    public
    def errors
      required_attrs
      @errors.sort
    end

    def valid?
      errors.size == 0
    end

    def required_attrs
      @errors = []
      required_attrs_have_value = []
      self.class.required_attrs.map do |attr|
        if attr.is_a? String
          send(attr).present? ? (required_attrs_have_value << attr) : (@errors << "#{attr}: No value for required attribute")
        else attr.is_a? Array
          r_size = required_attrs_have_value.size
          attr.map do |att|
            required_attrs_have_value << att if att.is_a?(String) && send(att).present?
            required_attrs_have_value.concat att if att.is_a?(Array) && att.all? {|at| send(at).present? }
          end
          @errors << "#{attr}: No value for required attribute" unless required_attrs_have_value.size > r_size
        end
      end
      required_attrs_have_value
    end

    def suggestion_attrs
      self.class.suggestion_attrs_list + (options[:addition_attributes] || []) - (options[:ignore_attributes] || [])
    end

    def available_attrs(opt={})
      (required_attrs + suggestion_attrs - (opt[:skip] || [])).select {|x| send(x).present? }
    end
  end

  class Checkout < Base
    %w(
      subject body order_id order_date expire_date amount display_amount
      gateway_url return_url notify_url error_notify_url show_url
      pay_type payment_type sign_type sign input_charset currency language version merchant_id merchant_key gate_id
      price quantity paymethod default_bank merchant_param
      buyer_id buyer_account_name buyer_email buyer_phone buyer_mobile buyer_ip
      seller_id seller_account_name seller_email
    ).map do |attr|
      self.define_attribute(attr)
    end
  end

  class Return < Base
    %w(
      sign sign_type trade_id pay_type trade_status notify_id notify_time notify_type
      subject body order_id amount
      payment_type merchant_id merchant_key gate_id
      buyer_id buyer_account_name buyer_email
      seller_id seller_account_name seller_email
    ).map do |attr|
      self.define_attribute(attr)
    end
  end

  class Verify < Base
    %w(
      gateway_url merchant_id merchant_key notify_id
    ).map do |attr|
      self.define_attribute(attr)
    end
  end

  class Notification < Base
    %w(
      sign sign_type trade_id pay_type trade_status notify_id notify_time notify_type
      subject body order_id amount
      payment_type merchant_id merchant_key gate_id
      price quantity
      buyer_id buyer_account_name buyer_email
      seller_id seller_account_name seller_email
    ).map do |attr|
      self.define_attribute(attr)
    end
  end
end
