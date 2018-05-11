import nimsnappyc/snappyc

type
  SnappyError* = object of Exception

proc snappyCompress*[T](input: T): seq[byte] =
  var
    inputAddr: pointer
    inputLen: int
    env: SnappyEnv
    compressedLength: csize

  if snappy_init_env(env.addr) != 0: raise newException(SnappyError, "Env's init error")

  when T is string | seq:
    inputAddr = input[0].unsafeAddr
    inputLen = input[0].sizeof * input.len
  else:
    inputAddr = input.unsafeAddr
    inputLen = input.sizeof

  let maxLen = snappy_max_compressed_length(inputLen)
  result = newSeqUninitialized[byte](maxLen)
  let res = snappy_compress(env.addr, inputAddr, inputLen,
                                    result[0].addr, compressedLength.addr)
  if res != 0: raise newException(SnappyError, "Compress error")
  snappy_free_env(env.addr)
  result.setLen(compressedLength)

proc snappyUncompress*(input: seq[byte]): seq[byte] =
  var
    inputAddr = input[0].unsafeAddr
    inputLen = input.len
    uncompressedLength: csize

  let res = snappy_uncompressed_length(inputAddr, inputLen, uncompressedLength.addr)
  if not res: raise newException(SnappyError, "Uncompress error")

  result = newSeqUninitialized[byte](uncompressedLength)

  let uncompressRes = snappy_uncompress(inputAddr, inputLen, result[0].addr)
  if uncompressRes != 0: raise newException(SnappyError, "Uncompress error")

proc snappyUncompressedLength*(input: seq[byte]): uint =
  var
    inputAddr = input[0].unsafeAddr
    inputLen = input.len
    uncompressedLength: csize

  let res = snappy_uncompressed_length(inputAddr, inputLen, uncompressedLength.addr)
  if not res: raise newException(SnappyError, "Uncompressed length error")

  result = uncompressedLength.uint

proc snappyMaxCompressedLength*(inputLen: int): int =
  snappyc.snappy_max_compressed_length(inputLen).int