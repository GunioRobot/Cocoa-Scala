package cocoa

object $ID {
    private val noArgs = new Array[Any](0)

    def apply(v: Any): $ID = v match {
        case null => null
        case id: $ID => id
        case str: String => Bridge.stringToNSString(str)
        case _ => throw new IllegalArgumentException("Cannot convert to $ID: " + v)
    }
}

class $ID extends NativeProxy {
    import $ID._

    /** the proxy for the objective-c class of the underlying instance */
    lazy val isa: OCClass = Bridge.getClass(this)

    /** sub-classes that override finalize MUST call this super version
     * in order to release the underlying objective-c object */
    @native protected override def finalize()

    override def toString = isa.className + "@" + nptr.toHexString

    /** send a no-arg message to the underlying objective-c object */
    @throws(classOf[SelectorNotRecognizedException])
    final def !(sym: Symbol): Any = msgSend(sym.name, noArgs)

    /** send a message to the underlying objective-c object */
    @throws(classOf[SelectorNotRecognizedException])
    final def !(message: (Symbol, Any)*): Any = {
        val sb = new StringBuffer
        val args = new Array[Any](message.length)
        for (i <- 0 until message.length) {
            val a = message(i)
            sb.append(a._1.name).append(':')
            args(i) = a._2
        }
        val sel = sb.toString
        msgSend(sel, args)
    }

    @throws(classOf[SelectorNotRecognizedException])
    final def msgSend(selector: String, args: Array[Any]): Any = {
        val method = isa.methodForSelector(selector).getOrElse {
            throw new SelectorNotRecognizedException(selector)
        }
        Console.println("methodForSelector " + selector + " => " + method)
        method.invoke(this, args)
    }
}
