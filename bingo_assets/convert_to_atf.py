import os
import subprocess
import configparser

def processFolder(folder_path:str):

    global png2atf_path

    convert_config = configparser.ConfigParser()
    convert_config.read('asset_settings.ini')

    png2atf_path = os.path.join(".", "png2atf", "png2atf.exe")

    convertFolderToAtf(folder_path, convert_config)

def convertFolderToAtf(imageDirPath:str, convert_config):
    dirs = os.listdir(imageDirPath)

    argList = []

    argList.append("-n")
    argList.append("0,0")

    argList.append("-4")

    quality_settings = convert_config['Quality']

    for item_name in dirs:
        full_item_path = os.path.join(imageDirPath, item_name)

        if os.path.isdir(full_item_path):
            processFolder(full_item_path, convert_config)
            continue

        path_sans_extenstion, null = os.path.splitext(full_item_path)
        file_name, item_extension = os.path.splitext(item_name)

        if item_extension!=".png":
            continue

        fullArgList = [png2atf_path, full_item_path]
        fullArgList += argList

        quality = quality_settings.get(file_name, 10)

        fullArgList.append("-q")
        fullArgList.append(str(quality))

        fullArgList.append("-i")
        fullArgList.append(full_item_path)

        fullArgList.append("-o")
        fullArgList.append(path_sans_extenstion + ".atf")

        print('\n\n' + full_item_path)
        print('quality ' + str(quality))
        print(path_sans_extenstion + ".atf")

        print(subprocess.call(fullArgList))

        if os.path.getsize(path_sans_extenstion+".atf") == 0:
            os.remove(path_sans_extenstion + ".atf")
        
    pass