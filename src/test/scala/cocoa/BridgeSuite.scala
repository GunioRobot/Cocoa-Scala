package cocoa

import org.scalatest._

class BridgeSuite extends FunSuite {
    test("findClass") {
        assert(ObjcBridge.findClass("NSObject") === null)
    }
}
