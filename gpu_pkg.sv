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
    `include "gpu_config.sv"



    ///////////////////////////////////////////////
    //  H A R D   L A Y E R

    //---------------------------------
    //  G R A P H I C   P I P E L I N E

    //  A D D E R
    `include "adder_seq.sv"
    `include "adder_seq_lib.sv"
    `include "adder_sequencer.sv"
    `include "adder_driver.sv"
    `include "adder_monitor.sv"
    `include "adder_agent.sv"

    //  M U L T I P L I E R
    `include "mult_seq.sv"
    `include "mult_seq_lib.sv"
    `include "mult_sequencer.sv"
    `include "mult_driver.sv"
    `include "mult_monitor.sv"
    `include "mult_agent.sv"

    //  D I V I D E R
    `include "divider_seq.sv"
    `include "divider_seq_lib.sv"
    `include "divider_sequencer.sv"
    `include "divider_driver.sv"
    `include "divider_monitor.sv"
    `include "divider_agent.sv"

    //  P I P E L I N E
    `include "pipeline_seq.sv"
    //`include "pipeline_seq_lib.sv"
    `include "pipeline_sequencer.sv"
    `include "pipeline_driver.sv"
    `include "pipeline_monitor.sv"
    `include "pipeline_agent.sv"


    //---------------------------------
    //  M E M O R Y  M A N A G E R

    //  U A R T
    `include "uart_seq.sv"
    `include "uart_seq_lib.sv"
    `include "uart_sequencer.sv"
    `include "uart_driver.sv"
    `include "uart_monitor.sv"
    `include "uart_agent.sv"

    //  S R A M

    //  M E M O R Y  C O N T R O L E R



    ///////////////////////////////////////////////
    //  S O F T  L A Y E R
    `include "pipeline_scoreboard.sv"


    `include "../gpu_env.sv"
    `include "../gpu_test.sv"

endpackage
