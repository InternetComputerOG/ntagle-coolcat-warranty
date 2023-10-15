export const idlFactory = ({ IDL }) => {
  const TagUid = IDL.Text;
  const Mapping = IDL.Record({ 'uid' : TagUid, 'cooler_id' : IDL.Text });
  const ImportMappingsResult = IDL.Variant({ 'Ok' : IDL.Null });
  const Hex = IDL.Text;
  const AESKey = IDL.Text;
  const TagEncodeResult = IDL.Record({ 'key' : AESKey });
  const TagCtr = IDL.Nat32;
  const CMAC = IDL.Text;
  const Scan = IDL.Record({ 'ctr' : TagCtr, 'uid' : TagUid, 'cmac' : CMAC });
  const Time = IDL.Int;
  const ScanResponse = IDL.Record({
    'cooler_id' : IDL.Text,
    'scans_left' : IDL.Nat32,
    'creation_date' : Time,
  });
  const ScanError = IDL.Variant({
    'TagNotFound' : IDL.Null,
    'ExpiredCount' : IDL.Text,
    'InvalidCMAC' : IDL.Text,
  });
  const ScanResult = IDL.Variant({ 'Ok' : ScanResponse, 'Err' : ScanError });
  const SDM = IDL.Service({
    'exportMappings' : IDL.Func([], [IDL.Vec(Mapping)], []),
    'importMappings' : IDL.Func(
        [IDL.Vec(IDL.Text)],
        [ImportMappingsResult],
        [],
      ),
    'registerTag' : IDL.Func([TagUid, IDL.Vec(Hex)], [TagEncodeResult], []),
    'scan' : IDL.Func([Scan], [ScanResult], []),
  });
  return SDM;
};
export const init = ({ IDL }) => { return []; };
