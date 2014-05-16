require_relative "spec_helper"

require_relative "../lib/signal_lamp/lamp_holder"

describe SignalLamp::LampHolder do
  let(:object) { Object.new }

  it "adds the lamp interface to any object" do
    expect(object.respond_to?(:lamp)).not_to be_true
    object.extend(SignalLamp::LampHolder)
    expect(object.respond_to?(:lamp)).to be_true
  end

  it "always returns the same lamp attached to an object" do
    object.extend(SignalLamp::LampHolder)
    expect(object.lamp).to be(object.lamp)
  end
end
