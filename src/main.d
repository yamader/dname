import std;

import dname.proto.msg;

auto readable(ubyte[] chars) {
  return cast(string)(chars.map!(c => (0x1f < c && c < 0x7f) ? c : '.').array);
}

auto hexdump(ubyte[] bytes) {
  writeln("==========================================================================");
  scope (exit)
    writeln("==========================================================================");

  auto lines = bytes.length / 16;
  foreach (i; 0 .. lines) {
    auto start = 16 * i;
    writef(" %2d | ", i);
    foreach (j; 0 .. 16) {
      writef("%02x ", bytes[start + j]);
    }
    writefln("| (%s)", bytes[start .. start + 16].readable);
  }

  auto start = 16 * lines;
  auto amari = bytes.length - start;
  writef(" %2d | ", lines);
  foreach (j; 0 .. amari) {
    writef("%02x ", bytes[start + j]);
  }
  "   ".repeat(16 - amari).join.write;
  writefln("| (%s)", bytes[start .. $].readable);
}

auto main() {
  auto addr = new InternetAddress("0.0.0.0", 5353);
  auto sock = new UdpSocket;

  sock.bind(addr);

  while (true) {
    ubyte[512] buf;
    auto len = sock.receive(buf);
    buf[0 .. len].hexdump;
    auto msg = new Msg(buf[0 .. len]);
    msg.writeln;
  }
}
