module BitpayExt::Integration::Alipay
  class Verify < BitpayExt::Integration::Verify
    required_attrs %w(partner notify_id)

    attributes_alias :partner => :merchant_id

    default_value_for :gateway_url, "https://www.alipay.com/cooperate/gateway.do"

    def generated_params
      "service=notify_verify&partner=#{partner}&notify_id=#{notify_id}"
    end

    def url
      "#{gateway_url}?#{generated_params}"
    end

    def valid?
      Net::HTTP.get(URI(url)) =~ /true/
    end
  end
end
