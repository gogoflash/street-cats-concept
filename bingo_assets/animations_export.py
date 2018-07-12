import os
import subprocess
import datetime


def main():

    global gaf_path
    global export_folder

    gaf_path = os.path.join("C:\\", "Program Files (x86)", "GAF-Converter", "GAF-Converter-CLI.exe")

    source_folder = os.path.join(".", "animations_source")
    export_folder = os.path.join("..", "assets_dist")

    processFolderWithScale(source_folder, "720", 1.)
    processFolderWithScale(source_folder, "480", 0.6667)

def processFolderWithScale(imageDirPath:str, scaleName:str, scale:float):
    swf_files = os.listdir(imageDirPath)

    argList = []

    argList.append("-output-dir")
    argList.append(os.path.join(export_folder, scaleName, "animations"))

    #argList.append("-save-as-zip")
    #argList.append("false")

    argList.append("-scale")
    argList.append(str(scale))
    
    argList.append("-conversion-source")
    argList.append("root")
    argList.append("library")

    for swf_file_name in swf_files:

        itemFileName, itemExtension = os.path.splitext(swf_file_name)

        if itemExtension!=".swf":
            continue



        print(swf_file_name)

        swf_file_path = os.path.join(imageDirPath, swf_file_name)
        target_file_path = os.path.join(export_folder, scaleName, "animations", itemFileName + ".zip")

        source_file_modification_time = datetime.datetime.fromtimestamp(os.path.getmtime(swf_file_path))
        
        if(os.path.exists(target_file_path)):
            target_file_modification_time = datetime.datetime.fromtimestamp(os.path.getmtime(target_file_path))
            if(target_file_modification_time >= source_file_modification_time):
                print(target_file_path + " is newer than source")
                continue

        fullArgList = [gaf_path]

        fullArgList.append("-swf-file")
        fullArgList.append(swf_file_path)

        fullArgList += argList

        print(subprocess.call(fullArgList))

    pass

main()