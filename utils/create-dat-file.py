import json
import struct
import os

# Path to your JSON
with open("data.json") as f:
    data_json = json.load(f)

# Folder to store .dat files
out_dir = "./meminit"
os.makedirs(out_dir, exist_ok=True)

for mem_name, mem_content in data_json.items():
    filename = os.path.join(out_dir, f"{mem_name}.dat")
    with open(filename, "w") as f:
        for val in mem_content["data"]:
            # Convert float to IEEE-754 32-bit hex
            packed = struct.pack('>f', val)  # big-endian
            hex_val = ''.join(f'{b:02x}' for b in packed)
            f.write(hex_val + "\n")
    print(f"Written {filename}")
