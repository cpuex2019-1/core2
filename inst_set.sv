`ifndef _INST_SET_
`define _INST_SET_ 1

    parameter INST_LW     = 6'b00_0001;
    parameter INST_SW     = 6'b00_0000;
    parameter INST_LF     = 6'b10_0001;
    parameter INST_LWR    = 6'b01_0001;
    parameter INST_LFR    = 6'b11_0001;
    parameter INST_SF     = 6'b01_0000;
    parameter INST_ADD    = 6'b00_0010;
    parameter INST_SUB    = 6'b00_0011;
    parameter INST_MUL    = 6'b00_0100;
    parameter INST_XOR    = 6'b00_0101;
    parameter INST_ADDI   = 6'b00_1000;
    parameter INST_SI     = 6'b00_1001;
    parameter INST_ORI    = 6'b00_1010;
    parameter INST_FADD   = 6'b11_0010;
    parameter INST_FSUB   = 6'b11_0011;
    parameter INST_FMUL   = 6'b11_0100;
    parameter INST_FDIV   = 6'b11_0101;
    parameter INST_FNEG   = 6'b11_0110;
    parameter INST_FABS   = 6'b11_0111;
    parameter INST_SQRT   = 6'b11_1000;
    parameter INST_FLOOR  = 6'b11_1001;
    parameter INST_FTOI   = 6'b01_1010;
    parameter INST_ITOF   = 6'b10_1010;
    parameter INST_MOVF   = 6'b11_1010;
    parameter INST_J      = 6'b00_1011;
    parameter INST_JAL    = 6'b00_1100;
    parameter INST_JALR   = 6'b00_1101;
    parameter INST_SLT    = 6'b00_0111;
    parameter INST_SLTF   = 6'b01_0010;
    parameter INST_BNE    = 6'b10_1100;
    parameter INST_BLE    = 6'b10_1110;
    parameter INST_BEQF   = 6'b01_1100;
    parameter INST_BLTF   = 6'b01_1101;
    parameter INST_OUTB   = 6'b00_1110;
    parameter INST_INF    = 6'b11_1111;
    parameter INST_IN     = 6'b00_1111;

    function is_branch_inst(input [5:0] opecode);
        begin
            is_branch_inst = (opecode[5]^opecode[4]) && opecode[3] && opecode[2];
        end
    endfunction

    function is_write_inst(input [5:0] opecode);
        begin
            is_write_inst = opecode[3:0] != 4'b0000 &&
                            opecode != INST_J && opecode != INST_OUTB && ~is_branch_inst(opecode);
        end
    endfunction

    function use_ft_inst(input [5:0] opecode);
        begin
            use_ft_inst = opecode == INST_FADD || opecode == INST_FSUB ||
                          opecode == INST_FMUL || opecode == INST_FDIV;
        end
    endfunction

    function use_fpu_inst(input [5:0] opecode);
        begin
            use_fpu_inst = opecode == INST_FADD || opecode == INST_FSUB ||
                          opecode == INST_FMUL || opecode == INST_FDIV ||
                          opecode == INST_SQRT || opecode == INST_FTOI ||
                          opecode == INST_ITOF || opecode == INST_FLOOR;
        end
    endfunction

`endif