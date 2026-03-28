import allo

import torch
import torch.nn.functional as F
import torch.nn as nn

input_size = 28 * 28 
num_classes = 10

class HardwareMnistModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.linear = nn.Linear(input_size, num_classes)

    def forward(self, x):
        # x is strictly expected to be [1, 784]. No dynamic -1 shapes!
        out = self.linear(x)
        return out

model = HardwareMnistModel()
model.load_state_dict(torch.load("mnist_weights.pth"))

model.eval()

# 5. Create a dummy input with the exact shape the hardware will see
dummy_input = [torch.randn(1, input_size)]

mod = allo.frontend.from_pytorch(model, target="mlir", example_inputs=dummy_input)

with open("model.mlir", "w") as f:
    f.write(str(mod.module))

print("MLIR saved to model.mlir")
