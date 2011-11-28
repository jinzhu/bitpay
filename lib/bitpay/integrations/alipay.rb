module BitpayExt::Integration::Alipay
  @@basename = 'alipay'

  Dir[File.dirname(__FILE__) + '/alipay/*.rb'].each do |f|
    require f
  end

  def self.generate_sign(obj, params=nil)
    params = Rack::Utils.parse_query(params) if params.is_a? String
    params.stringify_keys!

    params = (params.keys - ['sign','sign_type']).sort.inject([]) do |s, key|
      s << "#{key}=#{URI.escape(params[key].to_s)}"
    end.join("&")

    Digest::MD5.hexdigest(params + obj.merchant_key)
  end
end
