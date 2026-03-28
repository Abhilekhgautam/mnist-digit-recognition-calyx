# MNIST Digit Recognition through Calyx

A pytorch to verilog compilation pipeline for mnist digit recognition using `allo` and `calyx`.

# Basic Workflow
   - Model Training through pytorch which outputs `weight_mnist.pth`
   - Inference Logic in pytorch lowered to `mlir` using `allo`.
   - generated mlir lowered to verilog using `circt` and `calyx`

# Project Structure
   - [generated-mlir](https://github.com/Abhilekhgautam/mnist-digit-recognition-calyx/tree/main/generated-mlir) contains mlir code lowered using `mlir-opt` and `circt-opt` as described in [PyTorch To Calyx](https://github.com/Abhilekhgautam/pytorch-to-calyx/blob/main/README.md)
   - [generated-hw](https://github.com/Abhilekhgautam/mnist-digit-recognition-calyx/tree/main/generated-hw) contains `.calyx`, `.futil` and the ultimate `.sv` program

# Simulation using Verilator

```bash
verilator -top-module main --cc --exe --build tb.cpp <path_to_sv>
make -C obj_dir -f Vmain.mk CXXFLAGS="-O3"
```

### Create a folder to hold the data
Use utils/create-dat-file.py to generate required .dat file
   - meminit/mem_0.dat -> input (image in hex)
   - meminit/mem_1.dat -> output (prediction)
   - meminit/mem_2.dat
   - meminit/mem_3.dat

### Run the generated exe

```bash
obj_dir/Vmain +Data=<path_to_meminit>
```
### Output
  - generates `.out` file for every `.dat` files in meminit folder.
  - `meminit/mem_1.out` holds the prediction data.

# Surprise
 - This is quite faster than I expected it to be.

# TODO
 - Optimize
