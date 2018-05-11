# NimSnappyC

**NimSnappyC** provides a Snappy compression/decompression for [Nim](https://nim-lang.org) through wrapping to [snappy-c](https://github.com/andikleen/snappy-c).

**[GitHub Repo](https://github.com/data-man/nimsnappyc)**

## Installation

Add this to your application's .nimble file:

```nim
requires "nimsnappyc"
```

or to install globally run:

```
nimble install nimsnappyc
```

## Usage

```nim
import nimsnappyc

# Compress a string:
let data = "0123456789abcdef"
let compressed = snappyCompress(data)

# Get the uncompressed length of compressed data:
let uncompressedLen = snappyUncompressedLength(compressed)

# Uncompress a compressed data:
let uncompressed = snappyUncompress(compressed)
```

## Contributing

1. Fork it (https://github.com/data-man/nimsnappyc/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License
MIT
Author: [Dmitry Atamanov](https://github.com/data-man)

## Snappy-C License
BSD 3-Clause License
Author: [Andi Kleen](https://github.com/andikleen)
