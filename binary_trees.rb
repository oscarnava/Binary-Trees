# frozen_string_literal: true

RD = '╭'
CO = '─'
MD = '┴'
LD = '╮'
SP = ' '
LU = '└'
RU = '┘'
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

  def serialize(values = Array.new(2**height - 1), offset = 0)
    values[offset] = data
    @left&.serialize(values, offset * 2 + 1)
    @right&.serialize(values, offset * 2 + 2)
    values
  end

  def to_s
    rows = serialize

    hgth = height
    size = 2**(hgth - 1)
    lines = []
    hgth.times do |level|
      row = rows[size - 1...2 * size - 1]
      # warn "Size: #{size}, Row: #{row}"
      lt_spc = 2**level - 1
      in_spc = SP * (2**(level + 1) - 1)
      lt_mgn = SP * lt_spc
      hz_lin = CO * lt_spc
      lines << lt_mgn + row.map { |v| v || ' ' }.join(in_spc)

      connectors = ''
      (size / 2).times do |idx|
        left = row[idx * 2]
        right = row[idx * 2 + 1]
        cnctor = if left.nil? && right.nil?
                   SP * (3 + 2 * lt_spc)
                 elsif left.nil?
                   SP * (1 + lt_spc) + LU + hz_lin + LD
                 elsif right.nil?
                   RD + hz_lin + RU + SP * (lt_spc + 1)
                 else
                   RD + hz_lin + MD + hz_lin + LD
                 end
        connectors += cnctor + in_spc
      end

      lines << lt_mgn + connectors

      size /= 2
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
    return nil if idx >= array.length || [0, nil].include?(array[idx])

    BinaryTree.new(array[idx]).tap do |node|
      node.left = array_to_tree(array, 2 * idx + 1)
      node.right = array_to_tree(array, 2 * idx + 2)
    end
  end
end
