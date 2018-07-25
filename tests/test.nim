import nimsnappyc
import unittest

echo "hostOS: ", hostOS
echo "hostCPU: ", hostCPU

suite "Snappy tests":

  test "Seq compress/uncompress":
    let data = @[48'u8, 49, 50, 51, 52, 53, 54, 55, 56, 57]
    let compressed = snappyCompress(data)
    let uncompressed = snappyUncompress(compressed)
    check data == uncompressed

  test "OpenArray compress/uncompress":
    let data = @[48'u8, 49, 50, 51, 52, 53, 54, 55, 56, 57]
    let compressed = snappyCompress(data.toOpenArray(0, data.high))
    let uncompressed = snappyUncompress(compressed.toOpenArray(0, compressed.high))
    check data == uncompressed

  test "String compress/uncompress":
    let data = "0123456789"
    let compressed = snappyCompress(data)
    let uncompressed = snappyUncompress(compressed)
    check data == uncompressed
