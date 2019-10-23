module Enumerable
  def my_each
    return enum_for :my_each unless block_given?
    for value in self
      yield value
    end
      self
  end
end