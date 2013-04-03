module SubLayouts
  extend ActiveSupport::Concern

  included do
    hide_action :sub_layout
  end

  module ClassMethods
    def sub_layout(sub_layout)
      @_sub_layout = sub_layout || false
      _write_sub_layout_method
    end

    private
      def _write_sub_layout_method
        remove_possible_method(:_sub_layout)

        case defined?(@_sub_layout) ? @_sub_layout : nil
          when String
            self.class_eval %{def _sub_layout; #{@_sub_layout.inspect} end}, __FILE__, __LINE__
          when Symbol
            self.class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
def _sub_layout
#{@_sub_layout}.tap do |sub_layout|
unless sub_layout.is_a?(String) || !sub_layout
raise ArgumentError, "Your sub layout method :#{@_sub_layout} returned \#{sub_layout}. It " \
"should have returned a String, false, or nil"
end
end
end
ruby_eval
          when Proc
            define_method :_sub_layout_from_proc, &@_sub_layout
            self.class_eval %{def _sub_layout; _sub_layout_from_proc(self) end}, __FILE__, __LINE__
          when false
          when nil
            self.class_eval %{def _layout; end}, __FILE__, __LINE__
          else
            raise ArgumentError, "Sub layouts must be specified as a String, Symbol, false, or nil"
        end
        self.class_eval { private :_sub_layout }
      end
  end

  def sub_layout
    _sub_layout
  end

  private
    def _sub_layout;
    end
end
