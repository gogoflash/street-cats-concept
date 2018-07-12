__author__ = 'd.barabanschikov'

import os
import threading
import time
from PIL import Image


def set_to_neighbors(pixel_access, target_x, target_y, width, height):
    # print("setting ", target_x, target_y)
    neighbors = []

    for x in range(target_x - 2, target_x + 3):
        if x < 0 or x >= width:
            continue
        for y in range(target_y - 2, target_y + 3):
            if y < 0 or y >= height:
                continue
            if x == target_x and y == target_y:
                continue

            # print(x,y)

            source_pixel = pixel_access[x, y]
            if (source_pixel[3] > 0):
                neighbors.append(source_pixel)

    # print(len(neighbors))

    valid_neighbors = len(neighbors)

    if valid_neighbors > 0:
        r = 0
        g = 0
        b = 0
        for source_pixel in neighbors:
            r += source_pixel[0]
            g += source_pixel[1]
            b += source_pixel[2]

        # print(r,g,b)

        r /= valid_neighbors
        r = int(round(r))

        g /= valid_neighbors
        g = int(round(g))

        b /= valid_neighbors
        b = int(round(b))

        a = pixel_access[target_x, target_y][3]

        pixel_access[target_x, target_y] = (r, g, b, a)

    pass


def process_image(image_path:str):
    print(image_path)

    image = Image.open(image_path)
    print(image.format)
    pixel_access = image.load()

    width, height = image.size

    for x in range(width):
        for y in range(height):
            pixel = pixel_access[x, y]
            if (pixel[3] < 1):
                set_to_neighbors(pixel_access, x, y, width, height)

    image.save(image_path)
    print("Finished processing " + image_path)
    pass


def process_folder(dir_path: str):
    print("Processing folder")
    print(dir_path)

    dir_items_list = os.listdir(dir_path);

    threads = []

    for item_name in dir_items_list:
        print(item_name)
        item_path = os.path.join(dir_path, item_name)
        if(os.path.isdir(item_path)):
            process_folder(item_path)
        else:
            name, ext = os.path.splitext(item_name)
            if ext == '.png':
                thread = threading.Thread(None, process_image, name, (os.path.join(item_path), ))
                thread.start()
                threads.append(thread)

    for thread in threads:
        thread.join()

    print("PNG processing complete for " + dir_path)
    pass
