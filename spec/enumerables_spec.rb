require './enumerable_module.rb'

RSpec.describe 'Enumerable' do
  let(:num_arr) { [2, 2, 3, 4, 5, 6] }
  let(:empty_arr) { [] }
  let(:word_arr) { %w[dog door rod blade rod] }
  let(:hash) { { a: 1, b: 2, c: 3, d: 4 } }
  let(:bool_arr) { [nil, false, nil, false, true] }
  let(:block_proc) { proc{ |x| x * 3 } }
  let(:hashed_array) do
  [
    {
      first_name: 'Gary',
      job_title: 'car enthusiast',
      salary: 14_000
    },
    {
      first_name: 'Claire',
      job_title: 'developer',
      salary: 15_000
    },
    {
      first_name: 'Clem',
      job_title: 'developer',
      salary: 12_000
    }
  ]
  end

  describe '#my_each' do
   context 'If block is given' do
     it 'iterates the given block for each array item adding a number to it' do
    my_array = []
    original_array = []
    num_arr.my_each { |i| my_array << i + 2 }
    num_arr.each { |i| original_array << i + 2 }
    expect(my_array).to eql(original_array)
     end

     it 'iterates the given block for each hash item summing up its key and value element' do
    my_hash = []
    original_hash = []
    hash.my_each { |x, y| my_hash << x.to_s + y.to_s  }
    hash.each { |x, y| original_hash << x.to_s + y.to_s }
    expect(my_hash).to eql(original_hash)
     end
   end

   context 'If block is not given' do
    it 'returns an enumerator' do
      expect(num_arr.my_each.is_a?(Enumerable)).not_to be false
    end
   end
  end

  describe 'my_each_with_index' do
    context 'If block is given' do
      it 'iterates the given block for each array item summing up its value and index' do
        my_array = []
        original_array = []
        num_arr.my_each_with_index { |x, y| my_array << ((x * 3) + (y * 2)) }
        num_arr.each_with_index { |x, y| original_array << ((x * 3) + (y * 2)) }
        expect(my_array).to eql(original_array)
      end

      it 'iterates the given block for each array item making an hash with each item' do
        my_array = {}
        original_array = {}
        word_arr.my_each_with_index do |x, _y|
          my_array.key?(x) ? my_array[x] += 1 : my_array[x] = 1
        end
        word_arr.each_with_index do |x, _y|
          original_array.key?(x) ? original_array[x] += 1 : original_array[x] = 1
        end
        expect(my_array).to eql(original_array)
      end

      it 'iterates the given block for each array item making an hash with each value and index' do
        my_array = []
        original_array = []
        word_arr.my_each_with_index { |x, y| my_array << [[x.to_sym, y]].to_h }
        word_arr.each_with_index { |x, y| original_array << [[x.to_sym, y]].to_h }
        expect(my_array).to eql(original_array)
      end
    end

    context 'If block is not given' do
      it 'returns an enumerator' do
        expect(num_arr.my_each_with_index.is_a?(Enumerable)).not_to be false
      end
     end
  end

  describe '#my_select' do
    context 'If block is given' do
      it 'selects array items that passes the conditions specified in the block' do
        my_array = word_arr.my_select { |x| x.start_with?('d') }
        original_array = word_arr.select { |x| x.start_with?('d') }
        expect(my_array).to eql(original_array)
      end

      it 'selects array items that passes the conditions specified in the block' do
        my_array = hashed_array.select { |x| x[:job_title] == 'developer' && x[:salary] > 13_000 }
        original_array = hashed_array.select { |x| x[:job_title] == 'developer' && x[:salary] > 13_000 }
        expect(my_array).to eql(original_array)
      end

      it 'selects hash items that passes the conditions specified in the block' do
        my_hash = hash.my_select  { |_x, y| y < 4 }
        original_hash = hash.select { |_x, y| y < 4 }
        expect(my_hash).to eql(original_hash)
      end
    end

    context 'If block is not given' do
      it 'returns an enumerator' do
        expect(word_arr.my_select.is_a?(Enumerable)).not_to be false
      end
     end
  end

  describe '#my_all?' do
    context 'If block is given' do
      it 'returns true if all array elements meets the condition specified in the block and false otherwise' do
        my_array = word_arr.my_all? { |x| x.length > 4 }
        original_array = word_arr.all? { |x| x.length > 4 }
        expect(my_array).to eql(original_array)
      end

      it 'returns true if all hash elements meets the condition specified in the block and false otherwise' do
        my_array = hash.my_all? { |_x, y| y.nil? }
        original_array = hash.all? { |_x, y| y.nil? }
        expect(my_array).to eql(original_array)
      end
    end

    context 'If an argument is given instead of a block' do
      it 'returns true if all elements are instance of the Class specified and false otherwise' do
        my_array = num_arr.my_all?(Integer)
        original_array = num_arr.all?(Integer)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if all elements meets the condition passed as a Symbol argument and false otherwise' do
        my_array = num_arr.my_all?(:positive?)
        original_array = num_arr.all?(:positive?)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if all elements meets the condition passed as a Regex argument and false otherwise' do
        my_array = word_arr.my_all?(/d/)
        original_array = word_arr.all?(/d/)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if all elements equals the argument passed and false otherwise' do
        my_array = num_arr.my_all?(3)
        original_array = num_arr.all?(3)
        expect(my_array).to eql(original_array)
      end
    end

    context 'If no block and argument is given' do
      it 'returns true if all elements are truthy and false if otherwise' do
        my_array = bool_arr.my_all?
        original_array = bool_arr.all?
        expect(my_array).to eql(original_array)
      end
    end

    context 'If the array/hash is empty and no block and argument given' do
      it 'returns true' do
        expect([].my_all?).to be true
      end
    end
  end

  describe 'my_count' do
    context 'If block is given' do
      it 'It counts the number of Array elements that meets the condition specified in the block' do
        my_array = word_arr.my_count { |x| x == 'rod' }
        original_array = word_arr.count { |x| x == 'rod' }
        expect(my_array).to eql(original_array)
      end

      it 'It counts the number of Hash elements elements meets the condition specified in the block' do
        my_array = hash.my_count { |_x, y| y.even? }
        original_array = hash.count { |_x, y| y.even? }
        expect(my_array).to eql(original_array)
      end
    end

    context 'If an argument is given instead of a block' do
      it 'it counts the number of elements that are instance of the Class specified' do
        my_array = word_arr.count(String)
        original_array = word_arr.count(String)
        expect(my_array).to eql(original_array)
      end

      it 'it counts the number of elements that meets the condition passed as a Regex argument' do
        my_array = word_arr.count('c')
        original_array = word_arr.count('c')
        expect(my_array).to eql(original_array)
      end

      it 'it counts the number of elements that equals the argument passed' do
        my_array = hash.count(3)
        original_array = hash.count(3)
        expect(my_array).to eql(original_array)
      end
    end

    context 'If no block and argument is given' do
      it 'it counts all elements in the array.hash' do
        my_hash = hash.my_all?
        original_hash = hash.all?
        expect(my_hash).to eql(original_hash)
      end
    end
  end

  describe 'my_map' do
    context 'If block is given' do
      it 'It invokes the given block once for each array element and returns a new array of containing the values returned by the block' do
        my_array = num_arr.my_map { |x| x * 2 }
        original_array = num_arr.map { |x| x * 2 }
        expect(my_array).to eql(original_array)
      end

      it 'It invokes the given block once for each array element and returns a new array of containing the values returned by the block' do
        my_array = word_arr.my_map { |x| x.chars.first }
        original_array = word_arr.map { |x| x.chars.first }
        expect(my_array).to eql(original_array)
      end

      it 'It invokes the given block once for each hash element and returns a new array of containing the values returned by the block' do
        my_hash = hash.my_map { |k, v| [v, k.to_sym] }.to_h
        original_hash = hash.map { |k, v| [v, k.to_sym] }.to_h
        expect(my_hash).to eql(original_hash)
      end
    end

    context 'If a Proc is given instead of a block' do
      it 'it counts the number of elements that meets the requirement of the Proc specified' do
        my_array = word_arr.map(&block_proc)
        original_array = word_arr.map(&block_proc)
        expect(my_array).to eql(original_array)
      end
    end

    context 'If no Proc and block not given' do
      it 'returns an enumerator' do
        expect(num_arr.my_map.is_a?(Enumerable)).not_to be false
      end
    end
  end

  describe '#my_any?' do
    context 'If block is given' do
      it 'returns true if any array elements meets the condition specified in the block and false otherwise' do
        my_array = word_arr.my_any? { |x| x.length > 4 }
        original_array = word_arr.any? { |x| x.length > 4 }
        expect(my_array).to eql(original_array)
      end

      it 'returns true if any hash elements meets the condition specified in the block and false otherwise' do
        my_array = hash.my_any? { |_x, y| y.nil? }
        original_array = hash.any? { |_x, y| y.nil? }
        expect(my_array).to eql(original_array)
      end
    end

    context 'If an argument is given instead of a block' do
      it 'returns true if any elements are instance of the Class specified and false otherwise' do
        my_array = num_arr.my_any?(Integer)
        original_array = num_arr.any?(Integer)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if any elements meets the condition passed as a Symbol argument and false otherwise' do
        my_array = num_arr.my_any?(:positive?)
        original_array = num_arr.any?(:positive?)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if any elements meets the condition passed as a Regex argument and false otherwise' do
        my_array = word_arr.my_any?(/d/)
        original_array = word_arr.any?(/d/)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if any elements equals the argument passed and false otherwise' do
        my_array = num_arr.my_any?(3)
        original_array = num_arr.any?(3)
        expect(my_array).to eql(original_array)
      end
    end

    context 'If no block and argument is given' do
      it 'returns true if any elements are truthy and false if otherwise' do
        my_array = bool_arr.my_any?
        original_array = bool_arr.any?
        expect(my_array).to eql(original_array)
      end
    end

    context 'If the array/hash is empty and no block and argument given' do
      it 'returns false' do
        expect([].my_any?).to be false
      end
    end
  end

  describe '#my_none?' do
    context 'If block is given' do
      it 'returns true if none array elements meets the condition specified in the block and false otherwise' do
        my_array = word_arr.my_none? { |x| x.length > 4 }
        original_array = word_arr.none? { |x| x.length > 4 }
        expect(my_array).to eql(original_array)
      end

      it 'returns true if none hash elements meets the condition specified in the block and false otherwise' do
        my_array = hash.my_none? { |_x, y| y.nil? }
        original_array = hash.none? { |_x, y| y.nil? }
        expect(my_array).to eql(original_array)
      end
    end

    context 'If an argument is given instead of a block' do
      it 'returns true if none elements are instance of the Class specified and false otherwise' do
        my_array = num_arr.my_none?(Integer)
        original_array = num_arr.none?(Integer)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if none elements meets the condition passed as a Symbol argument and false otherwise' do
        my_array = num_arr.my_none?(:positive?)
        original_array = num_arr.none?(:positive?)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if none elements meets the condition passed as a Regex argument and false otherwise' do
        my_array = word_arr.my_none?(/d/)
        original_array = word_arr.none?(/d/)
        expect(my_array).to eql(original_array)
      end

      it 'returns true if none elements equals the argument passed and false otherwise' do
        my_array = num_arr.my_none?(3)
        original_array = num_arr.none?(3)
        expect(my_array).to eql(original_array)
      end
    end

    context 'If no block and argument is given' do
      it 'returns true if none elements are truthy and false if otherwise' do
        my_array = bool_arr.my_none?
        original_array = bool_arr.none?
        expect(my_array).to eql(original_array)
      end
    end

    context 'If the array/hash is empty and no block and argument given' do
      it 'returns true' do
        expect([].my_none?).to be true
      end
    end
  end

  describe '#my_inject' do
    context 'If argument is given' do
      context 'If block is given' do
        it 'return the sum of all elements inside the array starting value equal the argument' do
          my_array = num_arr.my_inject(10) { |x, y| x + y }
          original_array = num_arr.inject(10) { |x, y| x + y }
          expect(my_array).to eql(original_array)
        end

        it 'return the substraction of all elements inside the array starting value equal the argument' do
          my_array = num_arr.my_inject(10) { |x, y| x - y }
          original_array = num_arr.inject(10) { |x, y| x - y }
          expect(my_array).to eql(original_array)
        end

        it 'return the multiply of all elements inside the array starting value equal the argument' do
          my_array = num_arr.my_inject(10) { |x, y| x * y }
          original_array = num_arr.inject(10) { |x, y| x * y }
          expect(my_array).to eql(original_array)
        end
      end

      context 'If symbol is given as argument' do
        it 'return the sum of all element inside the array' do
          my_array = num_arr.my_inject(:+)
          original_array = num_arr.inject(:+)
          expect(my_array).to eql(original_array)
        end

        it 'return the substraction of all element inside the array' do
          my_array = num_arr.my_inject(:-)
          original_array = num_arr.inject(:-)
          expect(my_array).to eql(original_array)
        end

        it 'return the multiply of all element inside the array' do
          my_array = num_arr.my_inject(:*)
          original_array = num_arr.inject(:*)
          expect(my_array).to eql(original_array)
        end

        it 'return true only if all elements are true or false if at least one element is false' do
          my_array = bool_arr.my_inject(:&)
          original_array = bool_arr.inject(:&)
          expect(my_array).to eql(original_array)
        end
      end

      context 'If proc is given as argument' do
        it 'Its invokes the Proc passed on each element in the array' do
          my_array = num_arr.my_inject(&block_proc)
          original_array = num_arr.inject(&block_proc)
          expect(my_array).to eql(original_array)
        end
      end

      context 'If an integer and a symbol are passed as argument' do
        it 'return the sum of all elements inside the array starting value equal the integer parameter' do
          my_array = num_arr.my_inject(10, :+)
          original_array = num_arr.inject(10, :+)
          expect(my_array).to eql(original_array)
        end
      end
    end

    context 'If no argument is given' do
      context 'If block is given' do
        it 'return the sum of all elements inside the array' do
          my_array = num_arr.my_inject { |x, y| x + y }
          original_array = num_arr.inject { |x, y| x + y }
          expect(my_array).to eql(original_array)
        end

        it 'return the substraction of all elements inside the array' do
          my_array = num_arr.my_inject { |x, y| x - y }
          original_array = num_arr.inject { |x, y| x - y }
          expect(my_array).to eql(original_array)
        end

        it 'return the multiply of all elements inside the array' do
          my_array = num_arr.my_inject { |x, y| x * y }
          original_array = num_arr.inject { |x, y| x * y }
          expect(my_array).to eql(original_array)
        end
      end
    end
  end
end
