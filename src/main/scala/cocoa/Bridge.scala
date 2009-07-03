package cocoa

import scala.collection.mutable.HashMap

object Bridge {
    System.loadLibrary("CocoaScala")

	private val classCache = new HashMap[String,OCClass]
	private val metaClassCache = new HashMap[String,OCClass]
	
    /**
     * Returns an ObjcClass object respresenting the indicated
     * Objective-C class.  
     * @throws OCClassNotFoundException if the class is not found.
     */
	def getClass(className: String): OCClass = {
		classCache.synchronized {
			classCache.get(className) getOrElse {
				val clz = findClass(className, false)
				classCache(className) = clz
				clz
			}
		}
	}

    /**
     * Returns an ObjcClass object respresenting the indicated
     * Objective-C class.  
     * @throws OCClassNotFoundException if the class is not found.
     */
	def getMetaClass(className: String): OCClass = {
		metaClassCache.synchronized {
			metaClassCache.get(className) getOrElse {
				val clz = findClass(className, true)
				metaClassCache(className) = clz
				clz
			}
		}
	}

    /**
     * Returns an ObjcClass object respresenting the indicated
     * Objective-C class.  
     * @throws OCClassNotFoundException if the class is not found.
     */
    @throws(classOf[OCClassNotFoundException])
    @native private def findClass(className: String, meta: Boolean): OCClass

	/**
	 * Gets the OCClass for the given proxy object.
	 */
	@native private[cocoa] def getClass(proxy: $ID): OCClass

	/**
	 * Converts a java.util.String to an NSString
	 */
	@native def stringToNSString(str: String): NSString
	
	/**
	 * Converts a NSString to a java.util.String
	 */
	@native def nsStringToString(nsstr: NSString): String
}

class OCClassNotFoundException(className: String) extends Exception(className)
class SelectorNotRecognizedException(selector: String) extends Exception(selector)
