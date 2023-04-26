module dname.proto.rr;

import std;

import dname.proto.msg;
import dname.proto.utils;

class RR {
  string name;
  Num!ushort type;
  Num!ushort clas;
  Num!uint ttl;
  Num!ushort rdlen;
  const ubyte[] rdata;

  this(const ubyte[] buf, ref size_t hd) {
    name = parseName(buf, hd);
    hd += buf[hd .. $].nameLen;
    type.buf = buf[hd .. hd+=2];
    clas.buf = buf[hd .. hd+=2];
    ttl.buf = buf[hd .. hd+=4];
    rdlen.buf = buf[hd .. hd+=2];
    rdata = buf[hd .. hd+=rdlen.val];
  }

  override string toString() =>
    format(`RR{%s %s %s %s [%s]}`,
      name, ttl, cast(Class)clas.val, cast(Type)type.val, rdlen);
}
