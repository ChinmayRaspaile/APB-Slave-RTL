`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2026 22:30:40
// Design Name: 
// Module Name: apb_slave
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


module apb_slave #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
)(
    input  logic                  PCLK,
    input  logic                  PRESETn,
    input  logic                  PSEL,
    input  logic                  PENABLE,
    input  logic                  PWRITE,
    input  logic [ADDR_WIDTH-1:0] PADDR,
    input  logic [DATA_WIDTH-1:0] PWDATA,
    output logic [DATA_WIDTH-1:0] PRDATA,
    output logic                  PREADY,
    output logic                  PSLVERR
);

    // 4 x 32-bit registers
    logic [DATA_WIDTH-1:0] reg_file [0:3];

    assign PREADY  = 1'b1;   // no wait states
    assign PSLVERR = 1'b0;   // no error support

    // WRITE
    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            reg_file[0] <= '0;
            reg_file[1] <= '0;
            reg_file[2] <= '0;
            reg_file[3] <= '0;
        end
        else if (PSEL && PENABLE && PWRITE) begin
            reg_file[PADDR[3:2]] <= PWDATA;
        end
    end

    // READ
    always_comb begin
        if (PSEL && !PWRITE)
            PRDATA = reg_file[PADDR[3:2]];
        else
            PRDATA = '0;
    end

endmodule

