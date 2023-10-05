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
    creation_date : Time.Time;
    cooler_id : Text;
  };
  
  //  Redefinitions
  public type TagIndex = Nat32;
  public type TagCtr = Nat32;

  //  56-byte array as Hex String
  public type TagUid = Hex.Hex;

  //  16-byte array as Hex string.
  public type CMAC = Hex.Hex;

  //  32-byte array as Hex string.
  public type AESKey = Hex.Hex;

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
    cooler_id : Text;
    scans_left : Nat32;
    creation_date : Time.Time;
  };

  public type ScanError = {
    #TagNotFound;  //  Tag UID not found.
    #InvalidCMAC : Text;
    #ExpiredCount : Text;  //  The scan count was lower than the last valid scan logged by the canister.
  };

  //  Encoding
  public type TagEncodeResult = {
    key: AESKey;
  };

  //  Mappings
  public type ImportMappingsResult = {
    #Ok;
  };

  public type Mapping = {
    uid : TagUid;
    cooler_id : Text;
  };
}