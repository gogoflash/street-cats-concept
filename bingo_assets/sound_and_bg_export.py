import os

import shutil
from PIL import Image

def main():
    background_source_path = os.path.join(".", "backgrounds")
    background_dist_path = os.path.join("..", "assets_dist", "backgrounds")
    copy_over(background_source_path, background_dist_path)

    soundtrack_source_path = os.path.join(".", "sounds", "tracks")
    soundtrack_dist_path = os.path.join("..", "assets_dist", "sounds", "tracks")
    copy_over(soundtrack_source_path, soundtrack_dist_path)

    voiceover_source_path = os.path.join(".", "sounds", "voiceover")
    voiceover_dist_path = os.path.join("..", "assets_dist", "sounds", "voiceover")
    copy_over(voiceover_source_path, voiceover_dist_path)

    sfx_source_path = os.path.join(".", "sounds", "sfx")
    sfx_dist_path = os.path.join("..", "assets_dist", "sounds", "sfx")
    copy_over(sfx_source_path, sfx_dist_path)

def copy_over(source_path:str, dest_path:str):

    dir_items_list = os.listdir(source_path)

    try:
        os.makedirs(dest_path)
    except:
        pass

    for item_name in dir_items_list:
        item_source_path = os.path.join(source_path, item_name)
        item_dest_path = os.path.join(dest_path, item_name)

        if(os.path.isdir(item_source_path)):
            try:
                os.makedirs(item_dest_path)
                print(item_dest_path)
            except:
                print("failed to make file")
                pass
            copy_over(item_source_path,item_dest_path)
        else:
            print("Copying " + item_source_path)
            shutil.copy(item_source_path, item_dest_path)

    pass

main()
