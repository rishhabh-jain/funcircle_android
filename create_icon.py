#!/usr/bin/env python3
"""
Create a glassy app icon for Fun Circle
Theme colors: Orange (#F26610) and Dark (#0D0F11)
"""

from PIL import Image, ImageDraw, ImageFilter
import math

def create_glassy_icon(size=1024):
    """Create a glassy app icon with Fun Circle theme"""

    # Create image with transparency
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # App theme colors
    orange = (242, 102, 16)  # #F26610
    dark = (13, 15, 17)      # #0D0F11

    # Padding for the icon
    padding = size * 0.1
    inner_size = size - (2 * padding)

    # Background gradient circle (dark base)
    for i in range(int(inner_size // 2), 0, -2):
        alpha = int(255 * (i / (inner_size // 2)))
        color = (*dark, alpha)
        draw.ellipse(
            [
                padding + (inner_size // 2) - i,
                padding + (inner_size // 2) - i,
                padding + (inner_size // 2) + i,
                padding + (inner_size // 2) + i
            ],
            fill=color
        )

    # Main orange circle with gradient
    center = size // 2
    radius = inner_size // 2.2

    for i in range(int(radius), 0, -1):
        # Gradient from bright orange to darker orange
        brightness = 1 + (0.3 * (radius - i) / radius)
        r = min(255, int(orange[0] * brightness))
        g = min(255, int(orange[1] * brightness))
        b = min(255, int(orange[2] * brightness))

        draw.ellipse(
            [
                center - i,
                center - i,
                center + i,
                center + i
            ],
            fill=(r, g, b, 255)
        )

    # Glass shine effect (top-left highlight)
    shine_radius = radius * 0.6
    shine_offset_x = center - radius * 0.3
    shine_offset_y = center - radius * 0.3

    for i in range(int(shine_radius), 0, -2):
        alpha = int(120 * (i / shine_radius))
        draw.ellipse(
            [
                shine_offset_x - i,
                shine_offset_y - i,
                shine_offset_x + i,
                shine_offset_y + i
            ],
            fill=(255, 255, 255, alpha)
        )

    # Glass reflection line
    reflection_start_x = center - radius * 0.5
    reflection_end_x = center + radius * 0.3
    reflection_y = center - radius * 0.4

    for offset in range(20, 0, -1):
        alpha = int(60 * (offset / 20))
        draw.line(
            [
                (reflection_start_x, reflection_y - offset),
                (reflection_end_x, reflection_y - offset)
            ],
            fill=(255, 255, 255, alpha),
            width=3
        )

    # Add subtle inner glow
    glow_radius = radius * 0.85
    for i in range(int(glow_radius), int(glow_radius * 0.7), -1):
        alpha = int(40 * (glow_radius - i) / (glow_radius * 0.15))
        draw.ellipse(
            [
                center - i,
                center - i,
                center + i,
                center + i
            ],
            fill=(255, 160, 80, alpha)
        )

    # Add "FC" text in the center
    from PIL import ImageFont

    # Try to use a nice font, fallback to default
    try:
        font_size = int(radius * 0.9)
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
    except:
        try:
            font = ImageFont.truetype("/Library/Fonts/Arial.ttf", font_size)
        except:
            font = ImageFont.load_default()

    text = "FC"

    # Get text bounding box
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    # Center text
    text_x = center - text_width // 2
    text_y = center - text_height // 2 - bbox[1]

    # Draw text shadow
    shadow_offset = 4
    draw.text(
        (text_x + shadow_offset, text_y + shadow_offset),
        text,
        fill=(0, 0, 0, 100),
        font=font
    )

    # Draw main text (white)
    draw.text(
        (text_x, text_y),
        text,
        fill=(255, 255, 255, 255),
        font=font
    )

    # Apply slight blur for glassy effect
    img = img.filter(ImageFilter.GaussianBlur(radius=1))

    return img

# Create the icon
print("Creating glassy app icon...")
icon = create_glassy_icon(1024)

# Save as PNG
output_path = "assets/images/app_launcher_icon_glassy.png"
icon.save(output_path, "PNG", quality=100)
print(f"✓ Icon saved to {output_path}")

# Also save a JPEG version
output_path_jpg = "assets/images/app_launcher_icon.jpeg"
# Convert RGBA to RGB for JPEG
rgb_icon = Image.new('RGB', icon.size, (255, 255, 255))
rgb_icon.paste(icon, mask=icon.split()[3])
rgb_icon.save(output_path_jpg, "JPEG", quality=100)
print(f"✓ Icon also saved to {output_path_jpg}")
print("\nDone! Your new glassy app icon is ready!")
