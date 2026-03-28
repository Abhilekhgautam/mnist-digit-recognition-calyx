#include "Vmain.h"
#include "verilated.h"
#include <iostream>

vluint64_t main_time = 0;

void tick(Vmain& top) {
    top.clk = 0;
    top.eval();

    top.clk = 1;
    top.eval();

    main_time++;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc,argv);
    Vmain top;

    std::cout << "Computation Started\n";

    // 1. Reset
    top.reset = 1;
    top.go = 0;
    for (int i = 0; i < 5; i++) tick(top);

    // 2. Release reset
    top.reset = 0;

    // 3. Start (HOLD go high)
    top.go = 1;
    top.eval(); // Evaluate combinatorial logic to propagate go=1

    // 4. Wait for done
    while (!top.done) {
        tick(top);
    }

    // 5. De-assert go now that computation is finished
    top.go = 0;
    top.eval();

    std::cout << "Computation finished at time "
              << main_time << " cycles" << std::endl;

    top.final();
    return 0;
}
