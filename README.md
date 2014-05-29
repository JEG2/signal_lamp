# Signal Lamp

A simple tool for decoupling Ruby object systems.

## Synopsis

```ruby
require "signal_lamp"  # Step 0:  load Signal Lamp

class Datum
  include SignalLamp::LampHolder  # Step 1:  include the event methods

  def initialize(value)
    @value = value
  end

  attr_reader :value

  def value=(new_value)
    old_value = @value
    @value    = new_value

    # Step 2:  signal events when interesting things happen
    lamp.signal("changed:value", self, old: old_value, new: new_value)
  end
end

class TotalWatcher
  def initialize
    @total = 0
  end

  attr_reader :total

  def watch(datum)
    record_value(datum.value)
    # Step 3:  watch for those events
    datum.lamp.watch_for("changed:value") do |_, _, details|
      record_value_change(details)
    end
  end

  private

  def record_value(value)
    @total += value
  end

  def record_value_change(old: , new: )
    record_value(new - old)
  end
end

ones = Datum.new(1)
tens = Datum.new(30)

#
# variation on the theme:
#
# 1. You don't have to use objects
# 2. You can watch for multiple event types at once
# 3. All signal arguments are passed through to the watcher
#
changed_event_regex = /\Achanged:/
[ones, tens].each do |datum|
  datum.lamp.watch_for(changed_event_regex) do |event, changed_datum, details|
    printf "%s's `%s' changed from %i to %i\n",
           changed_datum.object_id,
           event.sub(changed_event_regex, ""),
           details.fetch(:old),
           details.fetch(:new)
  end
end

# this hooks event signalers to watchers
watcher = TotalWatcher.new
watcher.watch(ones)
watcher.watch(tens)

# this signals events
ones.value += 1
tens.value += 10

# this shows that the objects communicated
watcher.total  # => 42
# >> 70302533065580's `value' changed from 1 to 2
# >> 70302533065560's `value' changed from 30 to 40
```

## Description

This library is pretty much a port of [the Events module in Backbone.js](http://backbonejs.org/#Events), with minor changes:

* The interface was made a little more Rubyish with the use of blocks, `===`, etc.
* All event methods were moved behind a prefix to minimize the impact on an object's API
* Simple identifiers are used to classify, and optionally remove, watcher to signaler relationships

In other words, this is a system for decoupling objects.  Some objects become "signalers" that tell anyone who is interested when "events" happen.  Other objects act as "watchers" waiting for and acting on those events.

This library has nothing to do with multiprocessing.  This is just a tool for managing object communication.

## Installation

Install the gem:

```
gem install signal_lamp
```

or add it to your `Gemfile`:

```ruby
gem "signal_lamp"
```

## Documentation

[Full public API documentation](http://rdoc.info/gems/signal_lamp/frames) is available online.

## Contributing

If you have grand ideas about cool new features that could be added to Signal Lamp, I'm probably not interested.  Sorry.  I very much want this library to stay a simple tool that is easy to fully understand.

Of course, I'm very interested in fixing any bugs or other problems with this code.  [Please do send those along.](https://github.com/JEG2/signal_lamp/issues)

If you're unsure, [feel free to create an issue](https://github.com/JEG2/signal_lamp/issues).  I'm happy to discuss it with you.  Just don't get too mad if I pass.  You are always welcome to release extensions to Signal Lamp as add-on gems.

## Author

Signal Lamp was coded up by James Edward Gray II (JEG2).
