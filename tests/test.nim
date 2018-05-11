import nimsnappyc

let data = "0123456789abcdef"
let compressed = snappyCompress(data)

echo "data length              = ", data.len
echo "compressed length        = ", compressed.len
echo "Max. compressed length   = ", snappyMaxCompressedLength(data.len)
echo "uncompressed length      = ", snappyUncompressedLength(compressed)

let uncompressed = snappyUncompress(compressed)

echo "uncompressed length      = ", uncompressed.len
echo "uncompressed data        = ", uncompressed
