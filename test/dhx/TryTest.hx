package dhx;

import buddy.BuddySuite;
import dhx.Try;
import dhx.Try.Macro.Try;
import haxe.ds.Either;
import utest.Assert;
import thx.Nil;

using dhx.Tries;
using buddy.Should;

class TryTest extends BuddySuite {
    public function new() {
        describe("Try macros", {

            it("Try should catch error", {
                var t:Try<Int> = Try(throw "1");
                switch (t) {
                    case Success(_): Assert.fail("try should be failed");
                    case Failure(_):
                }
                t.failed().should.be(true);
                t.success().should.be(false);
                Assert.isNull(t.filter(function (v) return true).get());
                Assert.isNull(t.flatMap(function (v) return Try(v)).get());
                Assert.isNull(t.map(function (v) return v).get());
                t.transform(function (v) return v, function (d) return 10).get().should.be(10);
                t.fold(function (v) return v, function (d) return 10).should.be(10);
                t.foreach(function (v) { Assert.fail("try should be empty"); });
                Assert.isNull(t.get());
                t.getOrElse(function () return 10).should.be(10);
                t.orElse(function () return Try(10)).get().should.be(10);
                t.recover(function (v) return 10).get().should.be(10);
                t.recoverWith(10).get().should.be(10);
                t.toOption().should.equal(haxe.ds.Option.None);
                t.iterator().hasNext().should.be(false);
                t.toEither().should.equal(Right("1"));
            });

            it("Try should hold value", {
                var t = Try(1);
                switch (t) {
                    case Success(_):
                    case Failure(_): Assert.fail("try should be succed");
                }
                t.failed().should.be(false);
                t.success().should.be(true);
                Assert.isNull(t.filter(function (v) return false).get());
                t.flatMap(function (v) return Try(v + 1)).get().should.be(2);
                t.map(function (v) return v+1).get().should.be(2);
                t.transform(function (v) return v+1, function (d) return 10).get().should.be(2);
                t.fold(function (v) return v+1, function (d) return 10).should.be(2);
                var foreachCalled = false;
                t.foreach(function (v) { foreachCalled = true; v.should.be(1); });
                foreachCalled.should.be(true);
                t.get().should.be(1);
                t.getOrElse(function () return 10).should.be(1);
                t.orElse(function () return Try(10)).get().should.be(1);
                t.recover(function (v) return 10).get().should.be(1);
                t.recoverWith(10).get().should.be(1);
                t.toOption().should.equal(haxe.ds.Option.Some(1));
                [for (i in t.iterator()) i].should.containExactly([1]);
                t.toEither().should.equal(Left(1));
            });

            it("Try should hold void value too", {
                function void():Void {}
                var t = Try(void());
                switch (t) {
                    case Success(_):
                    case Failure(_): Assert.fail("try should be succed");
                }
                t.failed().should.be(false);
                t.success().should.be(true);
                Assert.isNull(t.filter(function (v) return false).get());
                t.flatMap(function (v) return Try(v)).get().should.equal(nil);
                t.map(function (v) return v).get().should.equal(nil);
                t.transform(function (v) return v, function (d) return nil).get().should.equal(nil);
                t.fold(function (v) return v, function (d) return nil).should.equal(nil);
                var foreachCalled = false;
                t.foreach(function (v) { foreachCalled = true; v.should.equal(nil); });
                foreachCalled.should.be(true);
                t.get().should.equal(nil);
                t.getOrElse(function () return nil).should.equal(nil);
                t.orElse(function () return Try(nil)).get().should.equal(nil);
                t.recover(function (v) return nil).get().should.equal(nil);
                t.recoverWith(nil).get().should.equal(nil);
                t.toOption().should.equal(haxe.ds.Option.Some(nil));
                [for (i in t.iterator()) i].should.containExactly([nil]);
                t.toEither().should.equal(Left(nil));
            });

        });
    }
}