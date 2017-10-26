require "spec_helper"

RSpec.describe FibonacciHeap do
  it "has a version number" do
    expect(FibonacciHeap::VERSION).not_to be nil
  end

  it "creates a fibonacci heap" do
    f = FibonacciHeap.new

    expect(f.min).to be_nil
  end

  it "inserts a key" do
    f = FibonacciHeap.new
    f.insert(2, 'hey')

    expect(f.min).to_not be_nil
    expect(f.min.key).to eq(2)
  end

  it "inserts multiple keys" do
    f = FibonacciHeap.new
    f.insert(2, 'hey')
    f.insert(3, 'hi')

    expect(f.min).to_not be_nil
    expect(f.min.key).to eq(2)

    expect(f.min.left).to_not be_nil
    expect(f.min.left.key).to eq(3)

    expect(f.min.right).to_not be_nil
    expect(f.min.right.key).to eq(3)
  end

  it "deletes the minimum key" do
    f = FibonacciHeap.new

    (1..8).each { |x| f.insert(x, x) }

    f.delete_min!

    expect(f.min.key).to eq(2)
  end

  it "properly decreases a key" do
    f = FibonacciHeap.new

    nodes = (1..8).map { |x| f.insert(x, x) }

    f.delete_min!

    parent = nodes[4].parent
    trees = f.trees
    f.decrease_key(nodes[4], 1)

    expect(f.trees).to eq(trees + 1)
    expect(parent.marked?).to be true
    expect(parent.child).to be_nil
    expect(f.min.key).to eq(1)
    expect(f.min.parent).to be_nil
  end

  it "joins two heaps" do
    f = FibonacciHeap.new
    f.insert(3, 'hey')

    f2 = FibonacciHeap.new
    f2.insert(2, 'hi')

    f.union(f2)
    expect(f.min.key).to eq(2)
    expect(f.min.right.key).to eq(3)
  end

  it "deletes a key" do
    f = FibonacciHeap.new

    nodes = (1..8).map { |x| f.insert(x, x) }

    f.delete(nodes[2])

    expect(f.min.key).to eq(1)
  end
end
