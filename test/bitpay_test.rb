require 'test_helper'

class BitpayTest < ActiveSupport::TestCase
  test "Alipay integration" do
    pay = Bitpay::Checkout('alipay', subject: 'subject', amount: 100.00, order_id: '111111')

    assert pay.valid?, "checking Alipay valid or not"

    assert_equal pay.order_id, '111111', "checking assigned attribute"
    assert_equal pay.out_trade_no, '111111', "checking assigned attribute"

    assert_equal pay.input_charset, 'utf-8', "checking default attribute"
    assert_equal pay._input_charset, 'utf-8', "checking default attribute"

    assert_equal pay.amount, 100, "checking attribute alias"
    assert_equal pay.total_fee, 100, "checking attribute alias"

    assert_equal pay.generated_params, "_input_charset=utf-8&out_trade_no=111111&partner=2028009283416372&payment_type=1&seller_email=example@alipay.com&service=create_direct_pay_by_user&subject=subject&total_fee=100.0&sign_type=MD5&sign=f4fb4f435be219b8fe2dfd630a7636b4"
    assert_equal pay.checkout_url, "https://www.alipay.com/cooperate/gateway.do?_input_charset=utf-8&out_trade_no=111111&partner=2028009283416372&payment_type=1&seller_email=example@alipay.com&service=create_direct_pay_by_user&subject=subject&total_fee=100.0&sign_type=MD5&sign=f4fb4f435be219b8fe2dfd630a7636b4"
  end
end
