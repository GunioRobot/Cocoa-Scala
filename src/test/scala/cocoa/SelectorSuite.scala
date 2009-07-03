package cocoa

import org.scalatest._

class SelectorSuite extends FunSuite {
	test("Selector('init').toString should be 'init'") {
		assert(Selector("init").toString === "init")
	}

	test("Selector('init') should equal Selector('init')") {
		assert(Selector("init") === Selector("init"))
	}

	test("Selector('init') should not equal Selector('init:')") {
		assert(Selector("init") != Selector("init:"))
	}
}
