import struct

hex_list = [
    "bea1b4bb",
    "3e8c8b6a",
    "be91fdc0",
    "bec438de",
    "3eceb569",
    "be9d4049",
    "3d089f89",
    "3c413c3f",
    "3dcb47cc",
    "3e7e20d0",
]

#with open("meminit/mem_1.out", "r") as f:
#   x = f.read()
#   hex_list.append(str(x))


# Convert hex to float
float_list = [struct.unpack('!f', bytes.fromhex(h))[0] for h in hex_list]

# Print results
for h, f in zip(hex_list, float_list):
    print(f"{h} -> {f}")
