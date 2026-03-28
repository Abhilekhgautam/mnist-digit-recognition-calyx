import torch
import torch.nn as nn
import struct

# 1. Recreate your PyTorch model
input_size = 28 * 28 
num_classes = 10

class HardwareMnistModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.linear = nn.Linear(input_size, num_classes)

    def forward(self, x):
        return self.linear(x)

model = HardwareMnistModel()

model.load_state_dict(torch.load("./mnist_weights.pth"))
model.eval()

# 2. Function to read your hardware's exact input file
def hex_to_float(hex_str):
    return struct.unpack('!f', bytes.fromhex(hex_str))[0]

try:
    with open("meminit/mem_0.dat", "r") as f:
        hex_lines = f.read().splitlines()
    
    # Convert the 784 hex strings back to floats
    input_floats =[hex_to_float(line) for line in hex_lines if line.strip()]
    
    # Convert to PyTorch tensor shaped [1, 784]
    hardware_input_tensor = torch.tensor([input_floats], dtype=torch.float32)
    
except FileNotFoundError:
    print("Error: input.hex not found.")
    exit()

# 3. Run the Python prediction
with torch.no_grad():
    python_output = model(hardware_input_tensor)[0] # Get the 10 logits

# 4. Print the results for direct comparison
print("--- PyTorch Output Logits ---")
for i, val in enumerate(python_output):
    # Convert Python's float back to hex so you can compare it to your mem_1.out file!
    hex_val = format(struct.unpack('!I', struct.pack('!f', val.item()))[0], '08x')
    print(f"Digit {i}: {val.item():>8.4f}  |  Hex: {hex_val}")

predicted_digit = torch.argmax(python_output).item()
print(f"\n=> PyTorch predicts the digit is: {predicted_digit}")
