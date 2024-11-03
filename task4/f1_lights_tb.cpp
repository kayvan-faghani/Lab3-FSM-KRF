#include "Vf1_lights.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#include "../vbuddy.cpp" // include vbuddy code
#define MAX_SIM_CYC 100000
int bin2bcd(int n){
    int bcdResult = 0;
    int shift = 0;
    while (n > 0) {
        bcdResult |= (n % 10) << (shift++ << 2);
        n /= 10;
   }
   return bcdResult;
}
int main(int argc, char **argv, char **env)
{
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges
    int lights = 0; // state to toggle LED lights

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vf1_lights *top = new Vf1_lights;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("f1_lights.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("L3T2:f1_lights");
    vbdSetMode(1); // Flag mode set to one-shot

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->en = 0;
    top->N = vbdValue();

    int reaction_time = 0;
    int previous_data = 0;
    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }
        //debugging stuff
        //std::cout << "Current delay " << int(top->current_delay) << std::endl;
        //std::cout << "Current data out " << int(top->data_out) << std::endl;
        //std::cout << "Current time out " << int(top->current_time_out) << std::endl;
        //std::cout << "Current cmd seq out " << int(top->current_cmd_seq) << std::endl;
        //std::cout << "Current cmd delay out " << int(top->current_cmd_delay) << std::endl;
        //std::cout << "Current tick " << int(top->current_tick) << std::endl;
        //std::cout << "Current count " << int(top->count) << std::endl;
        //std::cout << "Current run " << int(top->current_run) << std::endl;
        // Display toggle neopixel
        vbdBar(top->data_out & 0xFF);
        // set up input signals of testbench
        top->trigger = vbdFlag();
        top->rst = (simcyc < 2); // assert reset for 1st cycle
        top->en = (simcyc > 2);
        top->N = vbdValue();
        vbdCycle(simcyc);


        if(int(top->data_out) == 0 && previous_data != int(top->data_out)){
            vbdInitWatch();
            while(vbdFlag() == 0){
                std::cout << "Wow your reaction time is slow" << std::endl;
            }
            reaction_time = vbdElapsed();
            std::cout << "Your reaction time was " << reaction_time << " ms " <<std::endl;
            reaction_time = bin2bcd(reaction_time);
            vbdHex(4, (reaction_time >> 16) & 0xF);
            vbdHex(3, (reaction_time >> 8) & 0xF);
            vbdHex(2, (reaction_time >> 4) & 0xF);
            vbdHex(1, reaction_time & 0xF);
        }
        
        if(int(top->current_cmd_delay) == 1){
            std::cout << "The delay which was taken was " << int(top->current_delay) << std::endl;
        }

        previous_data = int(top->data_out);
        if (Verilated::gotFinish() || vbdGetkey() == 'q')
            exit(0);
    }

    vbdClose(); // ++++
    tfp->close();
    exit(0);
}
