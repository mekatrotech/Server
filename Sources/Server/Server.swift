
import PerfectHTTP
import PerfectHTTPServer
import MySQLDriver



public struct SimpleServer {

	public var routes = Routes()
	public var port = 8888
	public var address = "127.0.0.1"
	public func start() {
		do {
		try HTTPServer.launch(name: address, port: port, routes: routes, responseFilters: [])
		} catch {
			print("Unable start the server!")
		}
	}

	public init() { }
}
