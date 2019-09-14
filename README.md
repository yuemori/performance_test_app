# README

## demo1: application demo

```
git checkout demo1
rails s

open http://localhost:3000/fibonaccis
```

```ruby
# app/models/fibonacci.rb
class Fibonacci < ApplicationRecord
  def result
    calculate(number)
  end

  private

  def calculate(n) # bad performance method
    return   if n < 0
    return n if n < 2

    calculate(n - 1) + calculate(n - 2)
  end
end
```

### improve performance

```
git checkout improve-performance
git show
```

```diff
@@ -9,6 +9,11 @@ class Fibonacci < ApplicationRecord
     return   if n < 0
     return n if n < 2

-    calculate(n - 1) + calculate(n - 2)
+    a = 0
+    b = 1
+
+    n.times { a, b = b, a + b }
+
+    a
   end
 end
```

## demo2: how to benchmarking and profiling

```
git checkout demo2

# check stackprof configuration
cat ./config/initializers/stackprof.rb

# access localhost:3000/sibonaccis/1 and run:
bundle exec stackprof tmp/stackprof-wall-xxxxx-xxxxxxxxxx.dump
bundle exec stackprof-webnav -f tmp/stackprof-wall-xxxxx-xxxxxxxxxx.dump

open http://localhost:9292
```

### improve performance

```
git checkout improve-performance2

# access localhost:3000/sibonaccis/1 and run:
bundle exec stackprof tmp/stackprof-wall-xxxxx-xxxxxxxxxx.dump
bundle exec stackprof-webnav -f tmp/stackprof-wall-xxxxx-xxxxxxxxxx.dump

open http://localhost:9292
```

## demo3: performance spec

```
git checkout demo3

vi spec/performances/fibonacci_spec.rb
vi spec/support/matchers/performance.rb
```
