`timescale 1ns/1ps

module tb;

logic ACLK;
logic ARESETn;

// Write Address Channel
logic [31:0] AWADDR;
logic         AWVALID;
logic         AWREADY;

// Write Data Channel
logic [31:0] WDATA;
logic         WVALID;
logic         WREADY;

// Write Response Channel
logic [1:0]   BRESP;
logic         BVALID;
logic         BREADY;

// Read Address Channel
logic [31:0] ARADDR;
logic         ARVALID;
logic         ARREADY;

// Read Data Channel
logic [31:0] RDATA;
logic [1:0]  RRESP;
logic         RVALID;
logic         RREADY;

// DUT Instantiation
axi_lite_slave dut(

    .ACLK(ACLK),
    .ARESETn(ARESETn),

    .AWADDR(AWADDR),
    .AWVALID(AWVALID),
    .AWREADY(AWREADY),

    .WDATA(WDATA),
    .WVALID(WVALID),
    .WREADY(WREADY),

    .BRESP(BRESP),
    .BVALID(BVALID),
    .BREADY(BREADY),

    .ARADDR(ARADDR),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),

    .RDATA(RDATA),
    .RRESP(RRESP),
    .RVALID(RVALID),
    .RREADY(RREADY)

);

// Clock
initial
begin
    ACLK = 0;
    forever #5 ACLK = ~ACLK;
end

// Waveform Dump
initial
begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb);
end

// AXI Write Task
task axi_write(
    input [31:0] addr,
    input [31:0] data
);

begin

    @(posedge ACLK);

    AWADDR  <= addr;
    AWVALID <= 1'b1;

    WDATA   <= data;
    WVALID  <= 1'b1;

    BREADY  <= 1'b1;

    @(posedge ACLK);

    AWVALID <= 1'b0;
    WVALID  <= 1'b0;

    wait(BVALID);

    @(posedge ACLK);

    BREADY <= 1'b0;

    $display(
        "WRITE Addr=%h Data=%h",
        addr,data
    );

end

endtask

// AXI Read Task
task axi_read(
    input [31:0] addr
);

begin

    @(posedge ACLK);

    ARADDR  <= addr;
    ARVALID <= 1'b1;

    RREADY  <= 1'b1;

    @(posedge ACLK);

    ARVALID <= 1'b0;

    wait(RVALID);

    $display(
        "READ Addr=%h Data=%h",
        addr,
        RDATA
    );

    @(posedge ACLK);

    RREADY <= 1'b0;

end

endtask

// Test Cases
initial
begin

    ARESETn = 0;

    AWADDR  = 0;
    AWVALID = 0;

    WDATA   = 0;
    WVALID  = 0;

    BREADY  = 0;

    ARADDR  = 0;
    ARVALID = 0;

    RREADY  = 0;

    #20;

    ARESETn = 1;

    // Write Transactions
    axi_write(
        32'h00000000,
        32'h11111111
    );

    axi_write(
        32'h00000004,
        32'h22222222
    );

    axi_write(
        32'h00000008,
        32'h33333333
    );

    axi_write(
        32'h0000000C,
        32'h44444444
    );

    // Read Transactions
    axi_read(32'h00000000);
    axi_read(32'h00000004);
    axi_read(32'h00000008);
    axi_read(32'h0000000C);

    #20;

    $finish;

end

endmodule