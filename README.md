![RMQ logo](https://raw.github.com/infinitered/rmq/master/resources/logo@2x.png?raw=true)

# RMQ - RubyMotion Front-end Library

[![Dependency Status](https://gemnasium.com/infinitered/rmq.png)](https://gemnasium.com/infinitered/rmq)
[![Build Status](https://travis-ci.org/infinitered/rmq.png?branch=master)](https://travis-ci.org/infinitered/rmq)
[![Gem Version](https://badge.fury.io/rb/ruby_motion_query.png)](http://badge.fury.io/rb/ruby_motion_query)
[![Crusher.io optimized](http://www.crusher.io/repo/infinitered/rmq/badge)](http://www.crusher.io/repo/infinitered/rmq)

A fast, non-polluting, chaining, front-end library. It’s like jQuery for [RubyMotion](http://rubymotion.com) plus templates, stylesheets, events, animations, etc.

One of RMQ's goals is to have the best [documentation][1] of any RubyMotion UI library.

<br />

----------

## Read the [RMQ Documentation][1] here

----------

<br />

### Requires SDK 7 or higher, and iOS 7 or higher

## Quick Start

```
gem install ruby_motion_query
# Create an app
rmq create my_app
# Then
cd my_app
bundle
rake
```

`rbenv rehash` after gem install if you use rbenv

<br />

## Installation

RMQ **requires no other gems**. If you use stuff like **scale** and certain animations it will require some frameworks (like QuartzCore or CoreGraphics)

- `gem install ruby_motion_query`

If you use rbenv

- `rbenv rehash`

Require it

- `require 'ruby_motion_query'`

or add it to your `Gemfile`:

- `gem 'ruby_motion_query'`

for **edge RMQ**, add this to your `Gemfile`:

- `gem 'ruby_motion_query', :git => 'git@github.com:infinitered/rmq.git'`


<br />

### License

RMQ is available under the MIT license. See the [LICENSE](https://github.com/infinitered/rmq/blob/master/LICENSE) file for more info.


<br />

### Created by Todd Werth ([http://toddwerth.com](http://toddwerth.com))

- [@twerth](http://twitter.com/twerth)
- [todd@infinitered.com](mailto:todd@infinitered.com)
- [github](https://github.com/twerth)


<br />

### [Contributors](https://github.com/infinitered/rmq/graphs/contributors)

<br />

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

<br />

----------

## Read the [RMQ Documentation][1] here

----------

  [1]: http://rubymotionquery.com
