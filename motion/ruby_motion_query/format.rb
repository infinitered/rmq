module RubyMotionQuery
  class RMQ
    def format
      Format
    end
    def self.format
      Format
    end
  end

  class Format
    class << self

      # rmq.format.number(1232, '#,##0.##')
      def numeric(number, format)
        RubyMotionQuery::Format.numeric_formatter(format).stringFromNumber(number)
      end
      alias :number :numeric

      # rmq.format.date(Time.now, 'EEE, MMM d, ''yy')
      #
      # See <http://www.unicode.org/reports/tr35/tr35-19.html#Date_Format_Patterns>
      # for more information about date format strings.
      def date(date, format)
        RubyMotionQuery::Format.date_formatter(format).stringFromDate(date)
      end

      def numeric_formatter(format)
        @_numeric_formatter ||= {}

        # Caching here is very important for performance
        @_numeric_formatter[format] ||= begin
          number_formater = NSNumberFormatter.alloc.init
          number_formater.setPositiveFormat(format)
          number_formater 
        end
      end

      def date_formatter(format)
        @_date_formatters ||= {}

        # Caching here is very important for performance
        @_date_formatters[format] ||= begin
          format_template = NSDateFormatter.dateFormatFromTemplate(format, options:0,
                                                            locale: NSLocale.currentLocale)
          date_formatter = NSDateFormatter.alloc.init
          date_formatter.setDateFormat(format_template)
          date_formatter
        end
      end

    end
  end
end
