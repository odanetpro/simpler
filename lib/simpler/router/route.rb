module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        clear_path = remove_extra_slashes(path)

        @method == method && clear_path.match(path_regexp).to_a[0] == clear_path
      end

      def params(path)
        clear_path = remove_extra_slashes(path)

        params = clear_path.match(path_regexp)&.named_captures || {}
        params.transform_keys { |key| key.delete_prefix(':').to_sym }
      end

      private

      def remove_extra_slashes(path)
        result = path.gsub(%r{/+}, '/').delete_suffix('/')
        result == '' ? '/' : result
      end

      def path_regexp
        @path.gsub(/(:\w+)/, '(?<\0>\\w+)')
      end
    end
  end
end
