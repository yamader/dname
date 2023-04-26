module dname.proto.utils;

import std;

union Num(T) {
  ubyte[T.sizeof] buf;

  T val() const => buf.bigEndianToNative!T;
  T val(T n) {
    buf = n.nativeToBigEndian;
    return n;
  }

  auto toString() => val.to!string;
}

size_t nameLen(const ubyte[] buf) {
  size_t s = 1;
  for(size_t i; i < buf.length; ++i) {
    // zero
    if(!buf[i]) break;
    // pointer
    if((buf[i] & 0x30) == 0x30) {
      s++;
      break;
    }
    // label
    s += buf[i] + 1;
    i += buf[i];
  }
  return s;
}

string parseName(const ubyte[] buf, size_t offset) {
  string res;
  for (size_t i = offset; i < buf.length; ++i) {
    // zero
    if (!buf[i]) break;
    // pointer
    if((buf[i] & 0x30) == 0x30) {
      res ~= parseName(buf, buf[i] ^ 0x30);
      break;
    }
    // label
    res ~= buf[i+1 .. i+1+buf[i]] ~ '.';
    i += buf[i];
  }
  return res;
}
