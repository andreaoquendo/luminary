//
//  AppIntent.swift
//  Luminary
//
//  Created by Andrea Oquendo on 27/09/23.
//

import Foundation
import Intents

class AppIntent {
    
    class func allowSiri() {
        INPreferences.requestSiriAuthorization{ status in
            switch status {
            case .notDetermined, .restricted, .denied:
                print("Siri error.")
            case .authorized:
                print("Siri ok.")
            }
            
        }
    }
    
    class func quoteSiri() {
        let intent = QuoteIntentIntent()
        intent.suggestedInvocationPhrase = "Save my today's quote"
        intent.quote = "ehisso?"
        
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate{ error in
            if let error = error as NSError? {
                print("Interaction donation failed: \(error.description)")
                
            } else {
                print("Success")
            }
        }
    }
    
}
