class base_driver #(
    type IFC=virtual base_ifc, 
    type TLM=base_tlm
)extends uvm_driver#(TLM);

    `uvm_component_utils_begin(base_driver)
    `uvm_component_utils_end

    IFC ifc;
    string ifc_name;

    // **********************************************************
    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        $display{parent.get_name(),"_driver created"};
        ifc_name = {parent.get_name(),"_ifc"}
     endfunction : new

    // **********************************************************$
    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(IFC)::read_by_name(.scope("*"), .name(if_name), .val(ifc)));

        if( vif==null )
            `uvm_fatal("CNT_DRV","Cannot get vif");
    endfunction: build_phase.......$

endclass : base_driver
