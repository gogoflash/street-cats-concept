import os
import subprocess
import png_filter
import convert_to_atf
from PIL import Image


def main():

    global texture_packer_path

    texture_packer_path = os.path.join("C:\\", "Program Files", "CodeAndWeb", "TexturePacker", "bin", "TexturePacker.exe")

    atlas_source_dir_path = os.path.join(".", "skins", "mobile", "cards")
    output_dir_path = os.path.join(".", "skins", "mobile", "cards")
    process_atlas_folder_with_scale(atlas_source_dir_path, output_dir_path, "720", 1.)
    process_atlas_folder_with_scale(atlas_source_dir_path, output_dir_path, "480", 0.6667)

    atlas_source_dir_path = os.path.join(".", "skins", "tablet", "cards")
    output_dir_path = os.path.join(".", "skins", "tablet", "cards")
    process_atlas_folder_with_scale(atlas_source_dir_path, output_dir_path, "720", 1.)
    process_atlas_folder_with_scale(atlas_source_dir_path, output_dir_path, "480", 0.6667)
	
    atlas_source_dir_path = os.path.join(".", "skins", "daubers")
    output_dir_path = os.path.join(".", "skins", "daubers")
    process_atlas_folder_with_scale(atlas_source_dir_path, output_dir_path, "720", 1.)
    process_atlas_folder_with_scale(atlas_source_dir_path, output_dir_path, "480", 0.6667)


def process_atlas_folder_with_scale(image_dir_path:str, output_path:str, scale_name:str, scale:float):
    dirs = os.listdir(image_dir_path)

    argList = []

    argList.append("--format")
    argList.append("sparrow")

    argList.append("--size-constraints")
    argList.append("POT")

    argList.append("--scale")
    argList.append(str(scale))

    output_folder_path = os.path.join("..", "assets_dist", scale_name, output_path)

    for imageFolderName in dirs:
        print(imageFolderName)
        imageFolderPath = os.path.join(image_dir_path, imageFolderName)

        fullArgList = [texture_packer_path, imageFolderPath]
        fullArgList += argList

        outputImageName = imageFolderName + ".png"
        outputDataFileName = imageFolderName + ".xml"

        fullArgList.append("--sheet")
        fullArgList.append(os.path.join(output_folder_path, outputImageName))

        fullArgList.append("--data")
        fullArgList.append(os.path.join(output_folder_path, outputDataFileName))

        print(subprocess.call(fullArgList))

    png_filter.process_folder(output_folder_path)
    convert_to_atf.processFolder(output_folder_path)

    pass

main()
