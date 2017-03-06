## Scala inspired Try operator

[![Build Status](https://travis-ci.org/profelis/dhx.try.svg?branch=master)](https://travis-ci.org/profelis/dhx.try)

Haxelib: http://lib.haxe.org/p/dhx.try/

Scala API: http://www.scala-lang.org/api/current/scala/util/Try.html

Posts:
http://danielwestheide.com/blog/2012/12/26/the-neophytes-guide-to-scala-part-6-error-handling-with-try.html

# Usage:
```haxe
import dhx.Try;
import dhx.Try.Macro.Try;   // macro magic
using dhx.Tries;        // useful extensions
...
var tried:Try<Int> = Try(someUnsafeOperation(foo, bar));
tried.LogFailure(); // trace exception or set define `debug_try`
var value = tried.getOrElse(function () return 0);
```

# Global Import
import.hx
```haxe
import dhx.Try;
import dhx.Try.Macro.Try;
using dhx.Tries;
```

# Void

`Try<Void>` is not supported, instead of `Void` use `thx.Nil` type from `thx.core` haxe library.
```haxe
var tried = Try(voidMethod()); // Try.Success(thx.Nil.nil);
```

# Debug
- define `debug_try` - turn on exceptions log
