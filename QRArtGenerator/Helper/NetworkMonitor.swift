//
//  NetworkMonitor.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 22/08/2023.
//

import NetworkExtension

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    @Published var isConnected = true

    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if self.isConnected != ( path.status == .satisfied) {
                    self.isConnected = path.status == .satisfied
                }
                Task {
                    await MainActor.run {
                        self.objectWillChange.send()
                    }
                }
            }
          
        }
        networkMonitor.start(queue: workerQueue)
    }
}
