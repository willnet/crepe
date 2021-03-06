module Yuba
  class ViewModel
    module Rendering
      def render(*args)
        view_model_hash = args.find { |arg| arg.is_a?(Hash) && arg[:view_model] }
        @_view_model = view_model_hash[:view_model] if view_model_hash && view_model_hash[:view_model]
        super
      end

      def view_assigns
        super.merge(view_model_assigns)
      end

      private

      def _protected_ivars
        super.merge(:@_view_model)
      end

      def view_model_assigns
        return {} unless defined?(@_view_model)
        methods = @_view_model.public_methods(false)
        methods.reject! do |method_name|
          %i[initialize].include?(method_name) ||
            !valid_variable_name?(method_name)
        end
        methods.inject({}) do |hash, method_name|
          hash[method_name] = @_view_model.public_send(method_name)
          hash
        end
      end

      def valid_variable_name?(name)
        name.match?(/\A[_a-z]\w*\z/)
      end
    end
  end
end
