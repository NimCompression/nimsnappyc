import nimsnappyc/snappyc

type
  SnappyError* = object of Exception

proc snappyMaxCompressedLength*(inputLen: int): int =
  snappyc.snappy_max_compressed_length(inputLen).int

proc snappyUncompressedLength*(input: string | seq[byte] | openarray[byte]): uint =
  var
    inputAddr = input[0].unsafeAddr
    inputLen = input.len
    uncompressedLength: csize

  let res = snappy_uncompressed_length(inputAddr, inputLen, uncompressedLength.addr)
  if not res: raise newException(SnappyError, "Uncompressed length error")

  result = uncompressedLength.uint

template snappyCompressImpl =
  var
    env: SnappyEnv
    compressedLength: csize

  if snappy_init_env(env.addr) != 0: raise newException(SnappyError, "Env's init error")

  let res = snappy_compress(env.addr, inputAddr, inputLen,
                                    result[0].addr, compressedLength.addr)
  if res != 0: raise newException(SnappyError, "Compress error")
  snappy_free_env(env.addr)
  result.setLen(compressedLength)

proc snappyCompress*(inputAddr: pointer, inputLen: int): seq[byte] =
  if inputLen == 0:
    return newSeq[byte]()
  else:
    let maxLen = snappyc.snappy_max_compressed_length(inputLen).int

    result = newSeqUninitialized[byte](maxLen)
    snappyCompressImpl

proc snappyCompress*(input: string): string =
  let inputLen = input.len

  if inputLen == 0:
    return ""
  else:
    let inputAddr = input[0].unsafeAddr
    let maxLen = snappyc.snappy_max_compressed_length(inputLen).int

    result = newString(maxLen)
    snappyCompressImpl

proc snappyCompress*[T](input: T): seq[byte] =
  var
    inputAddr: pointer
    inputLen: int

  when T is string | seq | openarray:
    if input.len == 0:
      return newSeq[byte]()

    inputAddr = input[0].unsafeAddr
    inputLen = input[0].sizeof * input.len
  else:
    inputAddr = input.unsafeAddr
    inputLen = input.sizeof

  let maxLen = snappyc.snappy_max_compressed_length(inputLen).int

  result = newSeqUninitialized[byte](maxLen)
  snappyCompressImpl

template snappyUncompressImpl =
  var
    uncompressedLength: csize
  let res = snappy_uncompressed_length(inputAddr, inputLen, uncompressedLength.addr)
  if not res: raise newException(SnappyError, "Uncompress error")

  let uncompressRes = snappy_uncompress(inputAddr, inputLen, result[0].addr)
  if uncompressRes != 0: raise newException(SnappyError, "Uncompress error")

proc snappyUncompress*(input: seq[byte] | openarray[byte]): seq[byte] =
  if input.len == 0:
    return newSeq[byte]()

  let
    inputAddr = input[0].unsafeAddr
    inputLen = input.len

  result = newSeqUninitialized[byte](snappyUncompressedLength(input))
  snappyUncompressImpl

proc snappyUncompress*(input: string): string =
  if input.len == 0:
    return ""

  let
    inputAddr = input[0].unsafeAddr
    inputLen = input.len

  result = newString(snappyUncompressedLength(input))
  snappyUncompressImpl
