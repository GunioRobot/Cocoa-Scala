package cocoa

import scala.collection.mutable.HashMap

class Selector private (name: String, nptr: Long) extends NativeProxy(nptr) {
	override def toString = name
}

object Selector {
	private val selectors = new Cache[String,Selector](name => Some(newSel(name)))
	
	/** gets the Selector object with the given selector name */
	def apply(name: String): Selector = selectors(name).get

	/** wraps the native SEL object with a Selector */
	@native private def newSel(name: String): Selector
}
