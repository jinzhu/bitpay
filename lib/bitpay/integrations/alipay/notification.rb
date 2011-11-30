module BitpayExt::Integration::Alipay
  class Notification < BitpayExt::Integration::Notification
    attributes_alias :out_trade_no => :order_id, :exterface => :pay_type, :trade_no => :trade_id, :total_fee => :amount

    def success?
      %w(TRADE_FINISHED TRADE_SUCCESS).include?(trade_status) && valid_sign?
    end

    def valid_sign?
      generate_sign(raw_options) == sign
    end

    def valid_and_success?
      success? && Bitpay::Verify('alipay', :notify_id => notify_id).valid?
    end
  end
end
