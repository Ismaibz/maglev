# Tests for methods in Kernel.rb
require File.expand_path('simple', File.dirname(__FILE__))


# Tests to make sure method missing is working
class Foo
  def method_missing(method_id, *args)
    if method_id == :foo
      args.length  # Just return how many parameters we get
    else
      super
    end
  end
end

f = Foo.new

test(f.foo,           0,  "method_missing: f.foo")
test(f.foo('a'),      1,  "method_missing: f.foo('a')")
test(f.foo('a', 'b'), 2,  "method_missing: f.foo('a', 'b')")


# Another method_missing test: try on a method w/o method_missing
begin
  f.bar('a', 'b')
  # Fail! should have an exception
  failed_test('f.bar', 'Error', 'NoError')
rescue
  # OK!
end

# Tests for the "global" conversion functions
test(String("foo"), "foo", 'String("foo")')
test(String(1),       "1", 'String(1)')

test(Float(1),       1.0, 'Float("1")')

test(Array(1),           [1], 'Array(1)')
test(Array([1,2,3]), [1,2,3], 'Array([1,2,3])')
test(Array(nil),          [], 'Array(nil)')


# Tests for eval
test(eval('1 + 1'), 2, 'eval "1 + 1"')

def testEval
  a = $~
  r = eval( " /cd/ =~ 'aabcde' ")
  b = $~ 
  unless a == nil ; raise 'Err'; end
  unless b.class.equal?(MatchData) ; raise 'Err'; end
  unless r == 3 ; raise 'Err'; end
  true
end

test( testEval() , true, "eval with tilde")

# Ensure that Kernel#raise generates a TypeError on bogus exception class
# parameter
# TODO: add to rubyspecs

begin
  raise :foo  # should generate a TypeError
rescue => e
  test(e.class, TypeError, 'raise :foo should generate a TypeError')
end

begin
  raise Object.new  # should generate a TypeError
rescue => e
  test(e.class, TypeError, 'raise Object.new should generate a TypeError')
end

begin
  raise :quux, "Detail"  # should generate a TypeError
rescue => e
  test(e.class, TypeError, 'raise :quux, "msg" should generate a TypeError')
end

report
true
