#因为类本身也是Class类的一个实例，instance_eval也可以用在类上，这个时候就可以在其中定义该类的singleton_method，即为该类的类方法``:
class A
end

A.instance_eval do
  puts self  # => A
  # current class => A's singleton class
  def method1
    puts 'this is a singleton method of class A'
  end
end

A.method1
