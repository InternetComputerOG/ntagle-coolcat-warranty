import Bool         "mo:base/Bool";
import Blob         "mo:base/Blob";
import Float        "mo:base/Float";
import Nat32        "mo:base/Nat32";
import Nat64        "mo:base/Nat64";
import Principal    "mo:base/Principal";
import Text         "mo:base/Text";
import Time         "mo:base/Time";

import Hex          "lib/Hex";

module {
  
  //  ----------- State
  //  Tag
  public type Tag = {
    index : TagIndex;
    ctr : TagCtr;
    cmacs : [Hex.Hex];
    salt : AESKey;
    creation_date : Time.Time;
  };

  //  Integrations 
  public type Integration = {
    canister : Principal;
    uid : TagUid;
    hashed_access_code : Hex.Hex;
    last_access_key_change : Time.Time;
  };
  
  //  Redefinitions
  public type TagIndex = Nat32;
  public type TagCtr = Nat32;

  //  56-byte array as Hex String
  public type TagUid = Hex.Hex;

  //  32-byte array as Hex string.
  public type TagIdentifier = Hex.Hex;

  //  32-byte array as Hex string.
  public type ValidationIdentifier = Hex.Hex;

  //  32-byte array as Hex string.
  public type AESKey = Hex.Hex;

  //  16-byte array as Hex string.
  public type CMAC = Hex.Hex;

  //  ----------- Functions
  //  Scanning
  public type Scan = {
    uid : TagUid;
    ctr : TagCtr;
    cmac : CMAC;
  };

  public type ScanResult = {
    #Ok : ScanResponse;
    #Err : ScanError;
  };

  public type ScanResponse = {
    validation : ValidationIdentifier;
    access_code : AESKey;
    scans_left : Nat32;
    years_left : Nat;
  };

  public type ScanError = {
    #TagNotFound;  //  Tag UID not found.
    #InvalidCMAC;
    #ExpiredCount;  //  The scan count was lower than the last valid scan logged by the canister.
  };

  //  Encoding
  public type TagEncodeResult = {
    key: AESKey;
  };

  public type ImportCMACResult = {
    #Ok;
    #Err;
  };
  
  //  Validation
  public type ValidationRequest = {
    access_code : AESKey;
    validation : ValidationIdentifier;
  };

  public type ValidationResult = {
    #Ok : ValidationResponse;
    #Err : ValidationError;
  };

  public type ValidationResponse = {
    tag : TagIdentifier;
    last_access_key_change : Time.Time;
  };

  public type ValidationError = {
    #ValidationNotFound;
    #IntegrationNotFound;
    #NotAuthorized;  //  Caller canister not authorized. 
    #TagNotFound;
    #Invalid;  //  The Access Code was not valid.
    #Expired; //  The Access Code was more than 10 minutes old.
  };

  //  Tag Info
  public type TagInfoResult = {
    #Ok : TagInfoResponse;
    #Err : TagInfoError;
  };

  public type TagInfoResponse = {
    last_access_key_change : Time.Time;
  };

  public type TagInfoError = {
    #IntegrationNotFound;
    #NotAuthorized;  //  Caller canister not authorized. 
    #TagNotFound;  //  Tag Identifier not found in Integration list. 
  };

}