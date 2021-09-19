import Hype
import Foundation

// Probably some .env equivalent for IOS like in Info.plist... god...
let hypeAppID: String = "969f6cb2"
let hypeAccessToken: String = "373e0d803985df37" // please dont push me...

typealias HypeListener = (String) -> Void

/*
 Leaving this in for thinking:
 
 On connect to another device:
  - Send Current UID (e.g. this has to be merged with Interface)
 
 On receive message from other device:
  - Lookup other UID (/profile)
  - Add Person to nearby list

 On disconnect:
  - Remove person from list
 
 */
