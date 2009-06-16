package cocoa

object ObjcBridge {
    System.loadLibrary("CocoaScala")
    
    @native def findClass(className: String): ObjcClass
    
    def main(args: Array[String]) {
        args.foreach { className => 
            Console.println(className + " => " + findClass(className))
        }
    }
}
