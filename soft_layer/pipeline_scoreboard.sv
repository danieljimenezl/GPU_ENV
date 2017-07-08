class pipeline_scoreboard extends base_scoreboard;

    gpu_config CONFIG;
    real in0 = 0.0, in1 = 0.0, out = 0.0, expectedValue = 0.0, uRange = 0.0, dRange = 0.0, precision = 0.0;
    bit underFlow = 0, overFlow = 0;
    logic [9:0] mantissa0;
    logic [9:0] mantissa1;

    uvm_analysis_export#(adder_tlm)     adder_export;
    uvm_analysis_export#(divider_tlm)   divider_export;
    uvm_analysis_export#(mult_tlm)      mult_export;
    uvm_analysis_export#(pipeline_tlm)  pipeline_export;

    uvm_tlm_analysis_fifo#(adder_tlm)       adder_fifo;
    uvm_tlm_analysis_fifo#(mult_tlm)        mult_fifo;
    uvm_tlm_analysis_fifo#(divider_tlm)     divider_fifo;
    uvm_tlm_analysis_fifo#(pipeline_tlm)    pipeline_fifo;

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
        else if(CONFIG.get_value("GPU_PIPELINE")) begin
            pipeline_fifo = new("pipeline_fifo",this);
            pipeline_export = new("pipeline_export",this);
        end

        precision = CONFIG.get_real_value("GPU_PIPELINE_PRECISION");
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
        else if(CONFIG.get_value("GPU_PIPELINE"))
            pipeline_export.connect(pipeline_fifo.analysis_export);
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
            else if(CONFIG.get_value("GPU_PIPELINE"))
                pipeline_checker();
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

                expectedValue = in0+in1;
            end
            else if(tlm.tlm_type == ADD_RESULT) begin
                if(tlm.out_mantissa == 0 && tlm.out_exponent == 0) begin
                    if(((expectedValue < 65535*0.00001) && (expectedValue > -65535*0.00001)) || expectedValue == 0)
                        underFlow = 1;
                end
                else if((tlm.out_mantissa == 10'h3ff || tlm.out_mantissa == 10'h0ff ) && tlm.out_exponent == 5'h1f) begin
                    if(expectedValue < 16'h7fff || expectedValue > -16'h7fff)
                        overFlow = 1;
                end

                mantissa0 = tlm.out_mantissa;
                out = 1.0;

                for(int i=0;i<10;i++)
                    if(mantissa0[i]) begin
                        out = out + 2.0**(-(10-i));
                    end

                out = out*((-1.0)**tlm.out_sign)*(2.0**(tlm.out_exponent - 15));

                uRange = expectedValue + (expectedValue*precision);
                dRange = expectedValue - (expectedValue*precision);

                if(underFlow) begin
                    `uvm_warning("ADDER_MODULE",$psprintf("UNDERFLOW: Adder out value: %f. Expected value: %f.", out, expectedValue));
                    underFlow = 0;
                end
                else if(overFlow) begin
                    `uvm_warning("ADDER_MODULE",$psprintf("OVERFLOW: Adder out value: %f. Expected value: %f.", out, expectedValue));
                    overFlow = 0;
                end
                else if(!(out < uRange) && out > dRange) begin
                    `uvm_error("ADDER_MODULE",$psprintf("ADDER OUT VALUE: %f. EXPECTED VALUE: %f.", out, expectedValue));
                end
                else begin
                    `uvm_info("ADDER_MODULE",$psprintf("ADDER OUT VALUE: %f. EXPECTED VALUE: %f.", out, expectedValue),UVM_LOW);
                end
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

                expectedValue = in0*in1;
            end
            else if(tlm.tlm_type == MULT_RESULT) begin
                if(tlm.out_mantissa == 0 && tlm.out_exponent == 0) begin
                    if(((expectedValue < 65535*0.00001) && (expectedValue > -65535*0.00001)) || expectedValue == 0)
                        underFlow = 1;
                end
                else if((tlm.out_mantissa == 10'h3ff || tlm.out_mantissa == 10'h0ff ) && tlm.out_exponent == 5'h1f) begin
                    if(expectedValue < 16'h7fff || expectedValue > -16'h7fff)
                        overFlow = 1;
                end

                mantissa0 = tlm.out_mantissa;
                out = 1.0;

                for(int i=0;i<10;i++)
                    if(mantissa0[i]) begin
                        out = out + 2.0**(-(10-i));
                    end

                out = out*((-1.0)**tlm.out_sign)*(2.0**(tlm.out_exponent - 15));

                uRange = expectedValue + (expectedValue*precision);
                dRange = expectedValue - (expectedValue*precision);

                if(underFlow) begin
                    `uvm_warning("MULT_MODULE",$psprintf("UNDERFLOW: Mult out value: %f. Expected value: %f.", out, expectedValue));
                    underFlow = 0;
                end
                else if(overFlow) begin
                    `uvm_warning("MULT_MODULE",$psprintf("OVERFLOW: Mult out value: %f. Expected value: %f.", out, expectedValue));
                    overFlow = 0;
                end
                else if(!(out < uRange) && out > dRange) begin
                    `uvm_error("MULT_MODULE",$psprintf(" MULT OUT VALUE: %f. EXPECTED VALUE: %f.", out, expectedValue));
                end
                else begin
                    `uvm_info("MULT_MODULE",$psprintf("MULT OUT VALUE: %f. EXPECTED VALUE: %f.", out, expectedValue),UVM_LOW);
                end
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

                expectedValue = in0/in1;
            end
            else if(tlm.tlm_type == DIV_RESULT) begin
                if(tlm.out_mantissa == 0 && tlm.out_exponent == 0) begin
                    if(((expectedValue < 65535*0.00001) && (expectedValue > -65535*0.00001)) || expectedValue == 0)
                        underFlow = 1;
                end
                else if((tlm.out_mantissa == 10'h3ff || tlm.out_mantissa == 10'h0ff ) && tlm.out_exponent == 5'h1f) begin
                    if(expectedValue > 16'h7fff || expectedValue < -16'h7fff)
                        overFlow = 1;
                end

                mantissa0 = tlm.out_mantissa;
                out = 1.0;

                for(int i=0;i<10;i++)
                    if(mantissa0[i]) begin
                        out = out + 2.0**(-(10-i));
                    end

                out = out*((-1.0)**tlm.out_sign)*(2.0**(tlm.out_exponent - 15));

                uRange = expectedValue + (expectedValue*precision);
                dRange = expectedValue - (expectedValue*precision);

                if(underFlow) begin
                    `uvm_warning("DIVIDER_MODULE",$psprintf("UNDERFLOW: Divider out value: %f. Expected value: %f.", out, expectedValue));
                    underFlow = 0;
                end
                else if(overFlow) begin
                    `uvm_warning("DIVIDER_MODULE",$psprintf("OVERFLOW: Divider out value: %f. Expected value: %f.", out, expectedValue));
                    overFlow = 0;
                end
                else if(!(out < uRange) && out > dRange) begin
                    `uvm_error("DIVIDER_MODULE",$psprintf(" DIVIDER OUT VALUE: %f. EXPECTED VALUE: %f.", out, expectedValue));
                end
                else begin
                    `uvm_info("DIVIDER_MODULE",$psprintf("DIVIDER OUT VALUE: %f. EXPECTED VALUE: %f.", out, expectedValue),UVM_LOW);
                end
            end
        end
    endtask : divider_checker


    //--------------------------------------------
    // divider checker
    task pipeline_checker();
        real camVer[string], camDc, cosValues[string], senValues[string], scale[string], trans[string], vertex[string];
        real X_p = 0.0, Y_p = 0.0, Z_p = 0.0, X_c = 0.0, Y_c = 0.0, Z_c = 0.0, X_expected = 0.0, Y_expected = 0.0;
        real outX = 0.0, outY = 0.0;
        real uRangeX = 0.0, uRangeY = 0.0, dRangeX = 0.0, dRangeY = 0.0;
        bit X_overflow, X_underflow, Y_overflow, Y_underflow;
        pipeline_tlm tlm;
        tlm = new();

        forever begin
            pipeline_fifo.get(tlm);
            if(tlm.tlm_type == PIPELINE_INPUTS) begin
                foreach( tlm.camVer[i] ) begin
                    camVer[i] = numToReal(tlm.camVer[i]["sign"], tlm.camVer[i]["mantissa"], tlm.camVer[i]["exponent"]);
                    //$display("CamVer%s: %0f", i, camVer[i]);
                end
                camDc = numToReal(tlm.cam["Dc"]["sign"], tlm.cam["Dc"]["mantissa"], tlm.cam["Dc"]["exponent"]);
                //$display("CamDc: %0f", camDc);
                foreach( tlm.cosValues[i] ) begin
                    cosValues[i] = numToReal(tlm.cosValues[i]["sign"], tlm.cosValues[i]["mantissa"], tlm.cosValues[i]["exponent"]);
                    //$display("cos%s: %0f", i, cosValues[i]);
                end
                foreach( tlm.senValues[i] ) begin
                    senValues[i] = numToReal(tlm.senValues[i]["sign"], tlm.senValues[i]["mantissa"], tlm.senValues[i]["exponent"]);
                    //$display("sen%s: %0f", i, senValues[i]);
                end
                foreach( tlm.scale[i] ) begin
                    scale[i] = numToReal(tlm.scale[i]["sign"], tlm.scale[i]["mantissa"], tlm.scale[i]["exponent"]);
                    //$display("scale%s: %0f", i, scale[i]);
                end
                foreach( tlm.trans[i] ) begin
                    trans[i] = numToReal(tlm.trans[i]["sign"], tlm.trans[i]["mantissa"], tlm.trans[i]["exponent"]);
                    //$display("trans%s: %0f", i, trans[i]);
                end
                foreach( tlm.vertex[i] ) begin
                    vertex[i] = numToReal(tlm.vertex[i]["sign"], tlm.vertex[i]["mantissa"], tlm.vertex[i]["exponent"]);
                    //$display("vertex%s: %0f", i, vertex[i]);
                end

                X_p = (vertex["x"]*scale["x"]*(cosValues["Yaw"]*cosValues["Roll"] + senValues["Yaw"]*senValues["Pitch"]*senValues["Roll"])) + (vertex["y"]*scale["y"]*(senValues["Yaw"]*senValues["Pitch"]*cosValues["Roll"] - cosValues["Yaw"]*senValues["Roll"])) + (vertex["z"]*scale["z"]*(senValues["Yaw"]*cosValues["Pitch"])) + trans["x"];

                Y_p = (vertex["x"]*scale["x"]*(cosValues["Pitch"]*senValues["Roll"])) + (vertex["y"]*scale["y"]*(cosValues["Pitch"]*cosValues["Roll"])) - (vertex["z"]*scale["z"]*(senValues["Pitch"])) + trans["y"];

                Z_p = (vertex["x"]*scale["x"]*(cosValues["Yaw"]*senValues["Pitch"]*senValues["Roll"] - senValues["Yaw"]*cosValues["Roll"])) + (vertex["y"]*scale["y"]*(senValues["Yaw"]*senValues["Roll"] + cosValues["Yaw"]*senValues["Pitch"]*cosValues["Roll"])) + (vertex["z"]*scale["z"]*(cosValues["Yaw"]*cosValues["Pitch"])) + trans["z"];

                X_c = X_p - camVer["x"];
                Y_c = Y_p - camVer["y"];
                Z_c = Z_p - camVer["z"];

                X_expected = (-X_c * camDc)/Z_c;
                Y_expected = (Y_c * camDc)/Z_c;
            end
            else if(tlm.tlm_type == PIPELINE_RESULT) begin
                X_underflow = underflow(tlm.outX_sign, tlm.outX_mantissa, tlm.outX_exponent, X_expected);
                X_overflow = overflow(tlm.outX_sign, tlm.outX_mantissa, tlm.outX_exponent, X_expected);

                Y_underflow = underflow(tlm.outY_sign, tlm.outY_mantissa, tlm.outY_exponent, Y_expected);
                Y_overflow = overflow(tlm.outY_sign, tlm.outY_mantissa, tlm.outY_exponent, Y_expected);

                outX = numToReal(tlm.outX_sign, tlm.outX_mantissa, tlm.outX_exponent);
                outY = numToReal(tlm.outY_sign, tlm.outY_mantissa, tlm.outY_exponent);
 
                uRangeX = X_expected + (X_expected*precision);
                dRangeX = X_expected - (X_expected*precision);

                uRangeY = Y_expected + (Y_expected*precision);
                dRangeY = Y_expected - (Y_expected*precision);

                if(X_underflow) begin
                    `uvm_warning("PIPELINE_MODULE",$psprintf("UNDERFLOW: Pipeline outX value: %f. Expected value: %f.", outX, X_expected));
                    X_underflow = 0;
                end
                else if(X_overflow) begin
                    `uvm_warning("PIPELINE_MODULE",$psprintf("OVERFLOW: Pipeline outX value: %f. Expected value: %f.", outX, X_expected));
                    X_overflow = 0;
                end
                else if(!(outX < uRangeX) && outX > dRangeX) begin
                    `uvm_error("PIPELINE_MODULE",$psprintf(" PIPELINE OUT_X VALUE: %f. EXPECTED X VALUE: %f.", outX, X_expected));
                end
                else begin
                    `uvm_info("PIPELINE_MODULE",$psprintf("PIPELINE OUT_X VALUE: %f. EXPECTED X  VALUE: %f.", outX, X_expected),UVM_LOW);
                end

                if(Y_underflow) begin
                    `uvm_warning("PIPELINE_MODULE",$psprintf("UNDERFLOW: Pipeline outY value: %f. Expected value: %f.", outY, Y_expected));
                    Y_underflow = 0;
                end
                else if(Y_overflow) begin
                    `uvm_warning("PIPELINE_MODULE",$psprintf("OVERFLOW: Pipeline outY value: %f. Expected value: %f.", outY, Y_expected));
                    X_overflow = 0;
                end
                else if(!(outY < uRangeY) && outY > dRangeY) begin
                    `uvm_error("PIPELINE_MODULE",$psprintf(" PIPELINE OUT_Y VALUE: %f. EXPECTED Y VALUE: %f.", outY, Y_expected));
                end
                else begin
                    `uvm_info("PIPELINE_MODULE",$psprintf("PIPELINE OUT_Y VALUE: %f. EXPECTED Y VALUE: %f.", outY, Y_expected),UVM_LOW);
                end
            end
        end
    endtask : pipeline_checker


    //--------------------------------------------
    // Convert num to real
    function real numToReal(int sign, int mantissa, int exponent);
        real result = 1.0;
        mantissa0 = mantissa;

        for(int i=0;i<10;i++)
            if(mantissa0[i]) begin
                result = result + 2.0**(-(10-i));
            end

        result = result*((-1.0)**sign)*(2.0**(exponent - 15));
        return result;
    endfunction : numToReal


    //--------------------------------------------
    // Check underflow
    function bit underflow(int sign, int mantissa, int exponent, real expectedValue);
        if(mantissa == 0 && exponent == 0) begin
            if(((expectedValue < 65535*0.00001) && (expectedValue > -65535*0.00001)) || expectedValue == 0)
                return 1;
        end
        return 0;
    endfunction : underflow


    //--------------------------------------------
    // Check overflow 
    function bit overflow(int sign, int mantissa, int exponent, real expectedValue);
        if((mantissa == 10'h3ff || mantissa == 10'h0ff ) && exponent == 5'h1f) begin
            if(expectedValue > 16'h7fff || expectedValue < -16'h7fff)
                return 1;
        end
        return 0;
    endfunction : overflow 

endclass : pipeline_scoreboard
