# tools/make_menu_assets.py  ->  assets/ui/btn_*.png (24x16, ใช้เป็น 9-slice)
import os
from PIL import Image

def make_btn(fill, hi, path, border=(20, 12, 40, 255)):
    im = Image.new("RGBA", (24, 16), border)
    px = im.load()
    for y in range(1, 15):
        for x in range(1, 23):
            px[x, y] = fill
    for x in range(1, 23):
        px[x, 1] = hi  # เส้นไฮไลต์ด้านบน
    for c in [(0, 0), (23, 0), (0, 15), (23, 15)]:
        px[c] = (0, 0, 0, 0)  # มุมโปร่ง
    im.save(path)

os.makedirs("assets/ui", exist_ok=True)
make_btn((70, 50, 120, 255), (110, 90, 170, 255), "assets/ui/btn_normal.png")
make_btn((100, 75, 160, 255), (150, 125, 210, 255), "assets/ui/btn_hover.png")
make_btn((45, 32, 85, 255), (70, 55, 115, 255), "assets/ui/btn_pressed.png")
print("done")