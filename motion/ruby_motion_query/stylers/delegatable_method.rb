module RubyMotionQuery
  module Stylers
    module DelegatableMethod
      def appleize(sym)
        items = sym.to_s.split('_')
        ret = items.shift
        ret += items.map { |i| i[0] = i[0].upcase ; i }.join
      end

      def delegate_method(name, target = :view, as = nil)
        as ||= appleize(name)
        define_method(name) do
          send(target).send(as)
        end

        define_method("#{name}=") do |value|
          send(target).send("#{as}=", value)
        end
      end
    end
  end
end
