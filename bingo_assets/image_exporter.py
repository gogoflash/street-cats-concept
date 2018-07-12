import os

from PIL import Image

def main():
    image_source_dir_path = os.path.join(".", "images")
    process_image_folder_with_scale(image_source_dir_path, "720", 1.)
    process_image_folder_with_scale(image_source_dir_path, "480", 0.6667)

def process_image_folder_with_scale(image_dir_path:str, scale_name:str, scale:float):

    print(image_dir_path)

    dir_items_list = os.listdir(image_dir_path)


    for item_name in dir_items_list:
        print(item_name)

        output_dir_path = os.path.join("..", "assets_dist", scale_name, image_dir_path)

        try:
            os.mkdir(output_dir_path)
        except:
            pass

        item_path = os.path.join(image_dir_path, item_name)
        if os.path.isdir(item_path):
            process_image_folder_with_scale(item_path, scale_name, scale)
        else:
            name, ext = os.path.splitext(item_name)
            if ext == '.png':
                print("Resampling image " + item_path)
                image = Image.open(item_path)
                print(image.format)

                image = image.resize(tuple(int(round(scale*x)) for x in image.size), Image.LANCZOS)

                destination_path = os.path.join(output_dir_path, item_name)

                image.save(destination_path)

    pass

main()