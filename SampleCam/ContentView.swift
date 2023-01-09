import SwiftUI
import SystemExtensions

struct ContentView: View {
    @StateObject var installer = Installer()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    installer.install()
                } label: {
                    Text("install")
                }
                Button {
                    installer.uninstall()
                } label: {
                    Text("uninstall")
                }
            }
            Text(installer.message)
        }
    }
}

class Installer: NSObject, ObservableObject {
    @Published var message: String = ""
    
    func install() {
        let extensionIdentifier = "dev.noppe.SampleCam.Extension"
        let activationRequest = OSSystemExtensionRequest.activationRequest(
            forExtensionWithIdentifier: extensionIdentifier,
            queue: .main
        )
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }
    
    func uninstall() {
        let extensionIdentifier = "dev.noppe.SampleCam.Extension"
        let activationRequest = OSSystemExtensionRequest.deactivationRequest(
            forExtensionWithIdentifier: extensionIdentifier,
            queue: .main
        )
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }
}

extension Installer: OSSystemExtensionRequestDelegate {
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        print("Approval")
        message = #function
    }
    
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        print(result)
        message = "\(result)"
    }
    
    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        print(error)
        
        message = error.localizedDescription
    }
    
    
}
