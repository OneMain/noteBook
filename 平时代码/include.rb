
module Foo
  def self.included(base)
     p "base is :#{base}  self is #{self}"
    base.class_eval do
      def self.method_injected_by_foo
        
         puts "#{self}aaaaaaaaa"
      end
    end
  end
end

module Bar
  include Foo
  def self.included(base)
    base.method_injected_by_foo
  end
end

class Host
 # include Foo # We need to include this dependency for Bar
  include Bar # Bar is the module that Host really needs
end
