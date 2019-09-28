# frozen_string_literal: true

LT = '╭'
CO = '─'
MD = '┴'
RT = '╮'
SP = ' '

class BinaryTree
  include Enumerable

  attr_reader :data

  # Create a BinaryTree node from some data

  def initialize(data)
    case data
    # if the source is an array, build the tree from the contents
    when Array
      @data = data[0]
      @left = array_to_tree(data, 1)
      @right = array_to_tree(data, 2)
    else
      @data = data
    end
  end

  def height
    1 + max(@left&.height.to_i, @right&.height.to_i)
  end

  def balanced?
    (@left&.height.to_i - @right&.height.to_i).abs <= 1 &&
      (@left.nil? || @left.balanced?) &&
      (@right.nil? || @right.balanced?)
  end

  def ordered?(min = -Float::INFINITY, max = Float::INFINITY)
    data.between?(min, max) &&
      (@left.nil? || @left.ordered?(min, data)) &&
      (@right.nil? || @right.ordered?(data, max))
  end

  def in_order(&block)
    if block_given?
      @left&.in_order(&block)
      yield data
      @right&.in_order(&block)
    else
      @left&.in_order.to_a + [data] + @right&.in_order.to_a
    end
  end

  alias each in_order

  def pre_order(&block)
    if block_given?
      yield data
      @left&.pre_order(&block)
      @right&.pre_order(&block)
    else
      [data] + @left&.pre_order.to_a + @right&.pre_order.to_a
    end
  end

  alias dfs pre_order

  def post_order(&block)
    if block_given?
      @left&.post_order(&block)
      @right&.post_order(&block)
      yield data
    else
      @left&.post_order.to_a + @right&.post_order.to_a + [data]
    end
  end

  def slice(slices = [], depth = 0)
    @left&.slice(slices, depth + 1)
    @right&.slice(slices, depth + 1)
    slices.tap { |s| s[depth] = s[depth].to_a << data }
  end

  def bfs
    slice.flatten
  end

  def to_s
    rows = slice.reverse

    lines = []
    rows.each_with_index do |row, level|
      row.map { |v| v || 'ø' }
      lt_spc = 2**level - 1
      in_spc = SP * (2**(level + 1) - 1)
      lt_mgn = SP * lt_spc
      cnctor = LT + (CO * lt_spc) + MD + (CO * lt_spc) + RT
      cnc_ct = row.size / 2
      lines << lt_mgn + row.join(in_spc)
      lines << lt_mgn + (cnctor + in_spc) * (cnc_ct) if cnc_ct.positive?
    end

    lines.reverse.join("\n")

    #    4
    #  ╭─┴─╮
    #  2   6
    # ╭┴╮ ╭┴╮
    # 1 3 5 7

    # "⋅⋅⋅⋅⋅⋅⋅F"
    # "⋅⋅⋅╭───┴───╮"
    # "⋅⋅⋅4⋅⋅⋅⋅⋅⋅⋅E\n" +
    # "⋅╭─┴─╮⋅⋅⋅╭─┴─╮\n" +
    # "⋅2⋅⋅⋅6⋅⋅⋅C⋅⋅⋅D\n" +
    # "╭┴╮⋅╭┴╮⋅╭┴╮⋅╭┴╮\n" +
    # "1⋅3⋅5⋅7⋅8⋅9⋅A⋅B\n"
  end

  protected

  # left & right nodes will only be accessible internally.

  attr_accessor :left, :right

  private

  # Auxiliar methods

  def max(first, second)
    first > second ? first : second
  end

  def array_to_tree(array, idx)
    return nil if idx >= array.length || array[idx] == 0 # rubocop:disable Style/NumericPredicate

    BinaryTree.new(array[idx]).tap do |node|
      node.left = array_to_tree(array, 2 * idx + 1)
      node.right = array_to_tree(array, 2 * idx + 2)
    end
  end
end
