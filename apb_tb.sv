`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2026 22:31:57
// Design Name: 
// Module Name: apb_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module apb_tb;

    localparam ADDR_WIDTH = 8;
    localparam DATA_WIDTH = 32;

    logic                  PCLK;
    logic                  PRESETn;
    logic                  PSEL;
    logic                  PENABLE;
    logic                  PWRITE;
    logic [ADDR_WIDTH-1:0] PADDR;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [DATA_WIDTH-1:0] PRDATA;
    logic                  PREADY;
    logic                  PSLVERR;

    apb_slave dut (
        .PCLK    (PCLK),
        .PRESETn (PRESETn),
        .PSEL    (PSEL),
        .PENABLE (PENABLE),
        .PWRITE  (PWRITE),
        .PADDR   (PADDR),
        .PWDATA  (PWDATA),
        .PRDATA  (PRDATA),
        .PREADY  (PREADY),
        .PSLVERR (PSLVERR)
    );

    // Clock generation
    always #5 PCLK = ~PCLK;

    // APB WRITE task
    task apb_write(input logic [ADDR_WIDTH-1:0] addr,
                   input logic [DATA_WIDTH-1:0] data);
        begin
            @(posedge PCLK);
            PSEL    = 1;
            PWRITE  = 1;
            PADDR   = addr;
            PWDATA  = data;
            PENABLE = 0;

            @(posedge PCLK);
            PENABLE = 1;

            @(posedge PCLK);
            PSEL    = 0;
            PENABLE = 0;
            PWRITE  = 0;
        end
    endtask

    // APB READ task
    task apb_read(input  logic [ADDR_WIDTH-1:0] addr,
                  output logic [DATA_WIDTH-1:0] data);
        begin
            @(posedge PCLK);
            PSEL    = 1;
            PWRITE  = 0;
            PADDR   = addr;
            PENABLE = 0;

            @(posedge PCLK);
            PENABLE = 1;

            @(posedge PCLK);
            data = PRDATA;
            PSEL    = 0;
            PENABLE = 0;
        end
    endtask

    initial begin
        logic [31:0] rdata;

        // Init
        PCLK    = 0;
        PRESETn = 0;
        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 0;
        PWDATA  = 0;

        #20 PRESETn = 1;

        // Test sequence
        apb_write(8'h00, 32'hAAAA5555);
        apb_write(8'h04, 32'h12345678);

        apb_read(8'h00, rdata);
        if (rdata !== 32'hAAAA5555)
            $error("Mismatch at address 0x00");

        apb_read(8'h04, rdata);
        if (rdata !== 32'h12345678)
            $error("Mismatch at address 0x04");

        $display("APB TEST PASSED");
        #20;
        $finish;
    end

endmodule


