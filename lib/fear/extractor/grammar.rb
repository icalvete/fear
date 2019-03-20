module Fear
  module Extractor
    # This module contains AST nodes for GrammarParser
    # generated by +treetop+. The sole purpose of them all is to
    # generate matchers
    module Grammar
      class Node < Treetop::Runtime::SyntaxNode
      end

      class EmptyArray < Node
        def to_matcher
          EmptyListMatcher.new(node: self)
        end
      end

      class ArrayLiteral < Node
        def to_matcher
          elements[1].to_matcher
        end
      end

      class NonEmptyArray < Node
        def to_matcher
          head, tail = elements
          ArrayMatcher.new(head: head.to_matcher, tail: tail.to_matcher, node: self)
        end
      end

      class ArrayTail < Node
        def to_matcher
          elements[1].to_matcher
        end
      end

      class ArrayHead < Node
        def to_matcher
          ArrayHeadMatcher.new(matcher: elements[1].to_matcher, node: elements[1])
        end
      end

      class ArraySplat < Node
        def to_matcher
          elements[1].to_matcher
        end
      end

      class AnonymousArraySplat < Node
        def to_matcher
          AnonymousArraySplatMatcher.new(node: self)
        end
      end

      class FloatLiteral < Node
        def to_matcher
          ValueMatcher.new(value: value, node: self)
        end

        def value
          text_value.to_f
        end
      end

      class IntegerLiteral < Node
        def to_matcher
          ValueMatcher.new(value: value, node: self)
        end

        def value
          text_value.to_i
        end
      end

      class StringLiteral < Node
        def to_matcher
          ValueMatcher.new(value: value, node: self)
        end

        def value
          elements[1].text_value
        end
      end

      require 'yaml'

      class DoubleQuotedStringLiteral < StringLiteral
        def to_matcher
          ValueMatcher.new(value: value, node: self)
        end

        def value
          YAML.safe_load(%(---\n"#{super}"\n))
        end
      end

      class SymbolLiteral < Node
        def to_matcher
          ValueMatcher.new(value: value, node: self)
        end

        def value
          elements[1].value.to_sym
        end
      end

      class TrueLiteral < Node
        def to_matcher
          ValueMatcher.new(value: true, node: self)
        end
      end

      class FalseLiteral < Node
        def to_matcher
          ValueMatcher.new(value: false, node: self)
        end
      end

      class NilLiteral < Node
        def to_matcher
          ValueMatcher.new(value: nil, node: self)
        end
      end

      class AnyIdentifier < Node
        def to_matcher
          AnyMatcher.new(node: self)
        end
      end

      class Identifier < Node
        def to_matcher
          IdentifierMatcher.new(name: value, node: self)
        end

        def value
          text_value.to_sym
        end
      end

      class NamedArraySplat < Node
        def to_matcher
          NamedArraySplatMatcher.new(name: name, node: self)
        end

        def name
          text_value[1..-1].to_sym
        end
      end

      class TypeLiteral < Node
        def to_matcher
          ValueMatcher.new(value: value, node: self)
        end

        def value
          Object.const_get(text_value)
        end
      end

      class TypedIdentifier < Node
        def to_matcher
          identifier, type = elements.values_at(0, 2)
          type.to_matcher.and(identifier.to_matcher)
        end
      end

      class IdentifiedMatcher < Node
        def to_matcher
          identifier, matcher = elements.values_at(0, -1)
          identifier.to_matcher.and(matcher.to_matcher)
        end
      end

      class ExtractorLiteral < Node
        def to_matcher
          ExtractorMatcher.new(
            name: extractor_name,
            arguments_matcher: extractor_arguments,
            node: self,
          )
        end

        private def extractor_name
          name = elements[0].text_value
          if Object.const_defined?(name)
            Object.const_get(name)
          else
            name
          end
        end

        private def extractor_arguments
          if elements[2].empty?
            EmptyListMatcher.new(node: self)
          else
            elements[2].to_matcher
          end
        end
      end
    end
  end
end
