virtual class base_agent #(
    type IFC=virtual base_ifc,
    type DRV=base_driver,
    type MON=base_monitor
) extends uvm_agent;

    IFC ifc;
    MON monitor;
    DRV driver;
    integer file;

    string agent_name;

    `uvm_component_utils_begin(base_agent)
    `uvm_component_utils_end

    // **********************************************************
    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        $display({name,"_agent created"});
        agent_name = name;
        file = $fopen({name,"_agent.log"},"w");
    endfunction : new


    // **********************************************************
    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        monitor = MON::type_id::create({agent_name,"_monitor"},this);
        monitor.file = file;

        driver = DRV::type_id::create({agent_name,"_driver"},this);
        driver.file = file;
    endfunction: build_phase


    // **********************************************************
    // connect_phase
    function void connect_phase(uvm_phase phase);

    endfunction : connect_phase


    // **********************************************************
    // final_phase
     function void final_phase(uvm_phase phase);
        $fclose(file);
    endfunction


endclass : hpn_agent
