module BitpayExt::Integration::Alipay
  class Checkout < BitpayExt::Integration::Checkout
    required_attrs %w(service partner _input_charset sign_type out_trade_no subject payment_type)
    required_attrs [
                     ['seller_id','seller_account_name','seller_email'],
                     ['total_fee', ['price', 'quantity']]
                   ]

    attributes_alias :service => :pay_type, :partner => :merchant_id, :_input_charset => :input_charset, :out_trade_no => :order_id, :defaultbank => :default_bank, :exter_invoke_ip => :buyer_ip, :it_b_pay => :expire_date, :total_fee => :amount

    default_value_for :payment_type, 1
    default_value_for :sign_type, "MD5"
    default_value_for :input_charset, "utf-8"
    default_value_for :pay_type, "create_direct_pay_by_user"
    default_value_for :gateway_url, "https://www.alipay.com/cooperate/gateway.do"

    suggestion_attrs %w(notify_url return_url error_notify_url show_url merchant_param body)

    def generated_params_for_sign
      available_attrs(:skip => ['sign','sign_type']).sort.inject([]) do |s, a|
        s << "#{a}=#{URI.escape(send(a).to_s)}"
      end.join("&")
    end

    def generated_params
      generated_params_for_sign + "&sign_type=#{sign_type}&sign=#{sign}"
    end

    def checkout_url
      "#{gateway_url}?#{generated_params}"
    end

    def sign
      Digest::MD5.hexdigest(generated_params_for_sign + merchant_key)
    end
  end
end
