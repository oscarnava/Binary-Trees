# [Binary Trees](https://en.wikipedia.org/wiki/Binary_tree) implementation in Ruby

Author: [Oscar Nava](https://github.com/oscarnava)

<img src="https://upload.wikimedia.org/wikipedia/commons/f/f7/Binary_tree.svg" width="38.196601125%" align="right">

This is a work in progress, inspired by the challenges from Microverse. It's intended to be both a practical tool ready to be used in practice, and a learning tool so anybody can learn what is this data structure and how it works.

## Methods:
### new
Initialize with an array representation of the tree, like:
```ruby
root = BinaryTree.new array [4, 2, 6, 1, 3, 5, 7]
```
- - -
### height
Will return the height of the tree.
```ruby
root.height
=> 3
```
- - -
### balanced?
Will tell if the tree is balanced or not.
```ruby
root.balanced?
=> true
```
- - -
### ordered?
Will tell if the tree is ordered or not.
```ruby
root.ordered?
=> true
```
- - -
### in_order?
Will return an array of the item in in-order sequence.
```ruby
root.in_order
=> [1, 2, 3, 4, 5, 6, 7]
```
You can also provide a block which will be executed for every node and the data will be passed as parameter:
```ruby
root.in_order do |data|
  print "| #{data} "
end
=> | 1 | 2 | 3 | 4 | 5 | 6 | 7
```
- - -
### pre_order?
Will return an array of the item in pre-order sequence.
```ruby
root.pre-order
=> [4, 2, 1, 3, 6, 5, 7]
```
You can also provide a block which will be executed for every node and the data will be passed as parameter:
```ruby
root.pre_order do |data|
  print "| #{data} "
end
=> | 4 | 2 | 1 | 3 | 6 | 5 | 7
```
- - -
### post_order?
Will return an array of the item in post-order sequence.
```ruby
root.post-order
=> [1, 3, 2, 5, 7, 6, 4]
```
You can also provide a block which will be executed for every node and the data will be passed as parameter:
```ruby
root.post_order do |data|
  print "| #{data} "
end
=> | 1 | 3 | 2 | 5 | 7 | 6 | 4
```
- - -
### to_s
Will display the tree as a graphic representation. Current version only works with complete balanced trees.
```ruby
root.to_s
=>
     4
  ╭─┴─╮
  2    6
╭┴╮ ╭┴╮
1  3  5  7

```


### Enumerable capabilities
It also extends ___Enumerable___, so you can use any Enumerable method on the tree:
```ruby
root.map { |data| Math.sqrt(data).round(3) }
=> [1.0, 1.414, 1.732, 2.0, 2.236, 2.449, 2.646]

root.sum
=> 28
```


## TODO's
* Create a **to_s** method that will display the tree as an ASCII diagram.
* Push and Pop methods to insert or remove items (in order)
* A method to balance the tree.