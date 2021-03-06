# encoding:utf-8
require 'test_helper'

class BitpayTest < ActiveSupport::TestCase
  test "Alipay Checkout" do
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

  test "Alipay Return" do
    pay = Bitpay::Return('alipay', "is_success=T&sign=1396ebe013dcc710543263d421108390&sign_type=MD5&body=Hello&buyer_email=xinjie_xj%40163.com&buyer_id=2088101000082594&exterface=create_direct_pay_by_user&out_trade_no=6402757654153618&payment_type=1&seller_email=chao.chenc1%40alipay.com&seller_id=2088002007018916&subject=%E5%A4%96%E9%83%A8FP&total_fee=10.00&trade_no=2008102303210710&trade_status=TRADE_FINISHED&notify_id=RqPnCoPT3K9%252Fvwbh3I%252BODmZS9o4qChHwPWbaS7UMBJpUnBJlzg42y9A8gQlzU6m3fOhG&notify_time=2008-10-23+13%3A17%3A39&notify_type=trade_status_sync&extra_common_param=%E4%BD%A0%E5%A5%BD%EF%BC%8C%E8%BF%99%E6%98%AF%E6%B5%8B%E8%AF%95%E5%95%86%E6%88%B7%E7%9A%84%E5%B9%BF%E5%91%8A%E3%80%82")

    assert_equal pay.order_id, '6402757654153618'
    assert_equal pay.out_trade_no, '6402757654153618'

    assert_equal pay.subject, "外部FP"
    assert_equal pay.amount, '10.00' #FIXME

    assert_equal pay.pay_type, 'create_direct_pay_by_user'

		assert_equal "1396ebe013dcc710543263d421108390", pay.generate_sign(pay.raw_options)
		assert pay.success?
  end

  test "Alipay Notification" do
		pay = Bitpay::Notification('alipay', "trade_no=2008102203208746&out_trade_no=3618810634349901&discount=-5&payment_type=1&subject=iloveandroid&body=Hello&price=10.00&quantity=1&total_fee=10.00&trade_status=TRADE_FINISHED&refund_status=REFUND_SUCCESS&seller_email=chao.chenc1%40alipay.com&seller_id=2088002007018916&buyer_id=2088002007013600&buyer_email=13758698870&gmt_create=2008-10-22+20%3A49%3A31&is_total_fee_adjust=N&gmt_payment=2008-10-22+20%3A49%3A50&gmt_close=2008-10-22+20%3A49%3A46&gmt_refund=2008-10-29+19%3A38%3A25&use_coupon=N&notify_time=2009-08-12+11%3A08%3A32&notify_type=%E4%BA%A4%E6%98%93%E7%8A%B6%E6%80%81%E5%90%8C%E6%AD%A5%E9%80%9A%E7%9F%A5%28trade_status_sync%29&notify_id=70fec0c2730b27528665af4517c27b95&sign_type=MD5&sign=205cc4b392447f1ae8d3b8b576b388a4&extra_common_param=%E4%BD%A0%E5%A5%BD%EF%BC%8C%E8%BF%99%E6%98%AF%E6%B5%8B%E8%AF%95%E5%95%86%E6%88%B7%E7%9A%84%E5%B9%BF%E5%91%8A%E3%80%82")

    assert_equal pay.order_id, '3618810634349901'
    assert_equal pay.out_trade_no, '3618810634349901'

    assert_equal pay.subject, "iloveandroid"
    assert_equal pay.body, 		"Hello"
    assert_equal pay.amount, 	"10.00" #FIXME

		assert_equal "205cc4b392447f1ae8d3b8b576b388a4", pay.generate_sign(pay.raw_options)
		assert pay.success?
	end

  test "Alipay Verify" do
    pay = Bitpay::Verify('alipay', :notify_id => "RqPnCoPT3K9%252Fvwbh3I%252BFioE227%252BPfNMl8jwyZqMIiXQWxhOCmQ5MQO%252FWd93rvCB%252BaiGg")

    assert_equal pay.url, "https://www.alipay.com/cooperate/gateway.do?service=notify_verify&partner=2028009283416372&notify_id=RqPnCoPT3K9%252Fvwbh3I%252BFioE227%252BPfNMl8jwyZqMIiXQWxhOCmQ5MQO%252FWd93rvCB%252BaiGg"
	end
end
