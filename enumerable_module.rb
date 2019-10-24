# frozen_string_literal: true

module Enumerable
  def my_each
    return enum_for :my_each unless block_given?

    index = 0
    while index < length
      if is_a?(Hash)
        yield([keys[index], values[index]])
      else
        yield(self[index])
      end
      index += 1
    end
    self
  end

  def my_each_with_index
    return enum_for :my_each_with_index unless block_given?

    index = 0
    while index < length
      if is_a?(Hash)
        yield([keys[index], values[index]], index)
      else
        yield(self[index], index)
      end
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

  def my_all?
    return true unless block_given?

    if is_a?(Hash)
      my_select { |item, value| yield(item, value) }.length == length
    else
      my_select { |item| yield(item) }.length == length
    end
  end

  def my_any?
    return true unless block_given?

    if is_a?(Hash)
      my_select { |item, value| yield(item, value) }.length.positive?
    else
      my_select { |item| yield(item) }.length.positive?
    end
  end

  def my_none?
    return false unless block_given?

    if is_a?(Hash)
      my_select { |item, value| yield(item, value) }.length.zero?
    else
      my_select { |item| yield item }.length.zero?
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
    if proc
      my_each { |value| arr << proc.call(value) }
    else
      my_each { |value| arr << yield(value) }
    end
    arr
  end

  def my_inject(acc = nil)
    n = acc ? 0 : 1
    acc ||= self[0]
    n.upto(length - 1) { |value| acc = yield(acc, self[value]) }
    acc
  end

  def multiply_els
    my_inject(100) { |product, n| product * n }
  end
end

# Examples to test methods with

# arr = %w[a b c c d]
# arrnum = [1, 2, 3, 4, 5, 6]
# hash = { a: 1, b: 2, c: 3, d: 4 }
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
# puts(hash.all? { |_x, y| y < 4 })
# puts(hash.all? { |_x, y| y < 5 })
# puts(hash.my_all? { |_x, y| y < 4 })
# puts(hash.my_all? { |_x, y| y < 5 })
# p arr.all?
# p arr.my_all?

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

# puts(arrnum.map { |x| x * 2 })
# puts(arrnum.my_map { |x| x * 2 })
# block_proc = proc { |x| x * 3 }
# puts arrnum.map(&block_proc)
# puts arrnum.my_map(&block_proc)
# puts(arrnum.map { |x| x * 2 })
# puts(arrnum.my_map { |x| x * 2 })
# p arr.map
# p arr.my_map

# puts arrnum.inject(0) { |x, y| x + y }
# puts arrnum.inject(100) { |x, y| x - y }
# puts arrnum.my_inject(0) { |x, y| x + y }
# puts arrnum.my_inject(100) { |x, y| x - y }
