package cocoa

object TestMain {
	def main(args: Array[String]) {
		new BridgeSuite().execute()
		new ClassSuite().execute()
	}
}