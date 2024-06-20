import argparse
from PIL import Image

def image_to_hex(image_path):
    # Open the image and convert to grayscale
    img = Image.open(image_path).convert('1')  # '1' mode for 1-bit pixels, black and white

    # Ensure the image is 16x112
    #assert img.size == (16, 112), "Image must be 16x112 pixels"

    # Create a binary string from the image
    binary_string = ''
    for y in range(img.height):
        for x in range(img.width):
            pixel = img.getpixel((x, y))
            binary_string += '0' if pixel else '1'  # White pixel -> '0', Black pixel -> '1'

    # Convert the binary string to a hex string
    hex_string = ''
    for i in range(0, len(binary_string), 4):  # Process 4 bits at a time
        nibble = binary_string[i:i+4]
        hex_digit = format(int(nibble, 2), 'x')
        hex_string += hex_digit

    return hex_string

def main():
    parser = argparse.ArgumentParser(description='Convert a 16x112 black-and-white image to a hex string.')
    parser.add_argument('image_path', type=str, help='Path to the black-and-white 16x112 image')

    args = parser.parse_args()

    hex_string = image_to_hex(args.image_path)
    print(hex_string)

if __name__ == "__main__":
    main()
