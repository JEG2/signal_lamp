require "securerandom"

module SignalLamp
  #
  # A Lamp keeps track of the watchers waiting for events and allows events to
  # be signaled to those watchers.  The primary methods used for this are
  # #watch_for() and #signal().
  #
  class Lamp
    #
    # It's not common to construct these objects directly.  Instead, most code
    # should use the SignalLamp::LampHolder mix-in.
    #
    def initialize
      @watchers = { }
    end

    attr_reader :watchers
    private     :watchers

    #
    # This is the primary interface for watching for events to occur.
    #
    # The +event_matcher+ parameter will be tested against signaled event names
    # using the <tt>===</tt> operator.  This allows you to match a +String+
    # directly, use a +Regexp+ to wildcard various event types (I recommend
    # naming events with words separated by colons because these are easy to
    # match), or a +Proc+ that uses any kind of logic to select events.  For
    # example, you could match all events signaled on this object with
    # <tt>->(event_name) { true }</tt>.
    #
    # You only need to worry about passing an +identifier+ if you want to later
    # stop watching for the events you will pick up with this call.  Alternately
    # you can save the generated +identifier+ returned from this call and later
    # feed that to #stop_watching().  Any Ruby object that can be used as a
    # +Hash+ key is a valid +identifier+.  By default, a UUID +String+ will be
    # generated.
    #
    # The block passed to this call is the code that will actually be invoked
    # when an event is signaled and the name is matched.  The block will be
    # passed the matched event name (useful with dynamic matchers that could
    # select various events) followed by all arguments passed to #signal() for
    # the event.
    #
    def watch_for(event_matcher, identifier: generate_identifier, &event_handler)
      watchers[identifier] = [event_matcher, event_handler]
      identifier
    end

    #
    # This is a shortcut used to create a #watch_for() call that will only
    # trigger for one event.  After the block is called the first time,
    # #stop_watching() is automatically called.
    #
    def watch_for_one(event_matcher, &event_handler)
      identifier = generate_identifier
      watch_for(event_matcher, identifier: identifier) do |*event_args|
        begin
          event_handler.call(*event_args)
        ensure
          stop_watching(identifier)
        end
      end
    end

    #
    # Given an +identifier+ passed to or returned from a previous call to
    # #watch_for(), this method will stop that code from being invoked for any
    # future events.
    #
    def stop_watching(identifier)
      watchers.delete(identifier)
    end

    #
    # This method will invoke the block code of all previous calls to
    # #watch_for() that are still in effect and that match the passed
    # +event_name+.
    #
    # All other arguments passed to this method, assumed to be details related
    # to the event, are passed through to all blocks invoked for this event.
    #
    def signal(event_name, *event_details)
      watchers.each_value do |event_matcher, event_handler|
        if event_matcher === event_name
          event_handler.call(event_name, *event_details)
        end
      end
    end

    private

    def generate_identifier
      SecureRandom.uuid
    end
  end
end
