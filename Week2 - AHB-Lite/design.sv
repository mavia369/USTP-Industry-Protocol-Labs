`timescale 1ns/1ps

module ahb_slave(

    input  logic        HCLK,
    input  logic        HRESETn,

    input  logic [31:0] HADDR,
    input  logic [31:0] HWDATA,
    input  logic [1:0]  HTRANS,
    input  logic        HWRITE,
    input  logic        HSEL,

    output logic [31:0] HRDATA,
    output logic        HREADYOUT
);

logic [31:0] reg0;
logic [31:0] reg1;
logic [31:0] reg2;
logic [31:0] reg3;

// Write Logic

always_ff @(posedge HCLK or negedge HRESETn)
begin

    if(!HRESETn)
    begin
        reg0 <= 32'd0;
        reg1 <= 32'd0;
        reg2 <= 32'd0;
        reg3 <= 32'd0;
    end

    else if(HSEL &&
            HWRITE &&
            (HTRANS == 2'b10 || HTRANS == 2'b11))
    begin

        case(HADDR)

            32'h00000000 : reg0 <= HWDATA;
            32'h00000004 : reg1 <= HWDATA;
            32'h00000008 : reg2 <= HWDATA;
            32'h0000000C : reg3 <= HWDATA;

        endcase

    end

end

// Read Logic

always_comb
begin

    HRDATA = 32'd0;

    if(HSEL && !HWRITE)
    begin

        case(HADDR)

            32'h00000000 : HRDATA = reg0;
            32'h00000004 : HRDATA = reg1;
            32'h00000008 : HRDATA = reg2;
            32'h0000000C : HRDATA = reg3;

            default : HRDATA = 32'd0;

        endcase

    end

end

assign HREADYOUT = 1'b1;

endmodule