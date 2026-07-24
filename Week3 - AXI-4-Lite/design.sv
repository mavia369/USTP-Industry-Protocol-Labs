`timescale 1ns/1ps

module axi_lite_slave(

    input  logic        ACLK,
    input  logic        ARESETn,

    // Write Address Channel
    input  logic [31:0] AWADDR,
    input  logic        AWVALID,
    output logic        AWREADY,

    // Write Data Channel
    input  logic [31:0] WDATA,
    input  logic        WVALID,
    output logic        WREADY,

    // Write Response Channel
    output logic [1:0]  BRESP,
    output logic        BVALID,
    input  logic        BREADY,

    // Read Address Channel
    input  logic [31:0] ARADDR,
    input  logic        ARVALID,
    output logic        ARREADY,

    // Read Data Channel
    output logic [31:0] RDATA,
    output logic [1:0]  RRESP,
    output logic        RVALID,
    input  logic        RREADY
);

logic [31:0] reg0;
logic [31:0] reg1;
logic [31:0] reg2;
logic [31:0] reg3;

// Write Logic
always_ff @(posedge ACLK or negedge ARESETn)
begin

    if(!ARESETn)
    begin
        reg0 <= 32'd0;
        reg1 <= 32'd0;
        reg2 <= 32'd0;
        reg3 <= 32'd0;

        BVALID <= 1'b0;
    end
    else
    begin

        // Write Transaction

        if(AWVALID && WVALID)
        begin

            case(AWADDR)

                32'h00000000 : reg0 <= WDATA;
                32'h00000004 : reg1 <= WDATA;
                32'h00000008 : reg2 <= WDATA;
                32'h0000000C : reg3 <= WDATA;

            endcase

            BVALID <= 1'b1;

        end
        else if(BREADY)
        begin
            BVALID <= 1'b0;
        end

    end

end

// Read Logic
always_ff @(posedge ACLK or negedge ARESETn)
begin

    if(!ARESETn)
    begin
        RDATA  <= 32'd0;
        RVALID <= 1'b0;
    end
    else
    begin

        if(ARVALID)
        begin

            case(ARADDR)

                32'h00000000 : RDATA <= reg0;
                32'h00000004 : RDATA <= reg1;
                32'h00000008 : RDATA <= reg2;
                32'h0000000C : RDATA <= reg3;

                default : RDATA <= 32'd0;

            endcase

            RVALID <= 1'b1;

        end
        else if(RREADY)
        begin
            RVALID <= 1'b0;
        end

    end

end

assign AWREADY = 1'b1;
assign WREADY  = 1'b1;
assign ARREADY = 1'b1;

assign BRESP = 2'b00;
assign RRESP = 2'b00;

endmodule