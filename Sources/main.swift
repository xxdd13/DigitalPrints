import Glibc
import MySQL

var mysql:Database
do {
    mysql = try Database(host:"localhost",
                         user:"swift",
                         password:"swiftpass",
                         database:"swift_test")
    try mysql.execute("SELECT @@version")
} catch {
    print("Unable to connect to MySQL:  \(error)")
    exit(-1)
}
