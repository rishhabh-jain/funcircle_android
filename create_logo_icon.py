#!/usr/bin/env python3
"""
Create app icon using the real Fun Circle logo
"""

from PIL import Image, ImageDraw

def create_app_icon_from_logo(size=1024):
    """Create app icon with the Fun Circle logo"""

    # Load the existing logo
    logo = Image.open('assets/images/logos_(7).png').convert('RGBA')

    # Create new square image with orange background
    icon = Image.new('RGBA', (size, size), (242, 102, 16, 255))  # Orange #F26610

    # Calculate logo size (make it fit nicely with padding)
    logo_height = int(size * 0.3)  # Logo takes up 30% of height
    aspect_ratio = logo.width / logo.height
    logo_width = int(logo_height * aspect_ratio)

    # Resize logo
    logo_resized = logo.resize((logo_width, logo_height), Image.Resampling.LANCZOS)

    # Center the logo
    x = (size - logo_width) // 2
    y = (size - logo_height) // 2

    # Paste logo onto icon
    icon.paste(logo_resized, (x, y), logo_resized)

    # Add subtle rounded corners
    mask = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(mask)
    corner_radius = size // 8
    draw.rounded_rectangle([(0, 0), (size, size)], corner_radius, fill=255)

    # Apply mask
    output = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    output.paste(icon, (0, 0))
    output.putalpha(mask)

    return output

# Create the icon
print("Creating app icon from Fun Circle logo...")
icon = create_app_icon_from_logo(1024)

# Save as PNG
output_path = "assets/images/app_launcher_icon.png"
icon.save(output_path, "PNG", quality=100)
print(f"✓ Icon saved to {output_path}")

# Also save as JPEG
output_path_jpg = "assets/images/app_launcher_icon.jpeg"
# Convert RGBA to RGB for JPEG
rgb_icon = Image.new('RGB', icon.size, (242, 102, 16))  # Orange background
rgb_icon.paste(icon, mask=icon.split()[3] if icon.mode == 'RGBA' else None)
rgb_icon.save(output_path_jpg, "JPEG", quality=100)
print(f"✓ Icon also saved to {output_path_jpg}")
print("\nDone! Your Fun Circle app icon is ready!")
