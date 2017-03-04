package dhx;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using haxe.macro.Tools;
#end

enum Try<T> {
    Success(val:T);
    Failure(error:Dynamic);
}

/**
 *  Scala inspired Try operator
 *  Scala API: http://www.scala-lang.org/api/current/scala/util/Try.html
 *  
 *  Usage:
 *  ```haxe
 *  import deep.dhx.Try.Macro.Try;   // macro magic
 *  using deep.dhx.TryTools;        // useful extensions
 *  ...
 *  var tried:Try<Int> = Try(someUnsafeOperation(a, b));
 *  tried.LogFailure(); // trace exception or set define `debug_try`
 *  var value = tried.getOrElse(function () return 0);
 *  ```
 *  
 *  Global Import
 *  import.hx
 *  ```
 *  import dhx.Try;
 *  import dhx.Try.Macro.Try;
 *  using dhx.Tries;
 *  ```
 *  
 *  Debug:
 *  `debug_try` define - turn on exceptions log
 */
class Macro {
    macro static public function Try(funcCall:Expr):Expr {
        var type = Context.follow(Context.typeof(funcCall));
        var body = switch (type) {
            case Type.TAbstract(_.get() => {name:"Void", pack:[]}, _):
                macro { ${funcCall}; dhx.Try.Success(thx.Nil.nil); };
            case _:
                macro { dhx.Try.Success(${funcCall}); };
        }
        var res = macro try { $body; } catch (e:Dynamic) {
            #if debug_try
            trace(Std.string(e));
            #end
            dhx.Try.Failure(e);
        }
        return res;
    }
}