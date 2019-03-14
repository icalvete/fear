module Fear
  module Extractor
    class StringMatcher < Matcher
      attribute :value, Types::Strict::String
      attribute :node, Types.Instance(Grammar::StringLiteral)

      def defined_at?(other)
        value === other
      end

      def bindings(_)
        Dry::Core::Constants::EMPTY_HASH
      end
    end
  end
end
