module BitpayExt::Integration::Alipay
  @@basename = 'alipay'

  Dir[File.dirname(__FILE__) + '/alipay/*.rb'].each do |f|
    require f
  end
end
