module BitpayExt::Integration::Bill99
  class Checkout < BitpayExt::Integration::Checkout
    required_attrs %w(merchant_id orderid amount isSupportDES mac)

    attributes_alias :orderid => :order_id, :merchant_url => :return_url, :pname => :buyer_account_name, :commodity_info => :body, :pemail => :buyer_email, :mac => :sign

    suggestion_attrs %w(currency merchant_url pname commodity_info pemail pid merchant_param)

    default_value_for :currency, 1
    default_value_for :isSupportDES, 2
    default_value_for :gateway_url, "https://www.99bill.com/webapp/receiveMerchantInfoAction.do"

    def sign
      %(merchant_id orderid amount merchant_url merchant_key).map { |x| "#{x}=#{send(x)}" }.join('&').upcase
    end

    def generated_params_for_sign
      available_attrs(:skip => ['isSupportDES','mac']).sort.inject([]) do |s, a|
        s << "#{a}=#{URI.escape(send(a).to_s)}"
      end.join("&")
    end

    def generated_params
      generated_params_for_sign + "&isSupportDES=#{isSupportDES}&mac=#{mac}"
    end

    def checkout_url
      "#{gateway_url}?#{generated_params}"
    end
  end
end
