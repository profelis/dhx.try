package dhx;

import dhx.Try.Macro.Try;
import haxe.ds.Option;

class Tries {

    inline public static function failed<T>(t:Try<T>):Bool return t.match(Failure(_));

    inline public static function success<T>(t:Try<T>):Bool return t.match(Success(_));

    inline public static function filter<T>(t:Try<T>, p:T -> Bool):Try<T> {
        return switch t {
            case Success(v): try { p(v) ? t : Failure("failed"); } catch (e:Dynamic) { Failure(e); }
            case Failure(_): t;
        }
    }

    inline public static function flatMap<T, U>(t:Try<T>, f:T -> Try<U>):Try<U> {
        return switch t {
            case Success(v):  try { f(v); } catch (e:Dynamic) { Failure(e); }
            case Failure(e): var res:Try<U> = Failure(e); res;
        }
    }

    inline public static function map<T, U>(t:Try<T>, f:T -> U):Try<U> {
        return switch t {
            case Success(v): Try(f(v));
            case Failure(e): var res:Try<U> = Failure(e); res;
        }
    }

    inline public static function transform<T, U>(t:Try<T>, f:T -> U, error:Dynamic -> U):Try<U> {
        return switch t {
            case Success(v): Try(f(v));
            case Failure(e): Try(error(e));
        }
    }

    inline public static function fold<T, U>(t:Try<T>, f:T -> U, error:Dynamic -> U):U {
        return switch t {
            case Success(v): try { f(v); } catch (e:Dynamic) { error(e); }
            case Failure(e): error(e);
        }
    }


    inline public static function foreach<T>(t:Try<T>, p:T -> Void):Void {
        switch t {
            case Success(v): p(v);
            case Failure(_):
        }
    }

    inline public static function get<T>(t:Try<T>):Null<T> {
        return switch t {
            case Success(v): v;
            case Failure(_): null;
        }
    }

    inline public static function getOrElse<T>(t:Try<T>, val:Void -> T):T {
        return switch t {
            case Success(v): v;
            case Failure(_): val();
        }
    }

    inline public static function orElse<T>(t:Try<T>, val:Void -> Try<T>):Try<T> {
        return switch t {
            case Success(_): t;
            case Failure(_): try { val(); } catch (e:Dynamic) { Failure(e); }
        }
    }

    inline public static function recover<T>(t:Try<T>, f:Dynamic -> T):Try<T> {
        return switch t {
            case Success(_): t;
            case Failure(e): Success(f(e));
        }
    }

    inline public static function recoverWith<T>(t:Try<T>, val:T):Try<T> {
        return switch t {
            case Success(_): t;
            case Failure(e): Success(val);
        }
    }

    inline public static function toOption<T>(t:Try<T>):Option<T> {
        return switch t {
            case Success(v): Some(v);
            case Failure(_): None;
        }
    }

    inline public static function iterator<T>(t:Try<T>):Iterator<T> {
        return switch t {
            case Success(v): [v].iterator();
            case Failure(_): [].iterator();
        }
    }

#if thx_core
    inline public static function toEither<T>(t:Try<T>):thx.Either<T, Dynamic> {
        return switch t {
            case Success(v): thx.Either.Left(v);
            case Failure(e): thx.Either.Right(e);
        }
    }
#end

    inline public static function LogFailure<T>(t:Try<T>):Try<T> {
        switch t {
            case Failure(e): trace(Std.string(e));
            case _:
        }
        return t;
    }
}