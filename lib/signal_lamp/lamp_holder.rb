require_relative "lamp"

module SignalLamp
  module LampHolder
    def lamp
      @lamp ||= SignalLamp::Lamp.new
    end
  end
end
