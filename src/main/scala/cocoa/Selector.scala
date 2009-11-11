package cocoa

import scala.collection.mutable.HashMap

class Selector private (name: String, nptr: Long) extends NativeProxy(nptr) {
    override def toString = name
}

object Selector {
    /** gets the Selector object with the given selector name */
    def apply(name: String): Selector = Bridge.getSelector(name)
}
