import nimsnappyc

let data = "0123456789abcdef"
let compressed = snappyCompress(data)

echo "Original data            = ", data
echo "data length              = ", data.len
echo "compressed.len           = ", compressed.len
echo "Max. compressed length   = ", snappyMaxCompressedLength(data.len)
echo "uncompressed length      = ", snappyUncompressedLength(compressed)

let uncompressed = snappyUncompress(compressed)

echo "uncompressed.len         = ", uncompressed.len
echo "uncompressed data        = ", uncompressed
