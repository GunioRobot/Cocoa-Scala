package cocoa

import scala.collection.mutable.HashMap

/**
 * Instances of this class are used to proxy Objective-C classes.
 */
class OCClass extends $ID {
	private val methods = new Cache[String,Method](selName => {
		val method = lookupMethod(Selector(selName))
		if (method == null) None
		else Some(method)
	})
	
	/** gets the name of the objective-c class */
	@native def className: String
	
	/** gets the proxy for the superclass */
	@native def superClass: OCClass
	
	/** indicates if this object represents a metaclass, or a normal class */
	@native def isMetaClass: Boolean
	
	/** calls the respondsToSelector method on the objective-c class */
	@native def respondsToSelector(sel: String): Boolean

	/** gets the Method for the specified selector */
	def methodForSelector(sel: String): Option[Method] = methods(sel)
	
	@native private def lookupMethod(sel: Selector): Method
	
	/** returns the name of the Objective-C class */
	override def toString = className
	
	/* allocates an instance of this class */
	@native def alloc: $ID
}

object OCClass {
	def apply(className: String) = Bridge.getClass(className)
}

