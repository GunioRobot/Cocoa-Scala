package cocoa

import cocoa.foundation._
import org.scalatest._

class BridgeSuite extends FunSuite {
    import Foundation._
    Foundation.require
    
    test("Bridge.getClass(\"NSObject\") should return an OCClass") {
        assert(Bridge.getClass("NSObject").className === "NSObject")
    }

    test("Foundation.NSObject should be equal to Bridge.getClass('NSObject')") {
        assert(NSObject === Bridge.getClass("NSObject"))
    }

    test("Bridge.getClass(\"NotAClass\") should throw OCClassNotFoundException") {
        intercept[OCClassNotFoundException] {
            Bridge.getClass("NotAClass")
        }
    }

    test("Bridge.stringToNSString(\"foo\") should return an NSString") {
        val nsstr = Bridge.stringToNSString("foo")
        assert(nsstr.toString === "foo")
    }
}
