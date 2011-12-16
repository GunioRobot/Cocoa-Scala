package cocoa

class Method  (
    val sel: Selector,
    val returnType: OCType,
    val paramTypes: Seq[OCType],
    val fficif: Long,
    val fn: Long)
{
    private val returnTypeCode = returnType.code
    private val paramTypeCodes = paramTypes.map(_.code).toArray

    def invoke(receiver: $ID, args: Array[Any]): Any = {
        // TODO validate argument types
        sendMsg(sel, returnTypeCode, paramTypeCodes, fficif, fn, receiver, args)
    }

    @native private def sendMsg(
        sel: Selector,
        returnTypeCode: Char,
        paramTypeCodes: Array[Char],
        fficif: Long,
        fn: Long,
        receiver: $ID,
        args: Array[Any]): Any

    override def toString: String = {
        sel + "(" + paramTypes.mkString(",") + ")" + returnType + "@" + fn.toHexString
    }
}

