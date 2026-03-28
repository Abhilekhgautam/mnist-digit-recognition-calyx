import torch
import struct

data = torch.load("./mnist_weights.pth", map_location="cpu")

if isinstance(data, dict):
    # pick the first tensor
    key = list(data.keys())[0]
    tensor = data[key]
else:
    tensor = data

flat = tensor.flatten().tolist()

for val in flat[:10]:
    hex_val = struct.pack('!f', val).hex()
    print(val, "->", hex_val)
