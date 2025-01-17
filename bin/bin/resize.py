import sys
from PIL import Image

width = 150
img = Image.open(sys.argv[1])
w_rate = width / float(img.size[0])
height = int(img.size[1] * w_rate)
img = img.resize((width, height), Image.Resampling.LANCZOS)
img.save(sys.argv[1])
