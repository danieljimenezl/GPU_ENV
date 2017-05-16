virtual class base_monitor #(
    type IFC=virtual base_ifc,
    type TLM=base_tlm
) extends uvm_monitor;

    `uvm_component_utils_begin(base_driver)
    `uvm_component_utils_end

    IFC ifc;
    TLM tlm;

    string ifc_name;
    string parent_name;

    // **********************************************************
    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);

        parent_name = parent.get_name();
        ifc_name = {parent_name,"_ifc"};

        $display({parent_name,"_monitor created"});
    endfunction : new

    // **********************************************************$
    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(IFC)::read_by_name(.scope("*"), .name(ifc_name), .val(ifc)));

        if( ifc==null )
            `uvm_fatal({parent_name," MONITOR"},"Cannot get vif");
    endfunction: build_phase

endclass : base_monitor
