package cocoa

import scala.collection.mutable.HashMap
import cocoa.foundation._

object Bridge {
    System.loadLibrary("CocoaScala")

	private val classCache = Cache.strict(findClass)
	private val metaClassCache = Cache.strict(findClass(_:String).isa)
	private val selectors = Cache.strict(newSel)
	
	Foundation.require
	
	/** used to ensure the jnilib is loaded */
	private[cocoa] def touch() = ()
	
	def registerClass(clz: OCClass) {
		if (clz.isMetaClass)
			registerMetaClass(clz)
		else {
			classCache(clz.className) = clz
			// instantiating the meta class will cause it to be registered
			new OCClass(clz.className, true)
		}
	}
	
	def registerMetaClass(clz: OCClass) {
		if (clz.isMetaClass)
			metaClassCache(clz.className) = clz
		else
			throw new IllegalArgumentException("Not a metaclass: " + clz)
	}
	
    /**
     * Returns an ObjcClass object respresenting the indicated
     * Objective-C class.  
     * @throws OCClassNotFoundException if the class is not found.
     */
	def getClass(className: String): OCClass = classCache(className).get

    /**
     * Returns an ObjcClass object respresenting the indicated
     * Objective-C class.  
     * @throws OCClassNotFoundException if the class is not found.
     */
	def getMetaClass(className: String): OCClass = metaClassCache(className).get
	
	@native private def findClass(className: String): OCClass

	private def hasClass(className: String) = {
		classCache.contains(className)
	}
	
	/**
	 * Creates a new $ID subclass to proxy an instance of the 
	 * specified objective-c class
	 */
	private[cocoa] def newProxy(className: String): $ID = {
		classCache(className).get.instanceClass.newInstance //.asInstanceOf[$ID]
	}
	
	/**
	 * Gets the OCClass for the given proxy object.
	 */
	@native private[cocoa] def getClass(proxy: $ID): OCClass
	
	/** gets the Selector object with the given selector name */
	def getSelector(name: String): Selector = selectors(name).get

	/** wraps the native SEL object with a Selector */
	@native private def newSel(name: String): Selector

	/**
	 * Converts a java.lang.String to an NSString
	 */
	@native def stringToNSString(str: String): NSString
	
	/**
	 * Converts a NSString to a java.util.String
	 */
	@native def nsStringToString(nsstr: NSString): String
}

class OCClassNotFoundException(className: String) extends Exception(className)
class SelectorNotRecognizedException(selector: String) extends Exception(selector)
