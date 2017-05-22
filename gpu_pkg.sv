package gpu_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    ///////////////////////////////////////////////
    //  G P U - B A S E
    `include "base_seq.sv"
    `include "base_driver.sv"
    `include "base_monitor.sv"
    `include "base_scoreboard.sv"
    `include "base_agent.sv"


    ///////////////////////////////////////////////
    //  H A R D   L A Y E R

    //---------------------------------
    //  G R A P H I C   P I P E L I N E

    //  A D D E R
    `include "adder_seq.sv"
    `include "adder_driver.sv"
    `include "adder_monitor.sv"
    `include "adder_agent.sv"

    //  M U L T I
    //`include "multi_seq.sv"
    //`include "multi_driver.sv"
    //`include "multi_monitor.sv"
    //`include "multi_agent.sv"

    //  D I V I D E R
    //`include "divider_seq.sv"
    //`include "divider_driver.sv"
    //`include "divider_monitor.sv"
    //`include "divider_agent.sv"

endpackage
