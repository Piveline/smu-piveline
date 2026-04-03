`include "modules/headers/csr_funct3.vh"

module CSRFile #(
    parameter XLEN = 32
)(
    input clk,
    input clk_enable,
    input reset,
    input trapped,
    input mret_executed,
    input csr_write_enable,
    input [11:0] csr_read_address,
    input [11:0] csr_write_address,
    input [XLEN-1:0] csr_write_data,
    input instruction_retired,
    input valid_csr_address,
    input timer_interrupt_pending,

    output reg [XLEN-1:0] csr_read_out,
    output reg csr_ready
);

    wire [XLEN-1:0] mvendorid = 32'h52_56_4B_43;
    wire [XLEN-1:0] marchid   = 32'h34_36_53_35;
    wire [XLEN-1:0] mimpid    = 32'h34_36_49_31;
    wire [XLEN-1:0] mhartid   = 32'h52_4B_43_30;
    
    reg MIE;
    reg MPIE;
    wire [1:0] MPP = 2'b11;
    wire [XLEN-1:0] mstatus = {19'b0, MPP, 3'b0, MPIE, 3'b0, MIE, 3'b0};
    
    wire [XLEN-1:0] misa = 32'h40000100;
    wire [XLEN-1:0] mip  = {24'b0, timer_interrupt_pending, 7'b0};

    reg [XLEN-1:0] mtvec;
    reg [XLEN-1:0] mepc;
    reg [XLEN-1:0] mcause;

    reg [63:0] mcycle;
    reg [63:0] minstret;

    reg csr_processing;
    reg [XLEN-1:0] csr_read_data;

    wire csr_access;
    assign csr_access = valid_csr_address;

    localparam [XLEN-1:0] DEFAULT_mtvec  = 32'h00001000;
    localparam [XLEN-1:0] DEFAULT_mepc   = {XLEN{1'b0}};
    localparam [XLEN-1:0] DEFAULT_mcause = {XLEN{1'b0}};
    localparam [63:0] DEFAULT_mcycle = 64'b0;
    localparam [63:0] DEFAULT_minstret = 64'b0;

    always @(*) begin
      case (csr_read_address)
        12'hB00: csr_read_data = mcycle[XLEN-1:0];
        12'hB02: csr_read_data = minstret[XLEN-1:0];
        12'hB80: csr_read_data = mcycle[63:32];
        12'hB82: csr_read_data = minstret[63:32];
        12'hF11: csr_read_data = mvendorid;
        12'hF12: csr_read_data = marchid;
        12'hF13: csr_read_data = mimpid;
        12'hF14: csr_read_data = mhartid;
        12'h300: csr_read_data = mstatus;
        12'h301: csr_read_data = misa;
        12'h305: csr_read_data = mtvec;
        12'h341: csr_read_data = mepc;
        12'h342: csr_read_data = mcause;
        12'h344: csr_read_data = mip;
        default: csr_read_data = {XLEN{1'b0}};
      endcase

      if (reset) begin
        csr_ready = 1'b1;
      end else begin
        if (csr_access && !csr_processing) begin
          csr_ready = 1'b0;
        end else if (csr_processing) begin
          csr_ready = 1'b1;
        end else begin
          csr_ready = 1'b1;
        end
      end
    end

    always @(posedge clk or posedge reset) begin
      if (reset) begin
        mtvec   <= DEFAULT_mtvec;
        mepc    <= DEFAULT_mepc;
        mcause  <= DEFAULT_mcause;
        mcycle  <= DEFAULT_mcycle;
        minstret <= DEFAULT_minstret;

        csr_processing <= 1'b0;
        csr_read_out <= {XLEN{1'b0}};
        
        MIE  <= 1'b0;
        MPIE <= 1'b0;
      end else if (clk_enable) begin
        mcycle <= mcycle + 1;
        
        if (instruction_retired) begin
          minstret <= minstret + 1;
        end

        if (trapped) begin
            MPIE <= MIE;
            MIE  <= 1'b0;
        end 
        else if (mret_executed) begin
            MIE  <= MPIE;
            MPIE <= 1'b1;
        end 
        else if (csr_write_enable && (csr_write_address == 12'h300)) begin
            MIE  <= csr_write_data[3];
            MPIE <= csr_write_data[7];
        end

        if (csr_access && !csr_processing) begin
          csr_processing <= 1'b1;
          csr_read_out <= csr_read_data;
        end else if (csr_processing) begin
          csr_processing <= 1'b0;
          csr_read_out <= csr_read_data;
        end else if (csr_write_enable) begin
          csr_read_out <= csr_read_data;
        end

        if ((trapped && csr_write_enable) || (csr_write_enable)) begin
          case (csr_write_address)
            12'h305: mtvec  <= csr_write_data;
            12'h341: mepc   <= csr_write_data;
            12'h342: mcause <= csr_write_data;
            default: ;
          endcase
        end
      end
    end

endmodule