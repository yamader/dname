module dname.proto.query;

import std;

import dname.proto.msg;
import dname.proto.utils;

class Query {
  string name;
  Num!ushort type;
  Num!ushort clas;

  this(const ubyte[] buf, ref size_t hd) {
    name = parseName(buf, hd);
    hd += buf[hd .. $].nameLen;
    type.buf = buf[hd .. hd+=2];
    clas.buf = buf[hd .. hd+=2];
  }

  override string toString() =>
    format(`Query{%s %s %s}`, name, cast(Class)clas.val, cast(Type)type.val);
}
