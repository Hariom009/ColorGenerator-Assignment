import Foundation
import Network

class NetworkMonitor: ObservableObject{
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = false
    
    init(){
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                print("Internet Connection: \(self.isConnected ? "Online" : "Offline")")
            }
        }
        monitor.start(queue: queue)
    }
    func refreshConnectionStatus() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                print("Manual Check - Internet Connection: \(self.isConnected ? "Online" : "Offline")")
            }
            monitor.cancel() // Stop after getting the first result
        }
        monitor.start(queue: queue)
    }
}
