module RubyMotionQuery
  class RMQ
    # @return [Validation]
    def self.validation
      Validation
    end

    # @return [Validation]
    def validation
      Validation
    end

    # @return [RMQ]
    def validates(rule)
      selected.each do |view|
        view.rmq_data.validations << Validation.new(rule)
      end
      self
    end

    # @return [RMQ]
    def clear_validations!
      selected.each do |view|
        view.rmq_data.validations = []
      end
      self
    end

    # @return [Boolean] false if any validations fail
    def valid?
      result = true

      selected.each do |view|
        view.rmq_data.validations.each do |validation|

          has_events = view.rmq_data.events

          if validation.valid?(rmq(view).data)
            if has_events && view.rmq_data.events.has_event?(:valid)
              view.rmq_data.events[:valid].fire!
            end
          else
            if has_events && view.rmq_data.events.has_event?(:invalid)
              view.rmq_data.events[:invalid].fire!
            end
            result = false
          end
        end
      end
      return result
    end
  end

  class Validation

    def initialize(rule)
      @rule = @@validation_methods[rule]
      raise "RMQ validation error: :#{rule} is not one of the supported validation methods." unless @rule
    end

    def valid?(data, options={})
      @rule.call(data, options)
    end

    class << self
      # Validation Regex from jQuery validation -> https://github.com/jzaefferer/jquery-validation/blob/master/src/core.js#L1094-L1200
      EMAIL = Regexp.new('^[a-zA-Z0-9.!#$%&\'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
      URL = Regexp.new('^(https?|s?ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)|\/|\?)*)?$')
      DATEISO = Regexp.new('^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])$')
      NUMBER = Regexp.new('^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$')
      DIGITS = Regexp.new('^\d+$')
      # Other Fun by http://www.freeformatter.com/regex-tester.html
      IPV4 = Regexp.new('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')
      TIME = Regexp.new('^(20|21|22|23|[01]\d|\d)((:[0-5]\d){1,2})$')
      # Future Password strength validations -> http://stackoverflow.com/questions/5142103/regex-for-password-strength
      USZIP = Regexp.new('^\d{5}(-\d{4})?$')
      # 7 or 10 digit number, delimiters are spaces, dashes, or periods
      USPHONE = Regexp.new('^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]‌​)\s*)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-‌​9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})$')


      @@validation_methods = {
        :email => lambda { |value, opts| Validation.regex_match?(value, EMAIL)},
        :url => lambda { |value, opts| Validation.regex_match?(value, URL)},
        :dateiso => lambda { |value, opts| Validation.regex_match?(value, DATEISO)},
        :number => lambda { |value, opts| Validation.regex_match?(value, NUMBER)},
        :digits => lambda { |value, opts| Validation.regex_match?(value, DIGITS)},
        :ipv4 => lambda { |value, opts| Validation.regex_match?(value, IPV4)},
        :time => lambda { |value, opts| Validation.regex_match?(value, TIME)},
        :uszip => lambda { |value, opts| Validation.regex_match?(value, USZIP)},
        :usphone => lambda { |value, opts| Validation.regex_match?(value, USPHONE)}
      }

      # Add tags
      # @example
      #    rmq.validation.valid?('test@test.com', :email)
      #    rmq.validation.valid?(53.8, :number)
      #    rmq.validation.valid?(54, :digits)
      #    rmq.validation.valid?('https://www.tacoland.com', :url)
      #    rmq.validation.valid?('2014-03-02'), :dateiso)
      #
      # @return [Boolean]
      def valid?(value, rule, options={})
        #shortcircuit if debugging
        return true if RubyMotionQuery::RMQ.debugging?
        Validation.new(rule).valid?(value, options)
      end

      def regex_match?(value, regex)
        (value.to_s =~ regex) == 0
      end

    end
  end
end
