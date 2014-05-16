require_relative "lamp"

module SignalLamp
  #
  # The primary interface of SignalLamp.  Mix this into an object, then use
  # the #lamp() method to reach any features provided by SignalLamp::Lamp.
  #
  module LampHolder
    #
    # Returns a memoized SignalLamp::Lamp instance that can be used to
    # SignalLamp::Lamp#signal() events and SignalLamp::Lamp#watch_for() events
    # related to the object this module is mixed into.
    #
    def lamp
      @lamp ||= SignalLamp::Lamp.new
    end
  end
end
