![RQM logo](http://ir_wp.s3.amazonaws.com/wp-content/uploads/sites/9/2013/07/rmq_logo.png)

# RubyMotionQuery - RMQ
A fast, muggle, nonpolluting, zero-dependency, jQuery-like library for [RubyMotion](http://rubymotion.com).

**The [RMQ Introductory Guide and other info][1] is a great place to start.**

[![Dependency Status](https://gemnasium.com/infinitered/rmq.png)](https://gemnasium.com/infinitered/rmq)
[![Build Status](https://travis-ci.org/infinitered/rmq.png?branch=master)](https://travis-ci.org/infinitered/rmq)
[![Gem Version](https://badge.fury.io/rb/ruby_motion_query.png)](http://badge.fury.io/rb/ruby_motion_query)
[![Crusher.io optimized](http://www.crusher.io/repo/infinitered/rmq/badge)](http://www.crusher.io/repo/infinitered/rmq)


## General

### Some of the very cool features:
 - **selecting** (*querying*) views
 - **traversal** through view hierarchy (moving around the tree)
 - tagging
 - **events and gestures**
 - animations
 - **stylers and stylesheets**
 - colors
 - fonts
 - image utilities
 - app
 - device

----------

**Tested on iOS, not OS X (nor is there any OS X specific code)**

----------

### Other wrapper libraries
There are a lot of great wrappers out there such as Teacup and Sugarcube. I've used these and I enjoy them. However, many of the wrappers heavily pollute the standard classes, which is great if you like that sort of thing. RMQ is designed to have minimal pollution, to be very simple and high performance (it will be when it's done). RMQ shouldn't conflict with anything.

RMQ **doesn't require any** other wrapper or gem.

> If you preferred jQuery over Prototype, you'll love RMQ.

Some of the code in RMQ came from BubbleWrap and Sugarcube. Not too much but some did. I thank you BubbleWrap and Sugarcube teams for your work.

## Quick Start

```
gem install ruby_motion_query
rmq create my_app
cd my_app
bundle
rake
```

Or, if you use **rbenv**:

```
gem install ruby_motion_query
rmq create my_app
rbenv rehash
cd my_app
bundle
rake
```


## Installation

RMQ **requires no other gems**. If you use stuff like **scale** and certain animations it will require some frameworks (like QuartzCore or CoreGraphics)

- `gem install ruby_motion_query`

If you use rbenv

- `rbenv rehash`

Require it

- `require 'ruby_motion_query'`

or add it to your `Gemfile`:

- `gem 'ruby_motion_query'`

for **bleeding edge**, add this to your `Gemfile`:

- `gem 'ruby_motion_query', :git => 'git@github.com:infinitered/rmq.git'`


## Deprecation

- **UIView#rmq_did_create(self_in_rmq)** - *Use rmq_build instead*


## Usage

### Example App
*Clone this repo and run the example app to see an example of use.*

	git clone git@github.com:infinitered/rmq.git
	cd rmq
	rake

The example app works in any orientation, on both iPhone and iPad. Notice how the benchmark popup is done with RMQ, then think about how you'd do that without it.

### What's an rmq instance?

 - an rmq instance is an array-like object containing UIViews
 - rmq() never returns nil. If nothing is selected, it's an empty [ ] array-like
   object
 - an rmq object always (almost always) returns either itself or a new
   rmq object. This is  how chaining works. You do not need to worry if
   an rmq is blank or not, everything  always works without throwing a
   nil exception
 - jQuery uses the DOM, what is rmq using for the "DOM"? It uses the
   controller it was  called in. The "DOM" is the controller's subview
   tree. If you call rmq inside a view, it will  attach to the
   controller that the view is currently in or to the current screen's
   controller

### Basic syntax

The main command is `rmq` and you use it everywhere. You can rename this by aliasing the methods in `ext.rb`.

```ruby
# Like jQuery you wrap your objects or selectors in a rmq(), here are some examples
rmq(my_view).show
rmq(UILabel).hide

# You can use zero or more selectors, all these are valid
rmq(my_view, UILabel).hide
rmq(:a_tag, :a_style_name, UIImageView).hide
rmq(hidden: true).show

# If you use a set of selectors, they are an "or", to do an "and" use .and
rmq(UIImageView).and(hidden: true).show
```

**rmq by itself is the rmq instance of the current UIViewController if you're inside a UIViewController**.

If you're inside a UIView you've created, `rmq.closest(UIControl)` is the same as `rmq(self).closest(UIControl)`.

#### rmq is always an array-like object (enumerablish), never nil, etc:

Because of this, you **never have to check** if your selectors return anything before calling actions or other methods on your rmq object.

```ruby
# This will hide any UILabel in the controller, if any exist. If not, nothing happens
rmq(UILabel).hide

# Because of this, you can create chains without worry of exceptions
rmq(:this_tag_does_not_exist).show.apply_style(:my_style_name).on(:touch_down){puts 'score!'}
```

#### Almost all methods of an rmq object return either itself or another rmq object, so you can chain:
```ruby
rmq.append(UILabel, :label_style).on(:tap){|sender,event| sender.hide}

# or

rmq.closest(AddEntry).find(:delete_button).hide
rmq(AddEntry).find(UILabel).blink

```

If you want the actual inner object(s), use **.get**

```ruby
# returns my_view
rmq(my_view).get

# returns an array
rmq(UILabel).get
```

### Command-line Tool

RMQ provides a command-line tool, mostly for generating files:
```
> rmq create my_app
```

Here are the commands available to you:
```
 > rmq api
 > rmq docs

 > rmq create my_new_app
 > rmq create model foo
 > rmq create controller bar
 > rmq create view foo_bar
 > rmq create shared some_class_used_app_wide
 > rmq create lib some_class_used_by_multiple_apps

 > rmq create collection_view_controller foos

 # To test the create command without actually creating any files, do:
 > rmq create view my_view dry_run

 > rmq help
```



### Selectors

 - Constant
 - :a_tag
 - :a_style_name
 - my_view_instance
 - text: 'you can select via attributes also'
 - :another_tag, UILabel, text: 'an array' <- this is an "or", use .and for and

### Traversing

 - all
 - and
 - not
 - and_self
 - back  - rmq(test_view).find(UIImageView).tag(:foo).back.find(UILabel).tag(:bar) 
 - find
 - children
 - siblings
 - next
 - prev
 - closest
 - parent
 - parents
 - filter
 - view_controller
 - root_view # View of the view_controller
 - window # Window of the root_view


### Enumerablish
A rmq object is like an enumerable, but each method returns a rmq object instead of a enumerable. For example, these methods:

 - each
 - map
 - select
 - grep
 - detect
 - inject
 - first
 - last
 - []
 - <<
 - *etc*

all return another rmq instance, so you can chain.

You can also do **rmq.length** and **rmq[0]** like an array

**.to_a** gives you an actual array, so will **.get** (this is preferred)

### Events and Gestures

#### On / Off

To add an event, use .on, to remove it it, use .off

```ruby
# Simple example
rmq(UIView).on(:tap){|sender| rmq(sender).hide}

# Adding an Event during creation
view_q = rmq.append(UIView).on(:tap) do |sender, event|
	# do something here
end

# removing an Event
view_q.off(:tap)

# or you remove them all
view_q.off

# like everything in RMQ, this works on all items selected
rmq(UIView).off(:tap)
```

#### RubyMotionQuery::Event

In RMQ events and gestures are normalized with the same API. For example removing events or gestures is foo.off, and the appropriate thing happens.

If you see Event, just remember that's either an event or gesture. I decided to call them Events

##### Type of events and gestures
```ruby
# Events on controls
:touch
:touch_up
:touch_down
:touch_start
:touch_stop
:change

:touch_down_repeat
:touch_drag_inside
:touch_drag_outside
:touch_drag_enter
:touch_drag_exit
:touch_up_inside
:touch_up_outside
:touch_cancel

:value_changed

:editing_did_begin
:editing_changed
:editing_did_change
:editing_did_end
:editing_did_endonexit

:all_touch
:all_editing

:application
:system
:all

# Gestures
:tap
:pinch
:rotate
:swipe
:pan
:long_press
```

##### Interesting methods of an RubyMotionQuery::Event:
```ruby
foo.sender
foo.event

foo.gesture?
foo.recognizer
foo.gesture

foo.location
foo.location_in

foo.sdk_event_or_recognizer
```

TODO, need many examples here

#### RubyMotionQuery::Events

The internal store of events in a UIView. It's rmq.events, you won't use it too often

### Tags

```ruby
# Add tags
rmq(my_view).tag(:your_tag)
rmq(my_view).clear_tags.tag(:your_new_tag)

rmq(my_view).find(UILabel).tag(:selected, :customer)

# You can optionally store a value in the tag, which can be super useful in some rare situations
rmq(my_view).tag(your_tag: 22)
rmq(my_view).tag(your_tag: 22, your_other_tag: 'Hello world')


# You can use a tag or tags as selecors
rmq(:selected).hide
rmq(:your_tag).and(:selected).hide

# Get tags for a view
your_view.rmq_data.tags
# Also
your_view.rmq_data.has_tag?(:foo)
your_view.rmq_data.tag_names
```

### Actions
```ruby
rmq(UILabel).attr(text: 'Foo bar')
rmq(UILabel).send(:some_method, args)
rmq(my_view).hide
rmq(my_view).show
rmq(my_view).toggle
rmq(my_view).toggle_enabled
rmq(my_text_field).focus # or .become_first_responder
```

### Subviews - appending, creating, etc

```ruby
rmq.append(UILabel) # Creates a UILabel in the current controller
rmq.append(UILabel, :my_label_style)
rmq.append(UILabel.alloc.initWithFrame([[0,0],[10,10]]), :my_label_style)

rmq(my_view).append(UIButton)
rmq(my_view).remove
rmq(my_vuew).children.remove

rmq(UIView).append(UIButton, :delete_me) # A custom button for all views

rmq.unshift(UILabel) # Adds to index 0 of the subviews
rmq.unshift(UILabel, :my_style)
rmq.insert(UILabel, at_index: 2)
rmq.insert(UILabel, at_index: 2, style: :my_style)
rmq.insert(UILabel, below_view: some_view_of_mine)
rmq.insert(UILabel, below_view: some_view_of_mine, style: :my_style)

rmq(my_view).parent  # .superview works too
rmq(my_view).parents # all parents up the tree, up to the root
rmq(my_view).children
rmq(my_view).find # children, grandchildren, etc
rmq.root_view
rmq.view_controller
```

#### Create a view
If you want to create a view but not add it to the subviews of any other view, you can
use #create. It's basically #append without the actual appending.
This is very handy for stuff like table cells:

```ruby
# In your controller that is a delegate for a UITableView
def tableView(table_view, cellForRowAtIndexPath: index_path)
  cell = table_view.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER) || begin
    rmq.create(StoreCell, :store_cell, cell_identifier: CELL_IDENTIFIER).get
  end
end

# Your cell
class StoreCell < UITableViewCell
  def rmq_build
    rmq(self).append(UILabel, :title_label) # <- this works even though this object isn't in a controller
  end
end
```

### Animate

```ruby
rmq(my_view).animate(
  duration: 0.3,
  animations: lambda{|q|
    q.move left: 20
  }
)
```

```ruby
# As an example, this is the implementation of .animations.throb
rmq(selectors).animate(
  duration: 0.1,
  animations: -> (q) {
    q.style {|st| st.scale = 1.1}
  },
  completion: -> (did_finish, q) {
    q.animate(
      duration: 0.4,
      animations: -> (cq) {
        cq.style {|st| st.scale = 1.0}
      }
    )
  }
)

# You can pass any options that animateWithDuration allows: options: YOUR_OPTIONS
```

### Animations

#### Current animations included:

```ruby
rmq(my_view).animations.fade_in
rmq(my_view).animations.fade_in(duration: 0.8)
rmq(my_view).animations.fade_out
rmq(my_view).animations.fade_out(duration: 0.8)

rmq(my_view).animations.blink
rmq(my_view).animations.throb
rmq(my_view).animations.drop_and_spin

rmq.animations.start_spinner
rmq.animations.stop_spinner
```

### Color

```ruby
rmq.color.red
rmq.color.from_hex('#ffffff')
rmq.color.from_hex('ffffff')
rmq.color.from_rgba(128, 128, 128, 0.5)

# Add a new standard color
rmq.color.add_named :pitch_black, '#000000'
# Or
rmq.color.add_named :pitch_black, rmq.color.black

# In a stylesheet you don't need the rmq
color.pitch_black
color.red
```

### Font

```ruby
rmq.font.system(12)
rmq.font_with_name('Helvetica', 18)
rmq.font.family_list # useful in console
rmq.font.for_family('Helvetica') # useful in console

# Add a new standard font
font_family = 'Helvetica Neue'
font.add_named :large,    font_family, 36
font.add_named :medium,   font_family, 24
font.add_named :small,    font_family, 18

# then use them like so
rmq.font.large
rmq.font.small

# In a stylesheet you don't need the rmq
font.medium
font.system(14)
```

### Position (moving, sizing, and nudging)

```ruby
# Move/Size changes size and origin of selected view(s)
rmq(your_view).move(l: 20)
rmq(your_view).move(left: 20)
rmq(your_view).move(l: 20, t: 20, w: 100, h: 50)
rmq(your_view).move(left: 20, top: 20, width: 100, height: 50)
rmq(your_view).size(left: 20, top: 20, width: 100, height: 50) # alias

# Nudge pushes them in a direction
rmq(your_view).nudge(d: 20)
rmq(your_view).nudge(down: 20)
rmq(your_view).nudge(l: 20, r: 20, u: 100, d: 50)
rmq(your_view).nudge(left: 20, right: 20, up: 100, down: 50)
```

### Images

```ruby
RubyMotionQuery::ImageUtils.resource('logo')
rmq.image.resource('logo')
rmq.image.resource('subfolder/foo')
rmq.image.resource_for_device('logo') # will look for 4inch or 3.5inch
rmq.image.resource('logo', cached: false)

rmq.image.resource_resizable('foo', left: 10, top: 10, right: 10, bottom: 10)

rmq.image.from_view(my_view)

# In a stylesheet you don't need the rmq
image.resource('logo')
```

### App
```ruby
RubyMotionQuery::App.window
rmq.app.window
rmq.app.delegate
rmq.app.environment
rmq.app.release? # .production? also
rmq.app.test?
rmq.app.development?
rmq.app.version
rmq.app.name
rmq.app.identifier
rmq.app.resource_path
rmq.app.document_path
```

### Device

```ruby
RubyMotionQuery::Device.screen
rmq.device.screen
rmq.device.width # screen width
rmq.device.height # screen height
rmq.device.ipad?
rmq.device.iphone?
rmq.device.four_inch?
rmq.device.retina?

# return values are :unknown, :portrait, :portrait_upside_down, :landscape_Left,
# :landscape_right, :face_up, :face_down
rmq.device.orientation
rmq.device.landscape?
rmq.device.portrait?
```

### Format
A performant way to format numbers and dates.

```ruby
rmq.format.number(1232, '#,##0.##')
rmq.format.date(Time.now, 'EEE, MMM d, ''yy')
rmq.format.numeric_formatter(your_format_here) # returns cached numeric formatter
rmq.format.date_formatter(your_format_here) # returns cached date formatter
```
See <http://www.unicode.org/reports/tr35/tr35-19.html#Date_Format_Patterns> for more information about date format strings.

### Utils

These are mostly used internally by rmq.

```ruby
RubyMotionQuery::RMQ.is_class?(foo)
RubyMotionQuery::RMQ.is_blank?(foo)
RubyMotionQuery::RMQ.controller_for_view(view)
RubyMotionQuery::RMQ.view_to_s(view)
RubyMotionQuery::RMQ.weak_ref(foo)
```

### Pollution

The following are the only pollution in RMQ

 - UIView
    - rmq
    - rmq_data
 - UIViewController
    - rmq
    - rmq_data
 - Object
    - rmq

### Console Fun

  rmq.log :tree
	rmq.all.log
	rmq.all.log :wide
	rmq(UIView).show
	rmq(UILabel).animations.blink
	rmq(UIButton).nudge l: 10

### A recommended project structure

 - app
   - controllers
     - your_controller.rb
     - your_other_controller.rb
   - models
   - shared
   - stylers
         - ui_view_styler.rb
         - ui_button_styler.rb
         - etc
   - stylesheets
     - application_stylesheet.rb (inherit from RubyMotionQuery::Stylesheet)
     - your_stylesheet.rb (inherit from ApplicationStylesheet)
     - your_other_stylesheet.rb (inherit from ApplicationStylesheet)
     - your_view_stylesheet.rb (module, included an any controller's stylesheet that needs it)
   - views
 - lib
 - resource
 - spec
   - controllers
   - lib
   - models
   - shared
   - stylers
   - views

### Debugging

Adding rmq_debug=true to rake turns on some debugging features that are too slow or verbose to include in a normal build.  It's great for normal use in the simulator, but you'll want to leave it off if you're measuring performance.
```
rake rmq_debug=true
```

Use this to add your optional debugging code
```ruby
rmq.debugging?
=> true
```

```ruby
rmq.log :tree
rmq.all.log
rmq.all.log :wide

rmq(Section).log :tree
# 163792144 is the ID a button
rmq(163792144).style{|st| st.background_color = rmq.color.blue}

rmq(Section).children.and_self.log :wide

rmq(UILabel).animations.blink

# Show subview index and thus zorder of Section within Section's parent
rmq(Section).parent.children.log
```

----------

### Styles and stylesheets

A very lightweight style system, designed for a low memory footprint, fast startup, and fast operation. Most everything is done at compile-time, as it's all just ruby code. Low magic.

**You don't have to use this system, you can use Teacup instead**, or whatever you like. RMQ works great without using the style system.

#### Example controller

```ruby
class MainController < UIViewController

  def viewDidLoad
    super

    rmq.stylesheet = MainControllerStyleSheet
    view.rmq.apply_style :root_view

    @title_label = rmq.append(UILabel, :title_label).get

    image_view = rmq.append(UIImageView).get
    # Apply style anywhere
    image_view.apply_style(:logo)

    rmq.append(UIButton, :make_labels_blink).on(:tap) do |sender|
      rmq(UILabel).animations.blink
    end

    rmq.append(UIButton.buttonWithType(UIButtonTypeRoundedRect), :make_buttons_throb).on(:tap) do |sender|
      rmq(UIButton).animations.throb
    end

    rmq.append(UIView, :section).tap do |section|
      section.append(UILabel, :section_title)

      section.append(UILabel, :section_enabled_title)

      section.append(UISwitch, :section_enabled).on(:change) do |sender|
        style = sender.isOn ? :section_button_enabled : :section_button_disabled
        buttons = sender.rmq.parent.find(UIButton).apply_style(style)
      end

      section.append(UIButton, :start_spinner).on(:tap) do |sender|
        rmq.animations.start_spinner
      end

      section.append(UIButton, :stop_spinner).on(:tap) do |sender|
        rmq.animations.stop_spinner
      end
    end

  end
end
```

#### Example stylesheet

```ruby
class ApplicationStylesheet < RubyMotionQuery::Stylesheet
  PADDING = 10

  def application_setup
    font_family = 'Helvetica Neue'
    font.add_named :large,    font_family, 36
    font.add_named :medium,   font_family, 24
    font.add_named :small,    font_family, 18

    color.add_named :translucent_black, color.from_rgba(0, 0, 0, 0.4)
    color.add_named :battleship_gray,   '#7F7F7F'
  end

  def label(st)
    st.background_color = color.clear
  end

end

class MainStylesheet < ApplicationStylesheet
  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def logo(st)
    st.frame = {t: 10, w: 200, h: 96}
    st.centered = :horizontal
    st.image = image.resource('logo')
  end

  def title_label(st)
    label st # stack styles
    st.frame = {l: PADDING, t: 120, w: 200, h: 20}
    st.text = 'Test label'
    st.color = color.from_rgba(34, 132, 198, 1.0)
    st.font = font.medium
  end

  def make_labels_blink(st)
    st.frame = {t: 120, w: 150, h: 20}
    st.from_right = PADDING

    # ipad? (and landscape?, etc) is just a convenience methods for
    # rmq.device.ipad?

    # Here is a complete example of different formatting for orientations
    # and devices
    #  if ipad?
    #    if landscape?
    #      st.frame = {l: 20, t: 120, w: 150, h: four_inch? ? 20 : 30}
    #    else
    #      st.frame = {l: 90, t: 120, w: 150, h: four_inch? ? 25 : 35}
    #    end
    #  else
    #    if landscape?
    #      st.frame = {l: 20, t: 20, w: 150, h: four_inch? ? 22 : 32}
    #    else
    #      st.frame = {l: 90, t: 20, w: 150, h: four_inch? ? 30 : 40}
    #    end
    #  end

    # If you don't want something to be reapplied during orientation
    # changes (assuming you're reapplying during orientation changes
    # in your controller, it's not automatic)
    unless st.view_has_been_styled?
      st.text = 'Blink labels'
      st.font = font.system(10)
      st.color = color.white
      st.background_color = color.from_hex('ed1160')
    end
  end

  def make_buttons_throb(st)
    st.frame = {t: 150, w: 150, h: 20}
    st.from_right = PADDING
    st.text = 'Throb buttons'
    st.color = color.black
  end

  def section(st)
    st.frame = {w: 270, h: 110}

    if landscape? && iphone?
      st.left = PADDING
    else
      st.centered = :horizontal
    end

    st.from_bottom = PADDING

    st.z_position = 1
    st.background_color = color.battleship_gray
  end

  def section_label(st)
    label st
    st.color = color.white
  end

  def section_title(st)
    section_label st
    st.frame = {l: PADDING, t: PADDING, w: 150, h: 20}
    st.text = 'Section title'
  end

  def section_enabled(st)
    label st
    st.frame = {l: PADDING, t: 30}
    st.on = true
  end

  def section_enabled_title(st)
    section_label st
    st.frame = {l: 93, t: 34, w: 150, h: 20}
    st.text = 'Enabled'
  end

  def section_buttons(st)
    st.frame = {l: PADDING, t: 64, w: 120, h: 40}
    st.background_color = color.black
    section_button_enabled st
  end

  def start_spinner(st)
    section_buttons st
    st.text = 'Start spinner'
  end

  def stop_spinner(st)
    section_buttons st
    st.from_right = PADDING
    st.text = 'Stop spinner'
  end

  def section_button_disabled(st)
    st.enabled = false
    st.color = color.dark_gray
  end

  def section_button_enabled(st)
    st.enabled = true
    st.color = color.white
  end

  def animate_move(st)
    st.scale = 1.0
    st.frame = {t: 180, w: 150, h: 20}
    st.from_right = PADDING
    st.text = 'Animate move and scale'
    st.font = font.system(10)
    st.color = color.white
    st.background_color = color.from_hex('ed1160')
    st.z_position = 99
    st.color = color.white
  end

  def overlay(st)
    st.frame = :full
    st.background_color = color.translucent_black
    st.hidden = true
    st.z_position = 99
  end

  def benchmarks_results_wrapper(st)
    st.hidden = true
    st.frame = {w: app_width - 20, h: 120}
    st.centered = :both
    st.background_color = color.white
    st.z_position = 100
  end

  def benchmarks_results_label(st)
    label st
    st.padded = {l: 10, t: 10, b:10, r: 10}
    st.text_alignment = :left
    st.color = color.black
    st.font = font.system(10)

    # If the styler doesn't have the method, you can add it or
    # just use st.view to get the actual object
    st.view.numberOfLines = 0
    st.view.lineBreakMode = NSLineBreakByWordWrapping
  end

  def run_benchmarks(st)
    st.frame = {l: PADDING, t: 150, w: 130, h: 20}
    st.text = 'Run benchmarks'
    st.font = font.system(11)
    st.color = color.white
    st.enabled = true
    st.background_color = color.from_hex('faa619')
  end

  def run_benchmarks_disabled(st)
    st.enabled = false
    st.color = color.from_hex('de8714')
  end

  def benchmark(st)
    st.hidden = false
    st.text = 'foo'
    st.color = color.white
    st.left = 10
  end

end
```

#### Stylers

A styler wraps around a view, augmenting it with styling power and sugar.

Each UIView subclass can have its own styler (many exist in RMQ, but not all *yet*). There is a UIViewStyler class they all inherit from, and a UIControlStyler controls inherit from. Much of the code is in UIViewStyler.

When you create a "style method", it will be passed the view, wrapped in a styler. You can get the view using st.view.

##### UIViewStyler
Here is a silly example, showing you a bunch of methods the UIViewStyler gives you:

```ruby
def ui_view_kitchen_sink(st)
  st.frame = {l: 1, t: 2, w: 3, h: 4}
  st.frame = {left: 1, top: 2, width: 3, height: 4}
  st.frame = {left: 10}
  st.left = 20
  st.top = 30
  st.width = 40
  st.height = 50
  st.right = 100
  st.bottom = 110
  st.from_right = 10
  st.from_bottom = 12
  st.padded = {l: 1, t: 2, r: 3, b: 4}
  st.padded = {left: 1, top: 2, right: 3, bottom: 4}
  st.center = st.superview.center
  st.center_x = 50
  st.center_y = 60
  st.centered = :horizontal
  st.centered = :vertical
  st.centered = :both

  st.enabled = true
  st.hidden = false
  st.z_position = 66
  st.opaque = false

  st.background_color = color.red

  st.scale = 1.5
  st.rotation = 45
end
```

##### UIControlStyler
	Nothing yet

##### UILabelStyler

```ruby
def ui_label_kitchen_sink(st)
  st.text = 'rmq is awesome'
  st.font = font.system(12)
  st.color = color.black
  st.text_alignment = :center

  st.resize_to_fit_text
  st.size_to_fit
end
```

##### UIButtonStyler

```ruby
def ui_button_kitchen_sink(st)
  st.text = 'foo'
  st.font = font.system(12)
  st.color = color.red
  st.image_normal = image.resource('logo')
  st.image_highlighted = image.resource('logo')
end
```

##### UIImageViewStyler

```ruby
def u_image_view_kitchen_sink(st)
  st.image = image.resource('logo')
end
```

##### UIScrollViewStyler

```ruby
def ui_scroll_view_kitchen_sink(st)
  st.paging = true
end
```

##### UISwitchStyler

```ruby
def ui_switch_kitchen_sink(st)
  st.on = true
end
```

**There should be a styler for each UIView type. And each one should wrap all common methods and attributes, plus add functionality for common operations. This will come in future versions**

#### Add your own stylers

In the example app, look in **/app/stylers**, you can just copy that whole folder to start. Then add methods to the appropriate class.

Here is an example of adding a method to all stylers:
```ruby
module RubyMotionQuery
  module Stylers
    class UIViewStyler

      def border_width=(value)
        @view.layer.borderWidth = value
      end
      def border_width
        @view.layer.borderWidth
      end

    end
  end
end
```

You can also include all of your custom stylers in one file, which works well if you don't have a lot.


### Creating your own views

RMQ calls 3 methods when you create, append, or build a view using rmq. rmq_build is the one you most want to use
```ruby
def rmq_build
end

def rmq_created
end

def rmq_appended
end
```
If you append a view like so:
```ruby
rmq.append(UILabel)
```
The 3 methods will be called in this order:
- rmq_created
- rmq_appended
- rmq_build

In the following example an instance of YourView is created, :your_style is applied
then rmq_build is called on the instance that was just created. In that
order.

```ruby
# Your view
class YourView < UIView
  def rmq_build
    rmq(self).tap do |q|
      q.append(UILabel, :section_title)
      q.append(UIButton, :buy_button).on(:tap) do |sender|
        # do  something
      end
    end
  end
end

# In your controller
rmq.append(YourView, :your_style)
```

### Future features

Current roadmap:

- v0.5 new view_controller system: which solves the #1 problem in rmq: having to pass rmq around in things like cells. rmq command will work everywhere
- v0.6 new frame system: I’ve already designed this, I just have to implement it and use it in the real world and tweak. This is going to be very cool. It adds to the existing frame system. It doesn’t replace constraints, but rather gives you almost all the features you need without the complexity of constraints.
- v0.6.5 templates and stylers all finished
- v0.6.7 performance improvements
- v0.7 first rmq plugin and any base features needed to support plugins (I don’t think there will be any base features needed)
- v0.8 binding system
- ?
- ?
- v1.0

Random future features that I plan on adding

- rmq.push_sub_controller(my_controller) and rmq.pop_sub_controller and rmq.pop_this_controller
- add borders to UIView styler: st.borders = {l: {w: 2, color: color.black}, r: {w: 2, color: color.black}}
- add templates for: nav controller, tab controller, table controller, collection controller
- add from_right, from_bottom, and centered to both st.frame and to move
- add binding that combines KVO and events to bind an attribute of one object to the attribute of selected view(s), keeping both in sync, like so: rmq.append(UITextField).bind(@person, attr: :name, to: :text)
- rmq.log to wrap nslog to allow you to turn off logging (or does NSLog already have this feature?)
- add selectors for UITextField
- add string to height utility, given the font and the width
- add block to wrap useful for a variety of things, but here is solid example: rmq.append(UIButton).tag(:foo).wrap{|view| view.titleLabel}.tag(:foo_title)
- add def rmq_build_with_properties(props = {}). Perhaps remove rmq_created and rmq_appended, not sure if those are useful or not
- add easy way to do alerts and actionsheets


## Contact

created by **Todd Werth** ([http://toddwerth.com](http://toddwerth.com))

- [@twerth](http://twitter.com/twerth)
- [todd@infinitered.com](mailto:todd@infinitered.com)
- [github](https://github.com/twerth)

with help from the team at **InfiniteRed** ([http://infinitered.com](http://infinitered.com))

- [@infinite_red](http://twitter.com/infinite_red)
- [github](https://github.com/infinitered)


## License

RMQ is available under the MIT license. See the LICENSE file for more info.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

  [1]: http://infinitered.com/rmq
