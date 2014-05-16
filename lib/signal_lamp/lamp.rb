require "securerandom"

module SignalLamp
  class Lamp
    def initialize
      @watchers = { }
    end

    attr_reader :watchers
    private     :watchers

    def watch_for(event_matcher, identifier: generate_identifier, &event_handler)
      watchers[identifier] = [event_matcher, event_handler]
      identifier
    end

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

    def stop_watching(identifier)
      watchers.delete(identifier)
    end

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
