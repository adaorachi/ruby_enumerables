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
    if block_given?
      n = args[0] ? 0 : 1
      acc = args[0]
      acc ||= arr[0]
      n.upto(arr.length - 1) { |value| acc = yield(acc, arr[value]) }
    elsif args[0].is_a?(Symbol) || args[0].is_a?(Proc)
      n = 1
      acc = arr[0]
      n.upto(arr.length - 1) { |value| acc = args[0].to_proc.call(acc, arr[value]) }
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

# Examples to test methods with

# arr = %w[a b c c d]
# words = %w[dog door rod blade]
# words[0] = 5
# arr1 = [nil, 'a', 'b']
# arrnum = [2, 2, 3, 4, 5, 6]
# hash = { a: 1, b: 2, c: 3, d: 4 }
# false_array = [1, false, 'hi', []]
# false_array1 = [nil, false, nil, false]
# false_array2 = [true, false, true, false]
# array = [1, 4, 6, 5, 1, 1, 3, 0, 7, 4, 0, 6, 5, 3, 1, 1, 0, 7, 4, 2, 3, 7, 1, 3, 1, 8, 1, 6, 6, 0, 7, 2, 8, 5, 5, 0, 1, 5, 5, 1, 0, 1, 8, 2, 2, 3, 5, 4, 7, 6, 5, 1, 4, 8, 1, 7, 6, 7, 8, 0, 3, 6, 8, 7, 1, 3, 6, 4, 6, 6, 3, 1, 6, 8, 3, 3, 7, 7, 7, 5, 7, 4, 0, 0, 6, 5, 6, 8, 5, 6, 5, 6, 8, 0, 4, 1, 1, 5, 4, 3]
# range = Range.new(5, 50)

# arr.each { |x| puts x }
# arr.my_each { |x| puts x }
# hash.each { |x, y| puts x.to_s + y.to_s }
# hash.my_each { |x, y| puts x.to_s + y.to_s }
# p arr.each
# p arr.my_each

# arr.each_with_index { |x, y| puts x.to_s + y.to_s }
# arr.my_each_with_index { |x, y| puts x.to_s + y.to_s }
# hash.each_with_index { |x, y| puts x.to_s + y.to_s }
# hash.my_each_with_index { |x, y| puts x.to_s + y.to_s }
# p arr.each_with_index
# p arr.my_each_with_index

# puts(arr.select { |x| x < 'c' })
# puts(arr.my_select { |x| x < 'c' })
# puts(hash.select { |_x, y| y < 4 })
# puts(hash.my_select { |_x, y| y < 4 })
# p arr.select
# p arr.my_select

# puts(arr.all? { |x| x < 'd' })
# puts(arr.all? { |x| x < 'f' })
# puts(arr.my_all? { |x| x < 'd' })
# puts(arr.my_all? { |x| x < 'f' })
# puts(hash.all? { |x, y| y.positive? })
# puts(hash.all? { |x, y| y.nil? })
# puts(hash.my_all? { |x, y| y.positive? })
# puts(hash.my_all? { |x, y| y.nil? })
# puts false_array.all?
# puts false_array.my_all?
# p arr.all?
# p arr.my_all?
# p hash.all?
# p hash.my_all?
# p array.all?(Integer)
# p array.my_all?(Integer)
# p words.all?(/d/)
# p words.my_all?(/d/)
# p words.all?(3)
# p words.my_all?(3)
# p words.all?('door')
# p words.my_all?('door')
# p [].all?
# p [].my_all? 

# puts(arr.any? { |x| x < 'd' })
# puts(arr.any? { |x| x < 'f' })
# puts(arr.my_any? { |x| x < 'd' })
# puts(arr.my_any? { |x| x < 'f' })
# puts(hash.any? { |_x, y| y < 4 })
# puts(hash.any? { |_x, y| y < 5 })
# puts(hash.my_any? { |_x, y| y < 4 })
# puts(hash.my_any? { |_x, y| y < 5 })
# p arr.any?
# p arr.my_any?
# p false_array1.any?
# p false_array1.my_any?
# p array.any?(String)
# p array.my_any?(String)
# p array.any?(3)
# p array.my_any?(3)
# p words.any?(/d/)
# p words.my_any?(/d/)
# p words.any?(/z/)
# p words.my_any?(/z/)
# p words.any?('cat')
# p words.my_any?('cat')

# puts(arr.none? { |x| x < 'd' })
# puts(arr.none? { |x| x < 'f' })
# puts(arr.my_none? { |x| x < 'd' })
# puts(arr.my_none? { |x| x < 'f' })
# puts(hash.none? { |_x, y| y < 4 })
# puts(hash.none? { |_x, y| y < 5 })
# puts(hash.my_none? { |_x, y| y < 4 })
# puts(hash.my_none? { |_x, y| y < 5 })
# p arr.none?
# p arr.my_none?
# p false_array1.none?
# p false_array1.my_none?
# p array.none?(String)
# p array.my_none?(String)
# p array.none?(3)
# p array.my_none?(3)
# p words.none?(/z/)
# p words.my_none?(/z/)
# p words.none?(5)
# p words.my_none?(5)

# puts arr.count
# puts arr.count('c')
# puts(arr.count { |x| x < 'c' })
# puts arr.my_count
# puts arr.my_count('c')
# puts(arr.my_count { |x| x < 'c' })
# puts hash.count
# puts(hash.count { |_x, y| y < 3 })
# puts hash.my_count
# puts(hash.my_count { |_x, y| y < 3 })
# p arr.count
# p arr.my_count

# p(arrnum.map { |x| x * 2 })
# p(arrnum.my_map { |x| x * 2 })
# block_proc = proc { |x| x * 3 }
# p arrnum.map(&block_proc)
# p arrnum.my_map(&block_proc)
# p(arrnum.map { |x| x * 2 })
# p(arrnum.my_map { |x| x * 2 })
# p arr.map
# p arr.my_map

# p arrnum.inject { |x, y| x - y }
# p arrnum.my_inject { |x, y| x - y }
# p arrnum.inject(10) { |x, y| x * y }
# p arrnum.my_inject(10) { |x, y| x * y }
# p range.inject(4) { |prod, n| prod * n }
# p range.my_inject(4) { |prod, n| prod * n }
# p false_array2.inject(:&)
# p false_array2.my_inject(:&)
# p array.inject(:+)
# p array.my_inject(:+)
# p arrnum.inject(:*)
# p arrnum.my_inject(:*)
# p arrnum.inject(&block_proc)
# p arrnum.my_inject(&block_proc)
# p arrnum.inject(&:+)
# p arrnum.my_inject(&:+)
# p arrnum.my_inject(&:+)
# [1,2,3,4].my_inject do |accumulator, element|
#   puts "accumulator: #{accumulator}, element: #{element} - 
#   Adding them: #{accumulator} +  #{element} = #{accumulator + element}"
#   accumulator + element
# end
