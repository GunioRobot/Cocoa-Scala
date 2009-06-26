package cocoa

import org.scalatest._

class ClassSuite extends FunSuite {
	test("NSString className should be 'NSString'") {
		assert(OCClass("NSString").className === "NSString")
	}

	test("NSString superClass should be NSObject") {
		assert(OCClass("NSString").superClass === OCClass("NSObject"))
	}

	test("NSString respondsToSelector stringWithFormat: should return true") {
		assert(OCClass("NSString").respondsToSelector("stringWithFormat:") === true)
	}

	test("NSString respondsToSelector length should return false") {
		assert(OCClass("NSString").respondsToSelector("length") === false)
	}
}
