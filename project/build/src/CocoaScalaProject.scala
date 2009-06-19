import sbt._
import Process._

class CocoaScalaProject(info: ProjectInfo) extends DefaultProject(info) {
    val scalatest = "org.scala-tools.testing" % "scalatest" % "0.9.5"

    val frameworkPath = path("framework")
    val headersPath = frameworkPath / "jni-src"
    
    val nativeClasses = List(
        "cocoa.ObjcBridge$",
        "cocoa.ObjcRef")
        
    def exec(cmd: String) = {
        Console.println(cmd)
        cmd!
    }
    
    override def cleanAction = super.cleanAction dependsOn cleanFramework
        
    lazy val javah = task {
        exec {
            "javah -classpath target/classes -d " + headersPath + " " + nativeClasses.mkString(" ")
        }
        None
    } dependsOn(compile)
    
    lazy val framework = task {
        exec("./project/scripts/framework-build.sh")
        None
    } dependsOn(`package`)

    lazy val cleanFramework = task {
        exec("./project/scripts/framework-clean.sh")
        None
    } 
}
