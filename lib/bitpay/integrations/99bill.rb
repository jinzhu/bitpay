module BitpayExt::Integration::Bill99
  @@basename = '99bill'

  Dir[File.dirname(__FILE__) + '/99bill/*.rb'].each do |f|
    require f
  end
end
