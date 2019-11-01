# frozen_string_literal: true

module Enumerable
  def my_each
    return enum_for :my_each unless block_given?

    index = 0
    while index < length
      is_a?(Hash) ? yield([keys[index], values[index]]) : yield(self[index])
      index += 1
    end
    self
  end

  def my_each_with_index
    return enum_for :my_each_with_index unless block_given?

    index = 0
    while index < length
      is_a?(Hash) ? yield([keys[index], values[index]], index) : yield(self[index], index)
      index += 1
    end
  end

  def my_select
    return enum_for :my_select unless block_given?

    arr = is_a?(Hash) ? {} : []
    if is_a?(Hash)
      my_each { |key, value| arr[key] = value if yield(key, value) }
    else
      my_each { |value| arr << value if yield value }
    end
    arr
  end

  def my_all?(arg = nil)
    extend Snippet
    if block_given?
      return my_select { |a, b| yield(a, b) }.length == length if is_a?(Hash)

      my_select { |a| yield(a) }.length == length
    elsif !arg.nil?
      all_snippet(arg)
    else
      return my_select { |a, _b| a }.length == length if is_a?(Hash)

      my_select { |a| a }.length == length
    end
  end

  def my_any?(arg = nil)
    extend Snippet
    if block_given?
      return my_select { |item, value| yield(item, value) }.length.positive? if is_a?(Hash)

      my_select { |item| yield(item) }.length.positive?
    elsif !arg.nil?
      any_snippet(arg)
    else
      return my_select { |item, _value| item }.length.positive? if is_a?(Hash)

      my_select { |item| item }.length.positive?
    end
  end

  def my_none?(arg = nil)
    extend Snippet
    if block_given?
      return my_select { |item, value| yield(item, value) }.length.zero? if is_a?(Hash)

      my_select { |item| yield(item) }.length.zero?
    elsif !arg.nil?
      none_snippet(arg)
    else
      return my_select { |item, _value| item }.length.zero? if is_a?(Hash)

      my_select { |item| item }.length.zero?
    end
  end

  def my_count(arg = nil)
    arr = []
    if block_given?
      my_each { |i| arr << i if yield i }
    elsif !arg.nil?
      my_select { |i| arr << i if i == arg }
    else
      arr = self
    end
    arr.size
  end

  def my_map(proc = nil)
    return enum_for :my_map unless block_given?

    arr = []
    proc ? my_each { |value| arr << proc.call(value) } : my_each { |value| arr << yield(value) }
    arr
  end

  def my_inject(*args)
    arr = is_a?(Range) ? to_a : self
    acc = args[0]
    if block_given?
      n = args[0] ? 0 : 1
      acc ||= arr[0]
      n.upto(arr.length - 1) { |value| acc = yield(acc, arr[value]) }
    elsif args[0].is_a?(Symbol) || args[0].is_a?(Proc)
      acc = arr[0]
      1.upto(arr.length - 1) { |value| acc = args[0].to_proc.call(acc, arr[value]) }
    else
      arr.insert(0, args[0])
      1.upto(arr.length - 1) { |value| acc = args[1].to_proc.call(acc, arr[value]) }
    end
    acc
  end

  def multiply_els
    my_inject(100) { |product, n| product * n }
  end
end

module Snippet
  def all_snippet(arg)
    case arg
    when Class
      my_select { |item| item.is_a?(arg) }.length == length
    when Regexp
      my_select { |item| item =~ arg }.length == length
    else
      my_select { |item| item.equal?(arg) }.length == length
    end
  end

  def any_snippet(arg)
    case arg
    when Class
      my_select { |item| item.is_a?(arg) }.length.positive?
    when Regexp
      my_select { |item| item =~ arg }.length.positive?
    else
      my_select { |item| item.equal?(arg) }.length.positive?
    end
  end

  def none_snippet(arg)
    case arg
    when Class
      my_select { |item| item.is_a?(arg) }.length.zero?
    when Regexp
      my_select { |item| item =~ arg }.length.zero?
    else
      my_select { |item| item.equal?(arg) }.length.zero?
    end
  end
end
