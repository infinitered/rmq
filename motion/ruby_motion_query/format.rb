module RubyMotionQuery
  class RMQ
    # @return [Format]
    def format
      Format
    end

    # @return [Format]
    def self.format
      Format
    end
  end

  class Format
    class << self

      # rmq.format.number(1232, '#,##0.##')
      def numeric(number, format)
        RubyMotionQuery::Format::Numeric.formatter(format).stringFromNumber(number)
      end
      alias :number :numeric

      # rmq.format.date(Time.now, 'EEE, MMM d, ''yy')
      #
      # See <http://www.unicode.org/reports/tr35/tr35-19.html#Date_Format_Patterns>
      # for more information about date format strings.
      def date(date = nil, *format_or_styles)
        RubyMotionQuery::Format::Date.formatter(*format_or_styles).stringFromDate(date)
      end

      def numeric_formatter(format)
        RubyMotionQuery::Format::Numeric.formatter(format)
      end

      def date_formatter(*format_or_styles)
        RubyMotionQuery::Format::Date.formatter(*format_or_styles)
      end

      def add_datetime_style(style, format)
        RubyMotionQuery::Format::Date.add_datetime_style(style, format)
      end
    end
  end

  class Format::Numeric
    class << self

      def formatter(format)
        @_numeric_formatter ||= {}

        # Caching here is very important for performance
        @_numeric_formatter[format] ||= begin
          number_formater = NSNumberFormatter.alloc.init
          number_formater.setPositiveFormat(format)
          number_formater
        end
      end

    end
  end

  class Format::Date

    DATE_STYLES = {
      short_date:   NSDateFormatterShortStyle,
      medium_date:  NSDateFormatterMediumStyle,
      long_date:    NSDateFormatterLongStyle,
      full_date:    NSDateFormatterFullStyle
    }

    TIME_STYLES = {
      short_time:   NSDateFormatterShortStyle,
      medium_time:  NSDateFormatterMediumStyle,
      long_time:    NSDateFormatterLongStyle,
      full_time:    NSDateFormatterFullStyle
    }

    class << self

      def formatter(*format_or_styles)
        raise(ArgumentError, "formatter requires at least one parameter") if format_or_styles.first.nil?

        if format_or_styles.first.is_a?(String)
          formatter_from_format(format_or_styles.first)
        else
          formatter_from_styles(*format_or_styles)
        end
      end

      def formatter_from_format(format)
        @_date_formatters ||= {}

        # Caching here is very important for performance
        @_date_formatters[format] ||= begin
          date_formatter = NSDateFormatter.alloc.init

          format_template = NSDateFormatter.dateFormatFromTemplate(
            format,
            options:0,
            locale: NSLocale.currentLocale
          )
          date_formatter.setDateFormat(format_template)

          date_formatter
        end
      end

      def formatter_from_styles(*styles)
        @_date_formatters ||= {}

        # Caching here is very important for performance
        @_date_formatters[styles.to_s] ||= begin
          date_formatter = NSDateFormatter.alloc.init

          styles.each do |style|
            if DATE_STYLES.has_key?(style)
              date_formatter.setDateStyle(DATE_STYLES.fetch(style))
            elsif TIME_STYLES.has_key?(style)
              date_formatter.setTimeStyle(TIME_STYLES.fetch(style))
            end
          end

          date_formatter
        end
      end

      def add_datetime_style(style_name, format)
        @_date_formatters ||= {}

        @_date_formatters[[style_name].to_s] ||= formatter_from_format(format)
      end
    end
  end
end
