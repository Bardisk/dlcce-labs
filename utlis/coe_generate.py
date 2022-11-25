#!/usr/bin/python
import sys
from PIL import Image

# global parameters
coe_path = "out.coe"

def generate(pic_path, coe_path):
    '''
    parse a image to get the highest 4 bits of r,g,b
    :param path: picture path
    :return: array of pix, scanned by line
    '''
    im = Image.open(pic_path)
    pix = im.load()

    width = im.size[0]
    height = im.size[1]
    print("image width=%d,height=%d" % (width, height))
    
    with open(coe_path,'w') as f:
        f.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
        print(im.mode);
        for y in range(640):
            for x in range(512):
                if x >= height or y >= width:
                    if x == 511 and y == 1023:
                        f.write("000;\n")
                    else:
                        f.write("000,\n")
                    continue
                if im.mode=="RGB":
                    r, g, b = pix[y, x] #for RGB figures
                elif im.mode == "P":
                	r = g = b = pix[y, x]
                else:
                    r, g, b, a = pix[y, x] #for RGBA figures
                r = (r & 0xF0) >> 4
                g = (g & 0xF0) >> 4
                b = (b & 0xF0) >> 4
                f.write("%X%X%X,\n"%(r, g, b))
    print("finish successful!!")

if __name__ == "__main__":
    # useage: python coe_generate.py path-to-picture-file
    pic_path = sys.argv[1]
    if len(sys.argv) >= 2:
        coe_path = sys.argv[2]
    if coe_path.split('.')[-1] != "coe":
        print("Not a coe file, terminating...")
    else:
        generate(pic_path,coe_path)
