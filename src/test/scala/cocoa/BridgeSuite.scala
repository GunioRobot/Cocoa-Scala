package cocoa

import org.scalatest._

class BridgeSuite extends FunSuite {
    test("Bridge.getClass(\"NSObject\") should return an OCClass") {
        assert(Bridge.getClass("NSObject").className === "NSObject")
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
