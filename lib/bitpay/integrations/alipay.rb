module BitpayExt::Integration
  class Alipay < Base
    basename 'alipay'

    required_attrs %w(service partner _input_charset sign_type sign out_trade_no subject payment_type)
    required_attrs [
                     ['seller_id','seller_account_name','seller_email'],
                     ['total_fee', ['price', 'quantity']]
                   ]

    attributes_alias :service => :pay_type, :partner => :merchant_id, :_input_charset => :input_charset, :out_trade_no => :order_id, :defaultbank => :default_bank, :exter_invoke_ip => :buyer_ip, :it_b_pay => :expire_date, :total_fee => :amount

    default_value_for :payment_type, 1
    default_value_for :sign_type, "MD5"
    default_value_for :input_charset, "utf-8"
    default_value_for :pay_type, "create_direct_pay_by_user"

    suggestion_attrs %w(notify_url return_url error_notify_url show_url merchant_param body)

    def generate_params
      available_attrs
    end

    def sign
      "FIXME"
    end
  end
end
