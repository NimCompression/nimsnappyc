{.compile: "private/snappy.c".}

type
  SnappyEnv* = object
    hash_table: pointer
    scratch: pointer
    scratch_output: pointer
  PSnappyEnv* = ptr SnappyEnv

proc snappy_uncompressed_length*(input: pointer, inputLength: csize, result: ptr csize): bool {.importc.}
proc snappy_max_compressed_length*(inputLength: csize): csize {.importc.}

proc snappy_init_env*(env: PSnappyEnv): cint {.importc.}
proc snappy_free_env*(env: PSnappyEnv) {.importc.}

proc snappy_compress*(env: PSnappyEnv, input: pointer, inputLength: csize,
                     compressed: pointer, compressedLength: ptr csize): cint {.importc.}
proc snappy_uncompress*(compressed: pointer, compressedLength: csize, uncompressed: pointer): cint {.importc.}