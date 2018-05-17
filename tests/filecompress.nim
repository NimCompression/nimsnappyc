import os, memfiles, streams
import nimsnappyc

if paramCount() < 1:
  echo "Usage: ", paramStr(0), " <filename>"
  quit(QuitFailure)

let fileName = paramStr(1)
let compressedFileName = fileName.changeFileExt("snapped")
let uncompressedFileName = fileName.changeFileExt("unsnapped")

var memFile = memfiles.open(fileName)
echo "Size of ", fileName, " = ", memFile.size

let compressedData = snappyCompress(memFile.mem, memFile.size)
memfiles.close(memFile)

echo "Compressed size = ", compressedData.len

var stream = newFileStream(compressedFileName, fmWrite)
stream.writeData(compressedData[0].unsafeAddr, compressedData.len)
stream.close

let uncompressedData = snappyUncompress(compressedData)

echo "Uncompressed size = ", uncompressedData.len

stream = newFileStream(uncompressedFilename, fmWrite)
stream.writeData(uncompressedData[0].unsafeAddr, uncompressedData.len)
stream.close

if sameFileContent(fileName, uncompressedFilename):
  echo "test is OK"
else:
  echo "Content of ", fileName, " and ", uncompressedFilename, " isn't equal!"
