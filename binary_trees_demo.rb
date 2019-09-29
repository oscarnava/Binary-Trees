require_relative 'binary_trees.rb'

def run_all(array)
  puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  puts "Source array: #{array}\n\n"

  tree = BinaryTree.new array

  p tree.slice
  p tree.bfs

  p tree.serialize

  puts "\n#{tree}\n\n"

  tree.tap do |root|
    puts "Tree to Array (Pre-Order) : #{root.pre_order}"
    puts "Tree to Array (In-Order)  : #{root.to_a}"
    puts "Tree to Array (Post-Order): #{root.post_order}"
  end

  print "\nPre-Order : "
  tree.pre_order do |data|
    print "| #{data} "
  end

  print "\nIn-Order  : "
  tree.in_order { |data| print "| #{data} " }

  print "\nPost-Order: "
  tree.post_order do |data|
    print "| #{data} "
  end

  begin
    puts "\n\nHeight: #{tree.height}"
    puts "Balanced: #{tree.balanced?}"
    puts "Ordered: #{tree.ordered?}"
    puts "\n~~~~~~~~~~~~~~~~~~"
    print 'Map: '
    p(tree.map { |data| Math.sqrt(data).round(3) })
    puts '~~~~'
    print 'Sum: '
    p tree.sum
    puts '~~~~'
  rescue
  end

end

run_all [10, 4, 12]
run_all [10, 5, 7]
run_all [7, 5, 9, 3, 0, 6, 8]
run_all [2, 7, 5, 2, 6, 0, 9, 0, 0, 5, 8, 0, 0, 4, 0]
run_all [4, 2, 6, 1, 3, 5, 7]
run_all [8,4,'C',2,6,'A','E',1,3,5,7,9,'B','D','F']
run_all [8,4,12,2,6,10,14,1,3,5,7,9,11,13,15]