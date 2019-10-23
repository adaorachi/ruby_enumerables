# frozen_string_literal: true

module Enumerable
  SELF = self

  def my_each
    return enum_for :my_each unless block_given?

    for value in self
      yield value
    end
    self
  end

  def my_each_with_index
    return enum_for :my_each_with_index unless block_given?

    index = 0
    for value in self
      yield(value, index)
      index += 1
    end 
  end

  def my_select
    return enum_for :my_select unless block_given?

    arr = self.is_a?(Hash) ? {} : []
    if self.is_a?(Hash)
      self.my_each {|key, value| arr[key] = value if yield(key, value) }
    elsif self.is_a?(Array)
      self.my_each { |value| arr << value if yield value }
    end
    arr
  end
end

arr = %w[a b c c d]
arrnum = [1, 2, 3, 4, 5, 6]
hash = { a: 1, b: 2, c: 3, d: 4 }
arr.each { |x| puts x }
arr.my_each { |x| puts x }
hash.each { |x, y| puts x.to_s + y.to_s }
hash.my_each { |x, y| puts x.to_s + y.to_s }
p arr.each
p arr.my_each

arr.each_with_index { |x, y| puts x.to_s + y.to_s }
arr.each_with_index { |x, y| puts x.to_s + y.to_s }
hash.each_with_index { |x, y| puts x.to_s + y.to_s }
hash.my_each_with_index { |x, y| puts x.to_s + y.to_s }
p arr.each_with_index
p arr.my_each_with_index

puts(arr.select { |x| x < 'c' })
puts(arr.my_select { |x| x < 'c' })
puts(hash.select { |_x, y| y < 4 })
puts(hash.my_select { |_x, y| y < 4 })
p arr.select
p arr.my_select

# puts arr.all? {|x| x<'d'}
# puts arr.all? {|x| x<'f'}
# puts arr.my_all? {|x| x<'d'}
# puts arr.my_all? {|x| x<'f'}
# puts hash.all? {|x,y| y<4}
# puts hash.all? {|x,y| y<5}
# puts hash.my_all? {|x,y| y<4}
# puts hash.my_all? {|x,y| y<5}

# puts arr.any? {|x| x<'d'}
# puts arr.any? {|x| x<'a'}
# puts arr.my_any? {|x| x<'d'}
# puts arr.my_any? {|x| x<'a'}
# puts hash.any? {|x,y| y<4}
# puts hash.any? {|x,y| y<0}
# puts hash.my_any? {|x,y| y<4}
# puts hash.my_any? {|x,y| y<0}

# puts arr.none? {|x| x<'d'}
# puts arr.none? {|x| x<'a'}
# puts arr.my_none? {|x| x<'d'}
# puts arr.my_none? {|x| x<'a'}
# puts hash.none? {|x,y| y<4}
# puts hash.none? {|x,y| y<0}
# puts hash.my_none? {|x,y| y<4}
# puts hash.my_none? {|x,y| y<0}

# puts arr.count
# puts arr.count('c')
# puts arr.count {|x| x<'c'}
# puts arr.my_count
# puts arr.my_count('c')
# puts arr.my_count {|x| x<'c'}

# puts hash.count
# puts hash.count{|x,y| y<3}
# puts hash.my_count
# puts hash.my_count{|x,y| y<3}

# puts arrnum.map {|x| x*2}
# puts arrnum.my_map {|x| x*2}
# proc = Proc.new {|x| x*3}
# puts arrnum.my_map(proc)
# puts arrnum.my_map(proc) {|x| x*2}