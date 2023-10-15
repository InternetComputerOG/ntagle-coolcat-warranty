import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type AESKey = string;
export type CMAC = string;
export type Hex = string;
export type ImportMappingsResult = { 'Ok' : null };
export interface Mapping { 'uid' : TagUid, 'cooler_id' : string }
export interface SDM {
  'exportMappings' : ActorMethod<[], Array<Mapping>>,
  'importMappings' : ActorMethod<[Array<string>], ImportMappingsResult>,
  'registerTag' : ActorMethod<[TagUid, Array<Hex>], TagEncodeResult>,
  'scan' : ActorMethod<[Scan], ScanResult>,
}
export interface Scan { 'ctr' : TagCtr, 'uid' : TagUid, 'cmac' : CMAC }
export type ScanError = { 'TagNotFound' : null } |
  { 'ExpiredCount' : string } |
  { 'InvalidCMAC' : string };
export interface ScanResponse {
  'cooler_id' : string,
  'scans_left' : number,
  'creation_date' : Time,
}
export type ScanResult = { 'Ok' : ScanResponse } |
  { 'Err' : ScanError };
export type TagCtr = number;
export interface TagEncodeResult { 'key' : AESKey }
export type TagUid = string;
export type Time = bigint;
export interface _SERVICE extends SDM {}
