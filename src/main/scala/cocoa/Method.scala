package cocoa

class Method  (
	val sel: Selector, 
	val returnType: OCType, 
	val argTypes: Seq[OCType], 
	val fficif: Long, 
	val fn: Long) {
		
	Console.println("<init> => " + this)
		
	private val returnTypeCode = returnType.code
	private val argTypeCodes = argTypes.map(_.code).toArray
	
	def invoke(receiver: $ID, args: Array[Any]): Any = 
		sendMsg(sel, returnTypeCode, argTypeCodes, fficif, fn, receiver, args)

	@native private def sendMsg(
		sel: Selector, 
		returnTypeCode: Char, 
		argTypeCodes: Array[Char], 
		fficif: Long, 
		fn: Long,
		receiver: $ID, 
		args: Array[Any]): Any
	
	override def toString: String = {
		sel + "(" + argTypes.mkString(",") + ")" + returnType + "@" + fn.toHexString
	}
}

