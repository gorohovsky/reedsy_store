RSpec::Matchers.define :be_a_bd do
  description { 'be a BigDecimal' }

  match do |actual|
    actual.instance_of? BigDecimal
  end
end
