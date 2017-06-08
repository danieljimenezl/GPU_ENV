class pipeline_scoreboard extends base_scoreboard;

    gpu_config CONFIG; 
    real in0 = 0.0, in1 = 0.0, out = 0.0;
    logic [9:0] mantissa0;
    logic [9:0] mantissa1;

 

    uvm_analysis_export#(adder_tlm)     adder_export;
    uvm_analysis_export#(divider_tlm)   divider_export;
    uvm_analysis_export#(mult_tlm)      mult_export;

    uvm_tlm_analysis_fifo#(adder_tlm)   adder_fifo;
    uvm_tlm_analysis_fifo#(mult_tlm)    mult_fifo;
    uvm_tlm_analysis_fifo#(divider_tlm) divider_fifo;

    `uvm_component_utils_begin(pipeline_scoreboard)
    `uvm_component_utils_end


    //--------------------------------------------
    // new
    function new(string name, uvm_component parent);
        super.new(name, parent);
        CONFIG = gpu_config::type_id::create("gpu_config",this);
    endfunction : new


    //--------------------------------------------
    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(CONFIG.get_value("GPU_PIPELINE_ADDER")) begin
            adder_fifo = new("adder_fifo",this);
            adder_export = new("adder_export",this);
        end
        else if(CONFIG.get_value("GPU_PIPELINE_MULT")) begin
            mult_fifo = new("mult_fifo",this);
            mult_export = new("mult_export",this);
        end
        else if(CONFIG.get_value("GPU_PIPELINE_DIVIDER")) begin
            divider_fifo = new ("divider_fifo",this);
            divider_export = new("divider_export",this);
        end
    endfunction : build_phase


    //--------------------------------------------
    // connect_phase
    function void connect_phase(uvm_phase phase);
        if(CONFIG.get_value("GPU_PIPELINE_ADDER"))
            adder_export.connect(adder_fifo.analysis_export);
        else if(CONFIG.get_value("GPU_PIPELINE_MULT"))
            mult_export.connect(mult_fifo.analysis_export); 
        else if(CONFIG.get_value("GPU_PIPELINE_DIVIDER"))
            divider_export.connect(divider_fifo.analysis_export);
    endfunction : connect_phase


    //--------------------------------------------
    // run_phase
    task run_phase(uvm_phase phase);
        fork
            if(CONFIG.get_value("GPU_PIPELINE_ADDER"))
                adder_checker();
            else if(CONFIG.get_value("GPU_PIPELINE_MULT"))
                mult_checker();
            else if(CONFIG.get_value("GPU_PIPELINE_DIVIDER"))
                divider_checker();
        join
    endtask : run_phase


    //--------------------------------------------
    // adder checker
    task adder_checker();
        adder_tlm tlm;
        tlm = new();

        forever begin
            adder_fifo.get(tlm);

            if(tlm.tlm_type == ADD_INPUTS) begin
                mantissa0 = tlm.in0_mantissa;
                mantissa1 = tlm.in1_mantissa;

                in0 = 1.0;
                in1 = 1.0;

                for(int i=0;i<10;i++) begin
                    if(mantissa0[i])
                        in0 = in0 + 2.0**(-(10-i));
                    if(mantissa1[i])
                        in1 = in1 + 2.0**(-(10-i));
                end

                in0 = in0*((-1.0)**tlm.in0_sign)*(2.0**(tlm.in0_exponent - 15));
                in1 = in1*((-1.0)**tlm.in1_sign)*(2.0**(tlm.in1_exponent - 15));
            end
            else if(tlm.tlm_type == ADD_RESULT) begin
                mantissa0 = tlm.out_mantissa;
                out = 1.0;

                for(int i=0;i<10;i++)
                    if(mantissa0[i]) begin
                        out = out + 2.0**(-(10-i));
                    end

                out = out*((-1.0)**tlm.out_sign)*(2.0**(tlm.out_exponent - 15));
                result_checker(in0, in1, out);
            end
        end
    endtask : adder_checker


    //--------------------------------------------
    // mult checker
    task mult_checker();
        mult_tlm tlm;
        tlm = new();

        forever begin
            mult_fifo.get(tlm);
            if(tlm.tlm_type == MULT_INPUTS) begin
                mantissa0 = tlm.in0_mantissa;
                mantissa1 = tlm.in1_mantissa;

                in0 = 1.0;
                in1 = 1.0;

                for(int i=0;i<10;i++) begin
                    if(mantissa0[i])
                        in0 = in0 + 2.0**(-(10-i));
                    if(mantissa1[i])
                        in1 = in1 + 2.0**(-(10-i));
                end

                in0 = in0*((-1.0)**tlm.in0_sign)*(2.0**(tlm.in0_exponent - 15));
                in1 = in1*((-1.0)**tlm.in1_sign)*(2.0**(tlm.in1_exponent - 15));
            end
            else if(tlm.tlm_type == MULT_RESULT) begin
                mantissa0 = tlm.out_mantissa;
                out = 1.0;

                for(int i=0;i<10;i++)
                    if(mantissa0[i]) begin
                        out = out + 2.0**(-(10-i));
                    end

                out = out*((-1.0)**tlm.out_sign)*(2.0**(tlm.out_exponent - 15));
                result_checker(in0, in1, out);
            end
        end
    endtask : mult_checker


    //--------------------------------------------
    // divider checker
    task divider_checker();
        divider_tlm tlm;

        tlm = new();
        forever begin
            divider_fifo.get(tlm);
            if(tlm.tlm_type == DIV_INPUTS) begin
                mantissa0 = tlm.in0_mantissa;
                mantissa1 = tlm.in1_mantissa;

                in0 = 1.0;
                in1 = 1.0;

                for(int i=0;i<10;i++) begin
                    if(mantissa0[i])
                        in0 = in0 + 2.0**(-(10-i));
                    if(mantissa1[i])
                        in1 = in1 + 2.0**(-(10-i));
                end

                in0 = in0*((-1.0)**tlm.in0_sign)*(2.0**(tlm.in0_exponent - 15));
                in1 = in1*((-1.0)**tlm.in1_sign)*(2.0**(tlm.in1_exponent - 15));
            end
            else if(tlm.tlm_type == DIV_RESULT) begin
                mantissa0 = tlm.out_mantissa;
                out = 1.0;
                
                for(int i=0;i<10;i++)
                    if(mantissa0[i]) begin
                        out = out + 2.0**(-(10-i));
                    end

                out = out*((-1.0)**tlm.out_sign)*(2.0**(tlm.out_exponent - 15));
                result_checker(in0, in1, out);
            end
        end
    endtask : divider_checker


    //--------------------------------------------
    // result checker
    task result_checker(real in0, real in1, real out);
        real temp = 0;
        real uRange = 0;
        real dRange = 0;

        if(CONFIG.get_value("GPU_PIPELINE_ADDER")) begin
            temp = in0 + in1;
            uRange = temp + (temp*0.01);
            dRange = temp - (temp*0.01);

            if(!(out < uRange) && out > dRange)
               `uvm_error("ADDER_MODULE",$psprintf(" ADDER OUT VALUE: %f. EXPECTED VALUE: %f.", out, temp));
        end
        else if(CONFIG.get_value("GPU_PIPELINE_MULT")) begin
            temp = in0 * in1;
            uRange = temp + (temp*0.01);
            dRange = temp - (temp*0.01);

            if(!(out < uRange) && out > dRange)
                `uvm_error("MULT_MODULE",$psprintf(" MULT OUT VALUE: %f. EXPECTED VALUE: %f.", out, temp));
            end
        else if(CONFIG.get_value("GPU_PIPELINE_DIVIDER")) begin
            temp = in0/in1;
            uRange = temp + (temp*0.01);
            dRange = temp - (temp*0.01);

            if(!(out < uRange) && out > dRange)
                `uvm_error("DIVIDER_MODULE",$psprintf(" DIVIDER OUT VALUE: %f. EXPECTED VALUE: %f.", out, temp));
        end
    endtask : result_checker

endclass : pipeline_scoreboard
