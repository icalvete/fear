module Functional
  # Represents optional values. Instances of `Option`
  # are either an instance of `Some` or the object `None`.
  #
  # The most idiomatic way to use an `Option` instance is to treat it
  # as a collection or monad and use `map`, `flat_map`, `detect`, or `each`:
  #
  # @example
  #   name = Option(params[:name])
  #   upper = name.map(&:strip).detect { |n| n.length != 0 }.map(&:upcase)
  #   puts upper.get_or_else('')
  #
  # This allows for sophisticated chaining of `Option` values without
  # having to check for the existence of a value.
  #
  # A less-idiomatic way to use `Option` values is via pattern matching:
  #
  # @example
  #   name = Option(params[:name])
  #   case name
  #   when Some
  #     puts name.strip.upcase
  #   when None
  #     puts 'No name value'
  #   end
  #
  # or manually checking for non emptiness:
  #
  # @example
  #   name = Option(params[:name])
  #   if name.empty?
  #     puts 'No name value'
  #   else
  #     puts name.strip.upcase
  #   end
  #
  # @example #detect
  #   User.find(params[:id]).detect do |user|
  #     user.posts.count > 0
  #   end #=> Some(User)
  #
  #   User.find(params[:id]).detect do |user|
  #     user.posts.count > 0
  #   end #=> None
  #
  #   User.find(params[:id])
  #     .detect(&:confirmed?)
  #     .map(&:posts)
  #     .inject(0, &:count)
  #
  # @example #reject
  #   Some(42).reject { |v| v > 0 } #=> None
  #   Some(42).reject { |v| v < 0 } #=> Some(42)
  #   None().reject { |v| v > 0 }   #=> None
  #
  # @see https://github.com/scala/scala/blob/2.11.x/src/library/scala/Option.scala
  #
  module Option
    def left_class
      None
    end

    def right_class
      Some
    end

    # @return [true, false] true if the option is `None`,
    #   false otherwise.
    #
    def empty?
      is_a?(None)
    end

    # Returns the option's value if it is nonempty,
    # or `nil` if it is empty. Useful for unwrapping
    # option's value.
    #
    # @return [Object, nil] the option's value if it is
    #   nonempty or `nil` if it is empty
    #
    # @example
    #   Option(24).or_nil  #=> 24
    #   Option(nil).or_nil #=> nil
    #
    def or_nil
      get_or_else { nil }
    end
  end
end
