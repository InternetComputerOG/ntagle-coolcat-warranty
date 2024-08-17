//  ----------- Decription
//  This Motoko file contains the logic of the backend canister.

//  ----------- Imports

//  Imports from Motoko Base Library
import Array        "mo:base/Array";
import Bool         "mo:base/Bool";
import Blob         "mo:base/Blob";
import Buffer       "mo:base/Buffer";
import Hash         "mo:base/Hash";
import Int          "mo:base/Int";
import Iter         "mo:base/Iter";
import Nat          "mo:base/Nat";
import Nat32        "mo:base/Nat32";
import Nat64        "mo:base/Nat64";
import Option       "mo:base/Option";
import Principal    "mo:base/Principal";
import Text         "mo:base/Text";
import Time         "mo:base/Time";
import TrieMap      "mo:base/TrieMap";

//  Imports from helpers, utils, & types
import Hex          "lib/Hex";
import T            "types";
import Helpers      "helpers";

//  Imports from external interfaces


shared actor class SDM() = this {

  //  ----------- Variables
  private stable var tag_total : Nat32 = 0;
  let tag_key : Hex.Hex = "38513c477c59cf1e9181b4a9bb139413";
  let admins : [Principal] = [
    
    //  Isaac's Plug Wallet
    Principal.fromText("gj3h2-k3kw2-ciszt-6zylp-azl7o-mvg5j-eudtf-fpejf-mx2rd-ifsul-dqe")
    
  ];

  //  ----------- State
  private stable var tagsEntries : [(T.TagUid, T.Tag)] = [];
  private let tags : TrieMap.TrieMap<T.TagUid, T.Tag> = TrieMap.fromEntries<T.TagUid, T.Tag>(tagsEntries.vals(), Text.equal, Text.hash);

  //  ----------- Configure external actors


  //  ----------- Public functions

  //  Encoding
  public shared({ caller }) func registerTag(
    uid : T.TagUid, 
    data : [Hex.Hex]
    ) : async T.TagEncodeResult {
      assert false;
      assert not _tag_exists(uid);

      await _registerTag(uid, data);
  };

  //  Scan
  public shared({ caller }) func scan(scan : T.Scan) : async T.ScanResult {
    // assert _isCanister(caller);
    _scan(scan);
  };

  //  Mappings
  public shared({ caller }) func importMappings(data : [Text]) : async T.ImportMappingsResult {
    assert false;
    _importMappings(data);
  };

  //  Tag Info
  public shared({ caller }) func exportMappings() : async [T.Mapping] {
    assert false;
    _exportMappings();
  };

  //  ----------- Directly called private functions

  //  Encoding
  private func _registerTag( 
    uid : T.TagUid,
    data : [Hex.Hex]
    ) : async T.TagEncodeResult {

      let new_tag = {
        index = tag_total;
        ctr = 0 : Nat32;
        cmacs = data;
        creation_date = Time.now();
        cooler_id = "Unassigned";
      };

      tags.put(uid, new_tag);
      tag_total += 1;

      let result = {
        key = tag_key;
      }; 

      return result;
  };

  private func _isAdmin (p: Principal) : Bool {
    return Helpers.contains<Principal>(admins, p, Principal.equal);
  };

  //  Scan
  private func _scan( 
    scan : T.Scan
    ) : T.ScanResult {
      switch (tags.get(scan.uid)) {
        case (?tag) {

          //  Check CMAC
          if (tag.cmacs[Nat32.toNat(scan.ctr)] != scan.cmac) {
            return #Err(#InvalidCMAC(tag.cooler_id));
          };

          // Check Count
          // if (tag.ctr >= scan.ctr) {
          //   return #Err(#ExpiredCount(tag.cooler_id));
          // };

          //  Updating Tag
          let new_tag : T.Tag = {
            index = tag.index;
            ctr = scan.ctr;  //  Update count to the most recent scan.
            cmacs = tag.cmacs;
            cooler_id = tag.cooler_id;
            creation_date = tag.creation_date;
          };

          tags.put(scan.uid, new_tag);

          //  Preparing Result
          var result : T.ScanResponse = {
            cooler_id = tag.cooler_id;
            scans_left = 5_000 - scan.ctr;
            creation_date = tag.creation_date;
          };

          return #Ok(result);
        };

        case _ {
          return #Err(#TagNotFound);
        };
      };
  };

  private func _importMappings(data : [Text]) : T.ImportMappingsResult {
    for ((uid, tag) in tags.entries()) {
      var new_cooler_id = "Unassigned";

      if (data.size() > Nat32.toNat(tag.index)) {
        new_cooler_id := data[Nat32.toNat(tag.index)];
      };

      //  Updating Tag
      let new_tag : T.Tag = {
        index = tag.index;
        ctr = tag.ctr;  //  Update count to the most recent scan.
        cmacs = tag.cmacs;
        cooler_id = new_cooler_id;
        creation_date = tag.creation_date;
      };

      tags.put(uid, new_tag);
    };

    return #Ok;
  };

  private func _exportMappings() : [T.Mapping] {
    var exportData : [var T.Mapping] = Array.init<T.Mapping>(
      Nat32.toNat(tag_total),
      {
        uid = "Undefined";
        cooler_id = "Undefined";
      }
    );

    for ((uid, tag) in tags.entries()) {
      exportData[Nat32.toNat(tag.index)] := {
        uid = uid;
        cooler_id = tag.cooler_id;
      };
    };

    return Array.freeze(exportData);
  };

  //  ----------- Boolean helper functions
  private func _tag_exists(uid : T.TagUid) : Bool {
    return Option.isSome(tags.get(uid));
  };

  private func _isCanister(caller : Principal) : Bool {
    return Helpers.isCanisterPrincipal(caller);
  };

  //  ----------- System functions
  system func preupgrade() {
    tagsEntries := Iter.toArray(tags.entries());
  };

  system func postupgrade() {
    tagsEntries := [];
  };
};