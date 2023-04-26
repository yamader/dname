module dname.proto.header;

import std;

import dname.proto.utils;

union Header {
  ubyte[12] buf;
  struct {
   align(1):
    Num!ushort id;

    union {
      ubyte[2] _flags;

      bool qr() const => cast(bool)(_flags[0] & 0x80);
      ubyte op() const => _flags[0] >> 3 & 7;
      bool aa() const => cast(bool)(_flags[0] & 4);
      bool tc() const => cast(bool)(_flags[0] & 2);
      bool rd() const => cast(bool)(_flags[0] & 1);
      bool ra() const => cast(bool)(_flags[1] & 0x80);
      ubyte res() const => _flags[1] & 0xf;

      bool qr(bool val) { _flags[0] = _flags[0] & 0x7f | val << 7; return val; }
      ubyte op(ubyte val) {
        val &= 7;
        _flags[0] = cast(ubyte)(_flags[0] & 0x87 | val << 4);
        return val;
      }
      bool aa(bool val) { _flags[0] = _flags[0] & 0xfb | val << 2; return val; }
      bool tc(bool val) { _flags[0] = _flags[0] & 0xfd | val << 1; return val; }
      bool rd(bool val) { _flags[0] = _flags[0] & 0xfe | val; return val; }
      bool ra(bool val) { _flags[1] = _flags[1] & 0x7f | val << 7; return val; }
      ubyte res(ubyte val) { val &= 0xf; _flags[1] = _flags[1] & 0xf0 | val; return val; }
    }

    Num!ushort qdn;
    Num!ushort ann;
    Num!ushort nsn;
    Num!ushort arn;

    auto toString() => [
        "Header:",
        " ID: " ~ format("%#x", id.val),
        " QR: " ~ qr.to!string ~
        "\tOP: " ~ op.to!string ~
        "\tAA: " ~ aa.to!string ~
        "\tTC: " ~ tc.to!string ~
        "\tRD: " ~ rd.to!string ~
        "\tRA: " ~ ra.to!string ~
        "\tres: " ~ res.to!string,
        " QD: " ~ qdn.to!string ~
        "\tAN: " ~ ann.to!string ~
        "\tNS: " ~ nsn.to!string ~
        "\tAR: " ~ arn.to!string,
      ].join('\n');
  }
}
