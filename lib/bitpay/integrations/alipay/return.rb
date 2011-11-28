module BitpayExt::Integration::Alipay
  class Return < BitpayExt::Integration::Return
    attributes_alias :out_trade_no => :order_id, :exterface => :pay_type, :trade_no => :trade_id, :total_fee => :amount

    def success?
      %w(TRADE_FINISHED TRADE_SUCCESS).include?(trade_status) && valid?
    end

    def valid?
      generate_sign(raw_options) == sign
    end
  end
end
