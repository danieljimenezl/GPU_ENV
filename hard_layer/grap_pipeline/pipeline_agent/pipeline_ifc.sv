interface pipeline_ifc();

    base_ifc base();

    logic  [15:0]   camVerX, camVerY, camVerZ;
    logic  [15:0]   camDc;
    logic  [15:0]   cosRoll, cosPitch, cosYaw;
    logic  [15:0]   senRoll, senPitch, senYaw;
    logic  [15:0]   scaleX,  scaleY,   scaleZ;
    logic  [15:0]   transX, transY,  transZ;
    logic  [15:0]   vertexX, vertexY,  vertexZ;

    logic [15:0] outX, outY, outException;

endinterface : pipeline_ifc
