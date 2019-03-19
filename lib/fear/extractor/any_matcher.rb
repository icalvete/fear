module Fear
  module Extractor
    # Always match, E.g. `_ : Integer` without capturing variable
    #
    class AnyMatcher < Matcher
      def defined_at?(_other)
        true
      end
    end
  end
end