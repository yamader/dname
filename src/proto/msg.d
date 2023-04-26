module dname.proto.msg;

import std;

import dname.proto.header;
import dname.proto.query;
import dname.proto.rr;

enum Type: ushort {
  // RFC 1035
  A = 1, NS, MD, MF, CNAME, SOA, MB, MG, MR, NULL, WKS, PTR, HINFO, MINFO, MX, TXT,

  // QTYPE (Query only)
  // RFC 1035
  AXFR = 252, MAILB, MAILA, ANY,
}

enum Class: ushort {
  // RFC 1035
  IN = 1, CS, CH, HS,

  // QCLASS (Query only)
  // RFC 1035
  all = 255,
}

class Msg {
  Header hdr;
  Query[] query;
  RR[] ans;
  RR[] auth;
  RR[] add;

  this(ubyte[] buf) {
    hdr.buf = buf[0 .. 12];

    size_t hd = 12; // head (offset)
    foreach (_; 0 .. hdr.qdn.val) query ~= new Query(buf, hd);
    foreach (_; 0 .. hdr.ann.val) ans ~= new RR(buf, hd);
    foreach (_; 0 .. hdr.nsn.val) auth ~= new RR(buf, hd);
    foreach (_; 0 .. hdr.arn.val) add ~= new RR(buf, hd);
  }

  override string toString() => [
      hdr.toString,
      "Query: [" ~ query.map!(to!string).join(",\t") ~ "]",
      "Ans:   [" ~ ans.map!(to!string).join(",\t") ~ "]",
      "Auth:  [" ~ auth.map!(to!string).join(",\t") ~ "]",
      "Add:   [" ~ add.map!(to!string).join(",\t") ~ "]",
    ].join('\n');
}
