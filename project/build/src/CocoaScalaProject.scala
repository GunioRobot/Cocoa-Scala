import sbt._
import Process._

class CocoaScalaProject(info: ProjectInfo) extends DefaultProject(info) {
    val scalatest = "org.scala-tools.testing" % "scalatest" % "0.9.5"

    val cSourcePath = mainSourcePath / "c"
    val targetDotOPath = path("target") / "doto"
    
    val nativeClasses = List(
        "cocoa.ObjcBridge$",
        "cocoa.ObjcRef")
        
    val cFiles = List(
        "cocoascala")
        
    val linkedFrameworks = List(
        "/System/Library/Frameworks/JavaVM.framework",
        "/System/Library/Frameworks/Cocoa.framework")
        
    def exec(cmd: String) = {
        Console.println(cmd)
        cmd!
    }
        
    lazy val javah = task {
        exec {
            "javah -classpath target/classes -d " + cSourcePath + " " + nativeClasses.mkString(" ")
        }
        None
    } dependsOn(compile)
    
    lazy val jnilib = task {
        targetDotOPath.asFile.mkdirs
        if (compileCFiles()) {
            exec {
                "cc -dynamiclib -fobjc-gc -m64 -o target/libCocoaScala.jnilib " + 
                    cFiles.map(targetDotOPath + "/" + _ + ".o").mkString(" ") + 
                    " -framework JavaVM -framework Cocoa"
            }
        }
        None
    }
    
    private def compileCFiles(): Boolean = {
        cFiles.forall { c =>
            0 == exec {
                "cc -c -ObjC -fobjc-gc -m64 " + linkedFrameworks.map("-I" + _ + "/Headers").mkString(" ") + 
                    " -o " + targetDotOPath + "/" + c + ".o " + 
                    cSourcePath + "/" + c + ".c"
            }
        }
    }
}
