package cocoa

import org.scalatest._

class BridgeSuite extends FunSuite {
    test("OCBridge.getClass(\"NSObject\") should return an OCClass") {
        assert(OCBridge.getClass("NSObject").className === "NSObject")
    }

    test("OCBridge.getClass(\"NotAClass\") should throw OCClassNotFoundException") {
        intercept[OCClassNotFoundException] {
			OCBridge.getClass("NotAClass")
		}
    }

	test("OCBridge.stringToNSString(\"foo\") should return an NSString") {
		val nsstr = OCBridge.stringToNSString("foo")
		assert(nsstr.toString === "foo")
	}
}
