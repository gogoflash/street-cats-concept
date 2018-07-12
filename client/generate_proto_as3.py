import os
import shutil
import subprocess

def main():

    protocGenDirPath = os.path.join(".", "protoc-gen-as3")

    os.chdir(protocGenDirPath)

    tempFolderName = "temp_proto"

    try:
        os.mkdir(tempFolderName)
    except:
        pass

    destPackage = "com.alisacasino.bingo.protocol"

    protocGenAS3Bin = "protoc-gen-as3.bat"

    sourceDirPath = os.path.join("..", "..", "..", "bingo-duel-server", "proto")

    sourceFiles = os.listdir(sourceDirPath)

    for sourceFileName in sourceFiles:
        print(sourceFileName)
        sourceFile = open(os.path.join(sourceDirPath, sourceFileName), "r")
        targetFile = open(os.path.join(tempFolderName, sourceFileName), "w")
        file_data = sourceFile.read()
        file_data = file_data.replace('syntax = "proto2";', 'syntax = "proto2";\npackage ' + destPackage + ';\n')
        targetFile.write(file_data)
        targetFile.close()
        sourceFile.close()


    modifiedFiles = os.listdir(tempFolderName)

    for fileName in modifiedFiles:
        print(fileName)
        argList = []
        argList.append("protoc.exe")
        argList.append("--proto_path=" + tempFolderName)
        argList.append("--plugin=protoc-gen-as3=" + protocGenAS3Bin)
        argList.append("--as3_out=" + os.path.join("..", "src"))
        argList.append(os.path.join(tempFolderName, fileName))
        print(argList)
        subprocess.call(argList)

    shutil.rmtree(tempFolderName)

    pass

main()