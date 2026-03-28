// Compiled by morty-0.9.0 / 2026-03-29 0:40:14.561176104 +05:45:00

/**
Implements a memory with sequential reads and writes.
- Both reads and writes take one cycle to perform.
- Attempting to read and write at the same time is an error.
- The out signal is registered to the last value requested by the read_en signal.
- The out signal is undefined once write_en is asserted.
*/
module seq_mem_d1 #(
    parameter WIDTH = 32,
    parameter SIZE = 16,
    parameter IDX_SIZE = 4
) (
   // Common signals
   input wire logic clk,
   input wire logic reset,
   input wire logic [IDX_SIZE-1:0] addr0,
   input wire logic content_en,
   output logic done,

   // Read signal
   output logic [ WIDTH-1:0] read_data,

   // Write signals
   input wire logic [ WIDTH-1:0] write_data,
   input wire logic write_en
);
  // Internal memory
  logic [WIDTH-1:0] mem[SIZE-1:0];

  // Register for the read output
  logic [WIDTH-1:0] read_out;
  assign read_data = read_out;

  // Read value from the memory
  always_ff @(posedge clk) begin
    if (reset) begin
      read_out <= '0;
    end else if (content_en && !write_en) begin
      /* verilator lint_off WIDTH */
      read_out <= mem[addr0];
    end else if (content_en && write_en) begin
      // Explicitly clobber the read output when a write is performed
      read_out <= 'x;
    end else begin
      read_out <= read_out;
    end
  end

  // Propagate the done signal
  always_ff @(posedge clk) begin
    if (reset) begin
      done <= '0;
    end else if (content_en) begin
      done <= '1;
    end else begin
      done <= '0;
    end
  end

  // Write value to the memory
  always_ff @(posedge clk) begin
    if (!reset && content_en && write_en)
      mem[addr0] <= write_data;
  end

  // Check for out of bounds access
  
endmodule

module seq_mem_d2 #(
    parameter WIDTH = 32,
    parameter D0_SIZE = 16,
    parameter D1_SIZE = 16,
    parameter D0_IDX_SIZE = 4,
    parameter D1_IDX_SIZE = 4
) (
   // Common signals
   input wire logic clk,
   input wire logic reset,
   input wire logic [D0_IDX_SIZE-1:0] addr0,
   input wire logic [D1_IDX_SIZE-1:0] addr1,
   input wire logic content_en,
   output logic done,

   // Read signal
   output logic [WIDTH-1:0] read_data,

   // Write signals
   input wire logic write_en,
   input wire logic [ WIDTH-1:0] write_data
);
  wire [D0_IDX_SIZE+D1_IDX_SIZE-1:0] addr;
  assign addr = addr0 * D1_SIZE + addr1;

  seq_mem_d1 #(.WIDTH(WIDTH), .SIZE(D0_SIZE * D1_SIZE), .IDX_SIZE(D0_IDX_SIZE+D1_IDX_SIZE)) mem
     (.clk(clk), .reset(reset), .addr0(addr),
    .content_en(content_en), .read_data(read_data), .write_data(write_data), .write_en(write_en),
    .done(done));
endmodule

module seq_mem_d3 #(
    parameter WIDTH = 32,
    parameter D0_SIZE = 16,
    parameter D1_SIZE = 16,
    parameter D2_SIZE = 16,
    parameter D0_IDX_SIZE = 4,
    parameter D1_IDX_SIZE = 4,
    parameter D2_IDX_SIZE = 4
) (
   // Common signals
   input wire logic clk,
   input wire logic reset,
   input wire logic [D0_IDX_SIZE-1:0] addr0,
   input wire logic [D1_IDX_SIZE-1:0] addr1,
   input wire logic [D2_IDX_SIZE-1:0] addr2,
   input wire logic content_en,
   output logic done,

   // Read signal
   output logic [WIDTH-1:0] read_data,

   // Write signals
   input wire logic write_en,
   input wire logic [ WIDTH-1:0] write_data
);
  wire [D0_IDX_SIZE+D1_IDX_SIZE+D2_IDX_SIZE-1:0] addr;
  assign addr = addr0 * (D1_SIZE * D2_SIZE) + addr1 * (D2_SIZE) + addr2;

  seq_mem_d1 #(.WIDTH(WIDTH), .SIZE(D0_SIZE * D1_SIZE * D2_SIZE), .IDX_SIZE(D0_IDX_SIZE+D1_IDX_SIZE+D2_IDX_SIZE)) mem
     (.clk(clk), .reset(reset), .addr0(addr),
    .content_en(content_en), .read_data(read_data), .write_data(write_data), .write_en(write_en),
    .done(done));
endmodule

module seq_mem_d4 #(
    parameter WIDTH = 32,
    parameter D0_SIZE = 16,
    parameter D1_SIZE = 16,
    parameter D2_SIZE = 16,
    parameter D3_SIZE = 16,
    parameter D0_IDX_SIZE = 4,
    parameter D1_IDX_SIZE = 4,
    parameter D2_IDX_SIZE = 4,
    parameter D3_IDX_SIZE = 4
) (
   // Common signals
   input wire logic clk,
   input wire logic reset,
   input wire logic [D0_IDX_SIZE-1:0] addr0,
   input wire logic [D1_IDX_SIZE-1:0] addr1,
   input wire logic [D2_IDX_SIZE-1:0] addr2,
   input wire logic [D3_IDX_SIZE-1:0] addr3,
   input wire logic content_en,
   output logic done,

   // Read signal
   output logic [WIDTH-1:0] read_data,

   // Write signals
   input wire logic write_en,
   input wire logic [ WIDTH-1:0] write_data
);
  wire [D0_IDX_SIZE+D1_IDX_SIZE+D2_IDX_SIZE+D3_IDX_SIZE-1:0] addr;
  assign addr = addr0 * (D1_SIZE * D2_SIZE * D3_SIZE) + addr1 * (D2_SIZE * D3_SIZE) + addr2 * (D3_SIZE) + addr3;

  seq_mem_d1 #(.WIDTH(WIDTH), .SIZE(D0_SIZE * D1_SIZE * D2_SIZE * D3_SIZE), .IDX_SIZE(D0_IDX_SIZE+D1_IDX_SIZE+D2_IDX_SIZE+D3_IDX_SIZE)) mem
     (.clk(clk), .reset(reset), .addr0(addr),
    .content_en(content_en), .read_data(read_data), .write_data(write_data), .write_en(write_en),
    .done(done));
endmodule
`define __MULFN_V__


/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define round_near_even   3'b000
`define round_minMag      3'b001
`define round_min         3'b010
`define round_max         3'b011
`define round_near_maxMag 3'b100
`define round_odd         3'b110

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define floatControlWidth 1
`define flControl_tininessBeforeRounding 1'b0
`define flControl_tininessAfterRounding  1'b1

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flRoundOpt_sigMSBitAlwaysZero  1
`define flRoundOpt_subnormsAlwaysExact 2
`define flRoundOpt_neverUnderflows     4
`define flRoundOpt_neverOverflows      8



module std_mulFN #(parameter expWidth = 8, parameter sigWidth = 24, parameter numWidth = 32) (
    input clk,
    input reset,
    input go,
    input [(1 - 1):0] control,
    input [(expWidth + sigWidth - 1):0] left,
    input [(expWidth + sigWidth - 1):0] right,
    input [2:0] roundingMode,
    output logic [(expWidth + sigWidth - 1):0] out,
    output logic [4:0] exceptionFlags,
    output done
);

    // Intermediate signals for recoded formats
    wire [(expWidth + sigWidth):0] l_recoded, r_recoded;

    // Convert 'a' and 'b' from standard to recoded format
    fNToRecFN #(expWidth, sigWidth) convert_l(
        .in(left),
        .out(l_recoded)
    );

    fNToRecFN #(expWidth, sigWidth) convert_r(
        .in(right),
        .out(r_recoded)
    );

    // Intermediate signals after the multiplier
    wire [(expWidth + sigWidth):0] res_recoded;
    wire [4:0] except_flag;

    // Compute recoded numbers
    mulRecFN #(expWidth, sigWidth) multiplier(
        .control(control),
        .a(l_recoded),
        .b(r_recoded),
        .roundingMode(roundingMode),
        .out(res_recoded),
        .exceptionFlags(except_flag)
    );

    wire [(expWidth + sigWidth - 1):0] res_std;

    // Convert the result back to standard format
    recFNToFN #(expWidth, sigWidth) convert_res(
        .in(res_recoded),
        .out(res_std)
    );

    logic done_buf[1:0];

    assign done = done_buf[1];

    // If the done buffer is completely empty and go is high then execution
    // just started.
    logic start;
    assign start = go;

    // Start sending the done signal.
    always_ff @(posedge clk) begin
        if (start)
            done_buf[0] <= 1;
        else
            done_buf[0] <= 0;
    end

    // Push the done signal through the pipeline.
    always_ff @(posedge clk) begin
        if (go) begin
            done_buf[1] <= done_buf[0];
        end else begin
            done_buf[1] <= 0;
        end
    end

    // Compute the output and save it into out
    always_ff @(posedge clk) begin
        if (reset) begin
            out <= 0;
        end else if (go) begin
            out <= res_std;
        end else begin
            out <= out;
        end
    end

endmodule


 /* __MULFN_V__ */
`define __ADDFN_V__


/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define round_near_even   3'b000
`define round_minMag      3'b001
`define round_min         3'b010
`define round_max         3'b011
`define round_near_maxMag 3'b100
`define round_odd         3'b110

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define floatControlWidth 1
`define flControl_tininessBeforeRounding 1'b0
`define flControl_tininessAfterRounding  1'b1

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flRoundOpt_sigMSBitAlwaysZero  1
`define flRoundOpt_subnormsAlwaysExact 2
`define flRoundOpt_neverUnderflows     4
`define flRoundOpt_neverOverflows      8



module std_addFN #(parameter expWidth = 8, parameter sigWidth = 24, parameter numWidth = 32) (
    input clk,
    input reset,
    input go,
    input [(1 - 1):0] control,
    input subOp,
    input [(expWidth + sigWidth - 1):0] left,
    input [(expWidth + sigWidth - 1):0] right,
    input [2:0] roundingMode,
    output logic [(expWidth + sigWidth - 1):0] out,
    output logic [4:0] exceptionFlags,
    output done
);

    // Intermediate signals for recoded formats
    wire [(expWidth + sigWidth):0] l_recoded, r_recoded;

    // Convert 'a' and 'b' from standard to recoded format
    fNToRecFN #(expWidth, sigWidth) convert_l(
        .in(left),
        .out(l_recoded)
    );

    fNToRecFN #(expWidth, sigWidth) convert_r(
        .in(right),
        .out(r_recoded)
    );

    // Intermediate signals after the adder
    wire [(expWidth + sigWidth):0] res_recoded;
    wire [4:0] except_flag;

    // Compute recoded numbers
    addRecFN #(expWidth, sigWidth) adder(
        .control(control),
        .subOp(subOp),
        .a(l_recoded),
        .b(r_recoded),
        .roundingMode(roundingMode),
        .out(res_recoded),
        .exceptionFlags(except_flag)
    );

    wire [(expWidth + sigWidth - 1):0] res_std;

    // Convert the result back to standard format
    recFNToFN #(expWidth, sigWidth) convert_res(
        .in(res_recoded),
        .out(res_std)
    );

    logic done_buf[1:0];

    assign done = done_buf[1];

    // If the done buffer is completely empty and go is high then execution
    // just started.
    logic start;
    assign start = go;

    // Start sending the done signal.
    always_ff @(posedge clk) begin
        if (start)
            done_buf[0] <= 1;
        else
            done_buf[0] <= 0;
    end

    // Push the done signal through the pipeline.
    always_ff @(posedge clk) begin
        if (go) begin
            done_buf[1] <= done_buf[0];
        end else begin
            done_buf[1] <= 0;
        end
    end

    // Compute the output and save it into out
    always_ff @(posedge clk) begin
        if (reset) begin
            out <= 0;
        end else if (go) begin
            out <= res_std;
        end else begin
            out <= out;
        end
    end

endmodule


 /* __ADDFN_V__ */
/**
 * Core primitives for Calyx.
 * Implements core primitives used by the compiler.
 *
 * Conventions:
 * - All parameter names must be SNAKE_CASE and all caps.
 * - Port names must be snake_case, no caps.
 */

module std_slice #(
    parameter IN_WIDTH  = 32,
    parameter OUT_WIDTH = 32
) (
   input wire                   logic [ IN_WIDTH-1:0] in,
   output logic [OUT_WIDTH-1:0] out
);
  assign out = in[OUT_WIDTH-1:0];

  
endmodule

module std_pad #(
    parameter IN_WIDTH  = 32,
    parameter OUT_WIDTH = 32
) (
   input wire logic [IN_WIDTH-1:0]  in,
   output logic     [OUT_WIDTH-1:0] out
);
  localparam EXTEND = OUT_WIDTH - IN_WIDTH;
  assign out = { {EXTEND {1'b0}}, in};

  
endmodule

module std_cat #(
  parameter LEFT_WIDTH  = 32,
  parameter RIGHT_WIDTH = 32,
  parameter OUT_WIDTH = 64
) (
  input wire logic [LEFT_WIDTH-1:0] left,
  input wire logic [RIGHT_WIDTH-1:0] right,
  output logic [OUT_WIDTH-1:0] out
);
  assign out = {left, right};

  
endmodule

module std_not #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] in,
   output logic [WIDTH-1:0] out
);
  assign out = ~in;
endmodule

module std_and #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left & right;
endmodule

module std_or #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left | right;
endmodule

module std_xor #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left ^ right;
endmodule

module std_sub #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left - right;
endmodule

module std_gt #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left > right;
endmodule

module std_lt #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left < right;
endmodule

module std_eq #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left == right;
endmodule

module std_neq #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left != right;
endmodule

module std_ge #(
    parameter WIDTH = 32
) (
    input wire   logic [WIDTH-1:0] left,
    input wire   logic [WIDTH-1:0] right,
    output logic out
);
  assign out = left >= right;
endmodule

module std_le #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left <= right;
endmodule

module std_rsh #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left >> right;
endmodule

/// this primitive is intended to be used
/// for lowering purposes (not in source programs)
module std_mux #(
    parameter WIDTH = 32
) (
   input wire               logic cond,
   input wire               logic [WIDTH-1:0] tru,
   input wire               logic [WIDTH-1:0] fal,
   output logic [WIDTH-1:0] out
);
  assign out = cond ? tru : fal;
endmodule

module std_bit_slice #(
    parameter IN_WIDTH = 32,
    parameter START_IDX = 0,
    parameter END_IDX = 31,
    parameter OUT_WIDTH = 32
)(
   input wire logic [IN_WIDTH-1:0] in,
   output logic [OUT_WIDTH-1:0] out
);
  assign out = in[END_IDX:START_IDX];

  

endmodule

module std_skid_buffer #(
    parameter WIDTH = 32
)(
    input wire logic [WIDTH-1:0] in,
    input wire logic i_valid,
    input wire logic i_ready,
    input wire logic clk,
    input wire logic reset,
    output logic [WIDTH-1:0] out,
    output logic o_valid,
    output logic o_ready
);
  logic [WIDTH-1:0] val;
  logic bypass_rg;
  always @(posedge clk) begin
    // Reset  
    if (reset) begin      
      // Internal Registers
      val <= '0;     
      bypass_rg <= 1'b1;
    end   
    // Out of reset
    else begin      
      // Bypass state      
      if (bypass_rg) begin         
        if (!i_ready && i_valid) begin
          val <= in;          // Data skid happened, store to buffer
          bypass_rg <= 1'b0;  // To skid mode  
        end 
      end 
      // Skid state
      else begin         
        if (i_ready) begin
          bypass_rg <= 1'b1;  // Back to bypass mode           
        end
      end
    end
  end

  assign o_ready = bypass_rg;
  assign out = bypass_rg ? in : val;
  assign o_valid = bypass_rg ? i_valid : 1'b1;
endmodule

module std_bypass_reg #(
    parameter WIDTH = 32
)(
    input wire logic [WIDTH-1:0] in,
    input wire logic write_en,
    input wire logic clk,
    input wire logic reset,
    output logic [WIDTH-1:0] out,
    output logic done
);
  logic [WIDTH-1:0] val;
  assign out = write_en ? in : val;

  always_ff @(posedge clk) begin
    if (reset) begin
      val <= 0;
      done <= 0;
    end else if (write_en) begin
      val <= in;
      done <= 1'd1;
    end else done <= 1'd0;
  end
endmodule
/* verilator lint_off MULTITOP */
/// =================== Unsigned, Fixed Point =========================
module std_fp_add #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out
);
  assign out = left + right;
endmodule

module std_fp_sub #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out
);
  assign out = left - right;
endmodule

module std_fp_mult_pipe #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16,
    parameter SIGNED = 0
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    input  logic             go,
    input  logic             clk,
    input  logic             reset,
    output logic [WIDTH-1:0] out,
    output logic             done
);
  logic [WIDTH-1:0]          rtmp;
  logic [WIDTH-1:0]          ltmp;
  logic [(WIDTH << 1) - 1:0] out_tmp;
  // Buffer used to walk through the 3 cycles of the pipeline.
  logic done_buf[1:0];

  assign done = done_buf[1];

  assign out = out_tmp[(WIDTH << 1) - INT_WIDTH - 1 : WIDTH - INT_WIDTH];

  // If the done buffer is completely empty and go is high then execution
  // just started.
  logic start;
  assign start = go;

  // Start sending the done signal.
  always_ff @(posedge clk) begin
    if (start)
      done_buf[0] <= 1;
    else
      done_buf[0] <= 0;
  end

  // Push the done signal through the pipeline.
  always_ff @(posedge clk) begin
    if (go) begin
      done_buf[1] <= done_buf[0];
    end else begin
      done_buf[1] <= 0;
    end
  end

  // Register the inputs
  always_ff @(posedge clk) begin
    if (reset) begin
      rtmp <= 0;
      ltmp <= 0;
    end else if (go) begin
      if (SIGNED) begin
        rtmp <= $signed(right);
        ltmp <= $signed(left);
      end else begin
        rtmp <= right;
        ltmp <= left;
      end
    end else begin
      rtmp <= 0;
      ltmp <= 0;
    end

  end

  // Compute the output and save it into out_tmp
  always_ff @(posedge clk) begin
    if (reset) begin
      out_tmp <= 0;
    end else if (go) begin
      if (SIGNED) begin
        // In the first cycle, this performs an invalid computation because
        // ltmp and rtmp only get their actual values in cycle 1
        out_tmp <= $signed(
          { {WIDTH{ltmp[WIDTH-1]}}, ltmp} *
          { {WIDTH{rtmp[WIDTH-1]}}, rtmp}
        );
      end else begin
        out_tmp <= ltmp * rtmp;
      end
    end else begin
      out_tmp <= out_tmp;
    end
  end
endmodule

/* verilator lint_off WIDTH */
module std_fp_div_pipe #(
  parameter WIDTH = 32,
  parameter INT_WIDTH = 16,
  parameter FRAC_WIDTH = 16
) (
    input  logic             go,
    input  logic             clk,
    input  logic             reset,
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out_remainder,
    output logic [WIDTH-1:0] out_quotient,
    output logic             done
);
    localparam ITERATIONS = WIDTH + FRAC_WIDTH;

    logic [WIDTH-1:0] quotient, quotient_next;
    logic [WIDTH:0] acc, acc_next;
    logic [$clog2(ITERATIONS)-1:0] idx;
    logic start, running, finished, dividend_is_zero;

    assign start = go && !running;
    assign dividend_is_zero = start && left == 0;
    assign finished = idx == ITERATIONS - 1 && running;

    always_ff @(posedge clk) begin
      if (reset || finished || dividend_is_zero)
        running <= 0;
      else if (start)
        running <= 1;
      else
        running <= running;
    end

    always @* begin
      if (acc >= {1'b0, right}) begin
        acc_next = acc - right;
        {acc_next, quotient_next} = {acc_next[WIDTH-1:0], quotient, 1'b1};
      end else begin
        {acc_next, quotient_next} = {acc, quotient} << 1;
      end
    end

    // `done` signaling
    always_ff @(posedge clk) begin
      if (dividend_is_zero || finished)
        done <= 1;
      else
        done <= 0;
    end

    always_ff @(posedge clk) begin
      if (running)
        idx <= idx + 1;
      else
        idx <= 0;
    end

    always_ff @(posedge clk) begin
      if (reset) begin
        out_quotient <= 0;
        out_remainder <= 0;
      end else if (start) begin
        out_quotient <= 0;
        out_remainder <= left;
      end else if (go == 0) begin
        out_quotient <= out_quotient;
        out_remainder <= out_remainder;
      end else if (dividend_is_zero) begin
        out_quotient <= 0;
        out_remainder <= 0;
      end else if (finished) begin
        out_quotient <= quotient_next;
        out_remainder <= out_remainder;
      end else begin
        out_quotient <= out_quotient;
        if (right <= out_remainder)
          out_remainder <= out_remainder - right;
        else
          out_remainder <= out_remainder;
      end
    end

    always_ff @(posedge clk) begin
      if (reset) begin
        acc <= 0;
        quotient <= 0;
      end else if (start) begin
        {acc, quotient} <= {{WIDTH{1'b0}}, left, 1'b0};
      end else begin
        acc <= acc_next;
        quotient <= quotient_next;
      end
    end
endmodule

module std_fp_gt #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic             out
);
  assign out = left > right;
endmodule

/// =================== Signed, Fixed Point =========================
module std_fp_sadd #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = $signed(left + right);
endmodule

module std_fp_ssub #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);

  assign out = $signed(left - right);
endmodule

module std_fp_smult_pipe #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  [WIDTH-1:0]              left,
    input  [WIDTH-1:0]              right,
    input  logic                    reset,
    input  logic                    go,
    input  logic                    clk,
    output logic [WIDTH-1:0]        out,
    output logic                    done
);
  std_fp_mult_pipe #(
    .WIDTH(WIDTH),
    .INT_WIDTH(INT_WIDTH),
    .FRAC_WIDTH(FRAC_WIDTH),
    .SIGNED(1)
  ) comp (
    .clk(clk),
    .done(done),
    .reset(reset),
    .go(go),
    .left(left),
    .right(right),
    .out(out)
  );
endmodule

module std_fp_sdiv_pipe #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input                     clk,
    input                     go,
    input                     reset,
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out_quotient,
    output signed [WIDTH-1:0] out_remainder,
    output logic              done
);

  logic signed [WIDTH-1:0] left_abs, right_abs, comp_out_q, comp_out_r, right_save, out_rem_intermediate;

  // Registers to figure out how to transform outputs.
  logic different_signs, left_sign, right_sign;

  // Latch the value of control registers so that their available after
  // go signal becomes low.
  always_ff @(posedge clk) begin
    if (go) begin
      right_save <= right_abs;
      left_sign <= left[WIDTH-1];
      right_sign <= right[WIDTH-1];
    end else begin
      left_sign <= left_sign;
      right_save <= right_save;
      right_sign <= right_sign;
    end
  end

  assign right_abs = right[WIDTH-1] ? -right : right;
  assign left_abs = left[WIDTH-1] ? -left : left;

  assign different_signs = left_sign ^ right_sign;
  assign out_quotient = different_signs ? -comp_out_q : comp_out_q;

  // Remainder is computed as:
  //  t0 = |left| % |right|
  //  t1 = if left * right < 0 and t0 != 0 then |right| - t0 else t0
  //  rem = if right < 0 then -t1 else t1
  assign out_rem_intermediate = different_signs & |comp_out_r ? $signed(right_save - comp_out_r) : comp_out_r;
  assign out_remainder = right_sign ? -out_rem_intermediate : out_rem_intermediate;

  std_fp_div_pipe #(
    .WIDTH(WIDTH),
    .INT_WIDTH(INT_WIDTH),
    .FRAC_WIDTH(FRAC_WIDTH)
  ) comp (
    .reset(reset),
    .clk(clk),
    .done(done),
    .go(go),
    .left(left_abs),
    .right(right_abs),
    .out_quotient(comp_out_q),
    .out_remainder(comp_out_r)
  );
endmodule

module std_fp_sgt #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic signed [WIDTH-1:0] left,
    input  logic signed [WIDTH-1:0] right,
    output logic signed             out
);
  assign out = $signed(left > right);
endmodule

module std_fp_slt #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
   input logic signed [WIDTH-1:0] left,
   input logic signed [WIDTH-1:0] right,
   output logic signed            out
);
  assign out = $signed(left < right);
endmodule

/// =================== Unsigned, Bitnum =========================
module std_mult_pipe #(
    parameter WIDTH = 32
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    input  logic             reset,
    input  logic             go,
    input  logic             clk,
    output logic [WIDTH-1:0] out,
    output logic             done
);
  std_fp_mult_pipe #(
    .WIDTH(WIDTH),
    .INT_WIDTH(WIDTH),
    .FRAC_WIDTH(0),
    .SIGNED(0)
  ) comp (
    .reset(reset),
    .clk(clk),
    .done(done),
    .go(go),
    .left(left),
    .right(right),
    .out(out)
  );
endmodule

module std_div_pipe #(
    parameter WIDTH = 32
) (
    input                    reset,
    input                    clk,
    input                    go,
    input        [WIDTH-1:0] left,
    input        [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out_remainder,
    output logic [WIDTH-1:0] out_quotient,
    output logic             done
);

  logic [WIDTH-1:0] dividend;
  logic [(WIDTH-1)*2:0] divisor;
  logic [WIDTH-1:0] quotient;
  logic [WIDTH-1:0] quotient_msk;
  logic start, running, finished, dividend_is_zero;

  assign start = go && !running;
  assign finished = quotient_msk == 0 && running;
  assign dividend_is_zero = start && left == 0;

  always_ff @(posedge clk) begin
    // Early return if the divisor is zero.
    if (finished || dividend_is_zero)
      done <= 1;
    else
      done <= 0;
  end

  always_ff @(posedge clk) begin
    if (reset || finished || dividend_is_zero)
      running <= 0;
    else if (start)
      running <= 1;
    else
      running <= running;
  end

  // Outputs
  always_ff @(posedge clk) begin
    if (dividend_is_zero || start) begin
      out_quotient <= 0;
      out_remainder <= 0;
    end else if (finished) begin
      out_quotient <= quotient;
      out_remainder <= dividend;
    end else begin
      // Otherwise, explicitly latch the values.
      out_quotient <= out_quotient;
      out_remainder <= out_remainder;
    end
  end

  // Calculate the quotient mask.
  always_ff @(posedge clk) begin
    if (start)
      quotient_msk <= 1 << WIDTH - 1;
    else if (running)
      quotient_msk <= quotient_msk >> 1;
    else
      quotient_msk <= quotient_msk;
  end

  // Calculate the quotient.
  always_ff @(posedge clk) begin
    if (start)
      quotient <= 0;
    else if (divisor <= dividend)
      quotient <= quotient | quotient_msk;
    else
      quotient <= quotient;
  end

  // Calculate the dividend.
  always_ff @(posedge clk) begin
    if (start)
      dividend <= left;
    else if (divisor <= dividend)
      dividend <= dividend - divisor;
    else
      dividend <= dividend;
  end

  always_ff @(posedge clk) begin
    if (start) begin
      divisor <= right << WIDTH - 1;
    end else if (finished) begin
      divisor <= 0;
    end else begin
      divisor <= divisor >> 1;
    end
  end

  // Simulation self test against unsynthesizable implementation.
  
endmodule

/// =================== Signed, Bitnum =========================
module std_sadd #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = $signed(left + right);
endmodule

module std_ssub #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = $signed(left - right);
endmodule

module std_smult_pipe #(
    parameter WIDTH = 32
) (
    input  logic                    reset,
    input  logic                    go,
    input  logic                    clk,
    input  signed       [WIDTH-1:0] left,
    input  signed       [WIDTH-1:0] right,
    output logic signed [WIDTH-1:0] out,
    output logic                    done
);
  std_fp_mult_pipe #(
    .WIDTH(WIDTH),
    .INT_WIDTH(WIDTH),
    .FRAC_WIDTH(0),
    .SIGNED(1)
  ) comp (
    .reset(reset),
    .clk(clk),
    .done(done),
    .go(go),
    .left(left),
    .right(right),
    .out(out)
  );
endmodule

/* verilator lint_off WIDTH */
module std_sdiv_pipe #(
    parameter WIDTH = 32
) (
    input                           reset,
    input                           clk,
    input                           go,
    input  logic signed [WIDTH-1:0] left,
    input  logic signed [WIDTH-1:0] right,
    output logic signed [WIDTH-1:0] out_quotient,
    output logic signed [WIDTH-1:0] out_remainder,
    output logic                    done
);

  logic signed [WIDTH-1:0] left_abs, right_abs, comp_out_q, comp_out_r, right_save, out_rem_intermediate;

  // Registers to figure out how to transform outputs.
  logic different_signs, left_sign, right_sign;

  // Latch the value of control registers so that their available after
  // go signal becomes low.
  always_ff @(posedge clk) begin
    if (go) begin
      right_save <= right_abs;
      left_sign <= left[WIDTH-1];
      right_sign <= right[WIDTH-1];
    end else begin
      left_sign <= left_sign;
      right_save <= right_save;
      right_sign <= right_sign;
    end
  end

  assign right_abs = right[WIDTH-1] ? -right : right;
  assign left_abs = left[WIDTH-1] ? -left : left;

  assign different_signs = left_sign ^ right_sign;
  assign out_quotient = different_signs ? -comp_out_q : comp_out_q;

  // Remainder is computed as:
  //  t0 = |left| % |right|
  //  t1 = if left * right < 0 and t0 != 0 then |right| - t0 else t0
  //  rem = if right < 0 then -t1 else t1
  assign out_rem_intermediate = different_signs & |comp_out_r ? $signed(right_save - comp_out_r) : comp_out_r;
  assign out_remainder = right_sign ? -out_rem_intermediate : out_rem_intermediate;

  std_div_pipe #(
    .WIDTH(WIDTH)
  ) comp (
    .reset(reset),
    .clk(clk),
    .done(done),
    .go(go),
    .left(left_abs),
    .right(right_abs),
    .out_quotient(comp_out_q),
    .out_remainder(comp_out_r)
  );

  // Simulation self test against unsynthesizable implementation.
  
endmodule

module std_sgt #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left > right);
endmodule

module std_slt #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left < right);
endmodule

module std_seq #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left == right);
endmodule

module std_sneq #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left != right);
endmodule

module std_sge #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left >= right);
endmodule

module std_sle #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left <= right);
endmodule

module std_slsh #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = left <<< right;
endmodule

module std_srsh #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = left >>> right;
endmodule

// Signed extension
module std_signext #(
  parameter IN_WIDTH  = 32,
  parameter OUT_WIDTH = 32
) (
  input wire logic [IN_WIDTH-1:0]  in,
  output logic     [OUT_WIDTH-1:0] out
);
  localparam EXTEND = OUT_WIDTH - IN_WIDTH;
  assign out = { {EXTEND {in[IN_WIDTH-1]}}, in};

  
endmodule

module std_const_mult #(
    parameter WIDTH = 32,
    parameter VALUE = 1
) (
    input  signed [WIDTH-1:0] in,
    output signed [WIDTH-1:0] out
);
  assign out = in * VALUE;
endmodule
module std_float_const #(
    parameter REP = 32,
    parameter WIDTH = 32,
    parameter VALUE = 32
) (
   output logic [WIDTH-1:0] out
);
assign out = VALUE;
endmodule

module undef #(
    parameter WIDTH = 32
) (
   output logic [WIDTH-1:0] out
);
assign out = 'x;
endmodule

module std_const #(
    parameter WIDTH = 32,
    parameter VALUE = 32
) (
   output logic [WIDTH-1:0] out
);
assign out = VALUE;
endmodule

module std_wire #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] in,
   output logic [WIDTH-1:0] out
);
assign out = in;
endmodule

module std_add #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] left,
   input wire logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
assign out = left + right;
endmodule

module std_lsh #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] left,
   input wire logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
assign out = left << right;
endmodule

module std_reg #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] in,
   input wire logic write_en,
   input wire logic clk,
   input wire logic reset,
   output logic [WIDTH-1:0] out,
   output logic done
);
always_ff @(posedge clk) begin
    if (reset) begin
       out <= 0;
       done <= 0;
    end else if (write_en) begin
      out <= in;
      done <= 1'd1;
    end else done <= 1'd0;
  end
endmodule

module init_one_reg #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] in,
   input wire logic write_en,
   input wire logic clk,
   input wire logic reset,
   output logic [WIDTH-1:0] out,
   output logic done
);
always_ff @(posedge clk) begin
    if (reset) begin
       out <= 1;
       done <= 0;
    end else if (write_en) begin
      out <= in;
      done <= 1'd1;
    end else done <= 1'd0;
  end
endmodule

module main(
  input logic clk,
  input logic reset,
  input logic go,
  output logic done
);
// COMPONENT START: main
string DATA;
int CODE;
initial begin
    CODE = $value$plusargs("DATA=%s", DATA);
    $display("DATA (path to meminit files): %s", DATA);
    $readmemh({DATA, "/mem_4.dat"}, mem_4.mem);
    $readmemh({DATA, "/mem_3.dat"}, mem_3.mem);
    $readmemh({DATA, "/mem_2.dat"}, mem_2.mem);
    $readmemh({DATA, "/mem_1.dat"}, mem_1.mem);
    $readmemh({DATA, "/mem_0.dat"}, mem_0.mem);
end
final begin
    $writememh({DATA, "/mem_4.out"}, mem_4.mem);
    $writememh({DATA, "/mem_3.out"}, mem_3.mem);
    $writememh({DATA, "/mem_2.out"}, mem_2.mem);
    $writememh({DATA, "/mem_1.out"}, mem_1.mem);
    $writememh({DATA, "/mem_0.out"}, mem_0.mem);
end
logic mem_4_clk;
logic mem_4_reset;
logic [3:0] mem_4_addr0;
logic mem_4_content_en;
logic mem_4_write_en;
logic [31:0] mem_4_write_data;
logic [31:0] mem_4_read_data;
logic mem_4_done;
logic mem_3_clk;
logic mem_3_reset;
logic [3:0] mem_3_addr0;
logic mem_3_content_en;
logic mem_3_write_en;
logic [31:0] mem_3_write_data;
logic [31:0] mem_3_read_data;
logic mem_3_done;
logic mem_2_clk;
logic mem_2_reset;
logic [12:0] mem_2_addr0;
logic mem_2_content_en;
logic mem_2_write_en;
logic [31:0] mem_2_write_data;
logic [31:0] mem_2_read_data;
logic mem_2_done;
logic mem_1_clk;
logic mem_1_reset;
logic [3:0] mem_1_addr0;
logic mem_1_content_en;
logic mem_1_write_en;
logic [31:0] mem_1_write_data;
logic [31:0] mem_1_read_data;
logic mem_1_done;
logic mem_0_clk;
logic mem_0_reset;
logic [9:0] mem_0_addr0;
logic mem_0_content_en;
logic mem_0_write_en;
logic [31:0] mem_0_write_data;
logic [31:0] mem_0_read_data;
logic mem_0_done;
logic forward_instance_clk;
logic forward_instance_reset;
logic forward_instance_go;
logic forward_instance_done;
logic [31:0] forward_instance_arg_mem_0_read_data;
logic forward_instance_arg_mem_0_done;
logic forward_instance_arg_mem_4_done;
logic [31:0] forward_instance_arg_mem_1_write_data;
logic [31:0] forward_instance_arg_mem_3_read_data;
logic [31:0] forward_instance_arg_mem_2_read_data;
logic [3:0] forward_instance_arg_mem_3_addr0;
logic [31:0] forward_instance_arg_mem_3_write_data;
logic [31:0] forward_instance_arg_mem_1_read_data;
logic forward_instance_arg_mem_0_content_en;
logic [31:0] forward_instance_arg_mem_4_write_data;
logic [9:0] forward_instance_arg_mem_0_addr0;
logic [3:0] forward_instance_arg_mem_4_addr0;
logic forward_instance_arg_mem_3_content_en;
logic forward_instance_arg_mem_3_done;
logic forward_instance_arg_mem_0_write_en;
logic forward_instance_arg_mem_3_write_en;
logic [12:0] forward_instance_arg_mem_2_addr0;
logic forward_instance_arg_mem_2_done;
logic forward_instance_arg_mem_1_done;
logic forward_instance_arg_mem_2_content_en;
logic [31:0] forward_instance_arg_mem_0_write_data;
logic forward_instance_arg_mem_1_write_en;
logic forward_instance_arg_mem_4_content_en;
logic forward_instance_arg_mem_2_write_en;
logic forward_instance_arg_mem_4_write_en;
logic [31:0] forward_instance_arg_mem_4_read_data;
logic [31:0] forward_instance_arg_mem_2_write_data;
logic [3:0] forward_instance_arg_mem_1_addr0;
logic forward_instance_arg_mem_1_content_en;
logic invoke0_go_in;
logic invoke0_go_out;
logic invoke0_done_in;
logic invoke0_done_out;
seq_mem_d1 # (
    .IDX_SIZE(4),
    .SIZE(10),
    .WIDTH(32)
) mem_4 (
    .addr0(mem_4_addr0),
    .clk(mem_4_clk),
    .content_en(mem_4_content_en),
    .done(mem_4_done),
    .read_data(mem_4_read_data),
    .reset(mem_4_reset),
    .write_data(mem_4_write_data),
    .write_en(mem_4_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(4),
    .SIZE(10),
    .WIDTH(32)
) mem_3 (
    .addr0(mem_3_addr0),
    .clk(mem_3_clk),
    .content_en(mem_3_content_en),
    .done(mem_3_done),
    .read_data(mem_3_read_data),
    .reset(mem_3_reset),
    .write_data(mem_3_write_data),
    .write_en(mem_3_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(13),
    .SIZE(7840),
    .WIDTH(32)
) mem_2 (
    .addr0(mem_2_addr0),
    .clk(mem_2_clk),
    .content_en(mem_2_content_en),
    .done(mem_2_done),
    .read_data(mem_2_read_data),
    .reset(mem_2_reset),
    .write_data(mem_2_write_data),
    .write_en(mem_2_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(4),
    .SIZE(10),
    .WIDTH(32)
) mem_1 (
    .addr0(mem_1_addr0),
    .clk(mem_1_clk),
    .content_en(mem_1_content_en),
    .done(mem_1_done),
    .read_data(mem_1_read_data),
    .reset(mem_1_reset),
    .write_data(mem_1_write_data),
    .write_en(mem_1_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(10),
    .SIZE(784),
    .WIDTH(32)
) mem_0 (
    .addr0(mem_0_addr0),
    .clk(mem_0_clk),
    .content_en(mem_0_content_en),
    .done(mem_0_done),
    .read_data(mem_0_read_data),
    .reset(mem_0_reset),
    .write_data(mem_0_write_data),
    .write_en(mem_0_write_en)
);
forward forward_instance (
    .arg_mem_0_addr0(forward_instance_arg_mem_0_addr0),
    .arg_mem_0_content_en(forward_instance_arg_mem_0_content_en),
    .arg_mem_0_done(forward_instance_arg_mem_0_done),
    .arg_mem_0_read_data(forward_instance_arg_mem_0_read_data),
    .arg_mem_0_write_data(forward_instance_arg_mem_0_write_data),
    .arg_mem_0_write_en(forward_instance_arg_mem_0_write_en),
    .arg_mem_1_addr0(forward_instance_arg_mem_1_addr0),
    .arg_mem_1_content_en(forward_instance_arg_mem_1_content_en),
    .arg_mem_1_done(forward_instance_arg_mem_1_done),
    .arg_mem_1_read_data(forward_instance_arg_mem_1_read_data),
    .arg_mem_1_write_data(forward_instance_arg_mem_1_write_data),
    .arg_mem_1_write_en(forward_instance_arg_mem_1_write_en),
    .arg_mem_2_addr0(forward_instance_arg_mem_2_addr0),
    .arg_mem_2_content_en(forward_instance_arg_mem_2_content_en),
    .arg_mem_2_done(forward_instance_arg_mem_2_done),
    .arg_mem_2_read_data(forward_instance_arg_mem_2_read_data),
    .arg_mem_2_write_data(forward_instance_arg_mem_2_write_data),
    .arg_mem_2_write_en(forward_instance_arg_mem_2_write_en),
    .arg_mem_3_addr0(forward_instance_arg_mem_3_addr0),
    .arg_mem_3_content_en(forward_instance_arg_mem_3_content_en),
    .arg_mem_3_done(forward_instance_arg_mem_3_done),
    .arg_mem_3_read_data(forward_instance_arg_mem_3_read_data),
    .arg_mem_3_write_data(forward_instance_arg_mem_3_write_data),
    .arg_mem_3_write_en(forward_instance_arg_mem_3_write_en),
    .arg_mem_4_addr0(forward_instance_arg_mem_4_addr0),
    .arg_mem_4_content_en(forward_instance_arg_mem_4_content_en),
    .arg_mem_4_done(forward_instance_arg_mem_4_done),
    .arg_mem_4_read_data(forward_instance_arg_mem_4_read_data),
    .arg_mem_4_write_data(forward_instance_arg_mem_4_write_data),
    .arg_mem_4_write_en(forward_instance_arg_mem_4_write_en),
    .clk(forward_instance_clk),
    .done(forward_instance_done),
    .go(forward_instance_go),
    .reset(forward_instance_reset)
);
std_wire # (
    .WIDTH(1)
) invoke0_go (
    .in(invoke0_go_in),
    .out(invoke0_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke0_done (
    .in(invoke0_done_in),
    .out(invoke0_done_out)
);
wire _guard0 = 1;
wire _guard1 = invoke0_done_out;
wire _guard2 = invoke0_go_out;
wire _guard3 = invoke0_go_out;
wire _guard4 = invoke0_go_out;
wire _guard5 = invoke0_go_out;
wire _guard6 = invoke0_go_out;
wire _guard7 = invoke0_go_out;
wire _guard8 = invoke0_go_out;
wire _guard9 = invoke0_go_out;
wire _guard10 = invoke0_go_out;
wire _guard11 = invoke0_go_out;
wire _guard12 = invoke0_go_out;
wire _guard13 = invoke0_go_out;
wire _guard14 = invoke0_go_out;
wire _guard15 = invoke0_go_out;
wire _guard16 = invoke0_go_out;
wire _guard17 = invoke0_go_out;
wire _guard18 = invoke0_go_out;
wire _guard19 = invoke0_go_out;
wire _guard20 = invoke0_go_out;
wire _guard21 = invoke0_go_out;
wire _guard22 = invoke0_go_out;
wire _guard23 = invoke0_go_out;
wire _guard24 = invoke0_go_out;
wire _guard25 = invoke0_go_out;
wire _guard26 = invoke0_go_out;
wire _guard27 = invoke0_go_out;
wire _guard28 = invoke0_go_out;
assign done = _guard1;
assign mem_2_write_en = 1'd0;
assign mem_2_clk = clk;
assign mem_2_addr0 = forward_instance_arg_mem_2_addr0;
assign mem_2_content_en =
  _guard3 ? forward_instance_arg_mem_2_content_en :
  1'd0;
assign mem_2_reset = reset;
assign mem_4_write_en =
  _guard4 ? forward_instance_arg_mem_4_write_en :
  1'd0;
assign mem_4_clk = clk;
assign mem_4_addr0 = forward_instance_arg_mem_4_addr0;
assign mem_4_content_en =
  _guard6 ? forward_instance_arg_mem_4_content_en :
  1'd0;
assign mem_4_reset = reset;
assign mem_4_write_data = forward_instance_arg_mem_4_write_data;
assign invoke0_go_in = go;
assign mem_1_write_en =
  _guard8 ? forward_instance_arg_mem_1_write_en :
  1'd0;
assign mem_1_clk = clk;
assign mem_1_addr0 = forward_instance_arg_mem_1_addr0;
assign mem_1_content_en =
  _guard10 ? forward_instance_arg_mem_1_content_en :
  1'd0;
assign mem_1_reset = reset;
assign mem_1_write_data = forward_instance_arg_mem_1_write_data;
assign forward_instance_arg_mem_0_read_data =
  _guard12 ? mem_0_read_data :
  32'd0;
assign forward_instance_arg_mem_0_done =
  _guard13 ? mem_0_done :
  1'd0;
assign forward_instance_arg_mem_4_done =
  _guard14 ? mem_4_done :
  1'd0;
assign forward_instance_arg_mem_3_read_data =
  _guard15 ? mem_3_read_data :
  32'd0;
assign forward_instance_arg_mem_2_read_data =
  _guard16 ? mem_2_read_data :
  32'd0;
assign forward_instance_arg_mem_1_read_data =
  _guard17 ? mem_1_read_data :
  32'd0;
assign forward_instance_clk = clk;
assign forward_instance_arg_mem_3_done =
  _guard18 ? mem_3_done :
  1'd0;
assign forward_instance_reset = reset;
assign forward_instance_go = _guard19;
assign forward_instance_arg_mem_2_done =
  _guard20 ? mem_2_done :
  1'd0;
assign forward_instance_arg_mem_1_done =
  _guard21 ? mem_1_done :
  1'd0;
assign forward_instance_arg_mem_4_read_data =
  _guard22 ? mem_4_read_data :
  32'd0;
assign invoke0_done_in = forward_instance_done;
assign mem_0_write_en = 1'd0;
assign mem_0_clk = clk;
assign mem_0_addr0 = forward_instance_arg_mem_0_addr0;
assign mem_0_content_en =
  _guard24 ? forward_instance_arg_mem_0_content_en :
  1'd0;
assign mem_0_reset = reset;
assign mem_3_write_en =
  _guard25 ? forward_instance_arg_mem_3_write_en :
  1'd0;
assign mem_3_clk = clk;
assign mem_3_addr0 = forward_instance_arg_mem_3_addr0;
assign mem_3_content_en =
  _guard27 ? forward_instance_arg_mem_3_content_en :
  1'd0;
assign mem_3_reset = reset;
assign mem_3_write_data = forward_instance_arg_mem_3_write_data;
// COMPONENT END: main
endmodule
module linear2d_0(
  input logic clk,
  input logic reset,
  input logic go,
  output logic done,
  output logic [3:0] arg_mem_3_addr0,
  output logic arg_mem_3_content_en,
  output logic arg_mem_3_write_en,
  output logic [31:0] arg_mem_3_write_data,
  input logic [31:0] arg_mem_3_read_data,
  input logic arg_mem_3_done,
  output logic [3:0] arg_mem_2_addr0,
  output logic arg_mem_2_content_en,
  output logic arg_mem_2_write_en,
  output logic [31:0] arg_mem_2_write_data,
  input logic [31:0] arg_mem_2_read_data,
  input logic arg_mem_2_done,
  output logic [12:0] arg_mem_1_addr0,
  output logic arg_mem_1_content_en,
  output logic arg_mem_1_write_en,
  output logic [31:0] arg_mem_1_write_data,
  input logic [31:0] arg_mem_1_read_data,
  input logic arg_mem_1_done,
  output logic [9:0] arg_mem_0_addr0,
  output logic arg_mem_0_content_en,
  output logic arg_mem_0_write_en,
  output logic [31:0] arg_mem_0_write_data,
  input logic [31:0] arg_mem_0_read_data,
  input logic arg_mem_0_done
);
// COMPONENT START: linear2d_0
logic [31:0] cst_0_out;
logic [31:0] std_slice_11_in;
logic [3:0] std_slice_11_out;
logic [31:0] std_slice_10_in;
logic [9:0] std_slice_10_out;
logic [31:0] std_slice_9_in;
logic std_slice_9_out;
logic [31:0] std_slice_7_in;
logic [12:0] std_slice_7_out;
logic [31:0] std_add_5_left;
logic [31:0] std_add_5_right;
logic [31:0] std_add_5_out;
logic std_addFN_1_clk;
logic std_addFN_1_reset;
logic std_addFN_1_go;
logic std_addFN_1_control;
logic std_addFN_1_subOp;
logic [31:0] std_addFN_1_left;
logic [31:0] std_addFN_1_right;
logic [2:0] std_addFN_1_roundingMode;
logic [31:0] std_addFN_1_out;
logic [4:0] std_addFN_1_exceptionFlags;
logic std_addFN_1_done;
logic [31:0] addf_0_reg_in;
logic addf_0_reg_write_en;
logic addf_0_reg_clk;
logic addf_0_reg_reset;
logic [31:0] addf_0_reg_out;
logic addf_0_reg_done;
logic std_addFN_0_clk;
logic std_addFN_0_reset;
logic std_addFN_0_go;
logic std_addFN_0_control;
logic std_addFN_0_subOp;
logic [31:0] std_addFN_0_left;
logic [31:0] std_addFN_0_right;
logic [2:0] std_addFN_0_roundingMode;
logic [31:0] std_addFN_0_out;
logic [4:0] std_addFN_0_exceptionFlags;
logic std_addFN_0_done;
logic [31:0] load_1_reg_in;
logic load_1_reg_write_en;
logic load_1_reg_clk;
logic load_1_reg_reset;
logic [31:0] load_1_reg_out;
logic load_1_reg_done;
logic [31:0] mulf_0_reg_in;
logic mulf_0_reg_write_en;
logic mulf_0_reg_clk;
logic mulf_0_reg_reset;
logic [31:0] mulf_0_reg_out;
logic mulf_0_reg_done;
logic std_mulFN_0_clk;
logic std_mulFN_0_reset;
logic std_mulFN_0_go;
logic std_mulFN_0_control;
logic [31:0] std_mulFN_0_left;
logic [31:0] std_mulFN_0_right;
logic [2:0] std_mulFN_0_roundingMode;
logic [31:0] std_mulFN_0_out;
logic [4:0] std_mulFN_0_exceptionFlags;
logic std_mulFN_0_done;
logic std_mult_pipe_0_clk;
logic std_mult_pipe_0_reset;
logic std_mult_pipe_0_go;
logic [31:0] std_mult_pipe_0_left;
logic [31:0] std_mult_pipe_0_right;
logic [31:0] std_mult_pipe_0_out;
logic std_mult_pipe_0_done;
logic mem_2_clk;
logic mem_2_reset;
logic mem_2_addr0;
logic mem_2_content_en;
logic mem_2_write_en;
logic [31:0] mem_2_write_data;
logic [31:0] mem_2_read_data;
logic mem_2_done;
logic mem_1_clk;
logic mem_1_reset;
logic [3:0] mem_1_addr0;
logic mem_1_content_en;
logic mem_1_write_en;
logic [31:0] mem_1_write_data;
logic [31:0] mem_1_read_data;
logic mem_1_done;
logic mem_0_clk;
logic mem_0_reset;
logic [3:0] mem_0_addr0;
logic mem_0_content_en;
logic mem_0_write_en;
logic [31:0] mem_0_write_data;
logic [31:0] mem_0_read_data;
logic mem_0_done;
logic [31:0] for_2_induction_var_reg_in;
logic for_2_induction_var_reg_write_en;
logic for_2_induction_var_reg_clk;
logic for_2_induction_var_reg_reset;
logic [31:0] for_2_induction_var_reg_out;
logic for_2_induction_var_reg_done;
logic [31:0] for_1_induction_var_reg_in;
logic for_1_induction_var_reg_write_en;
logic for_1_induction_var_reg_clk;
logic for_1_induction_var_reg_reset;
logic [31:0] for_1_induction_var_reg_out;
logic for_1_induction_var_reg_done;
logic [3:0] idx_in;
logic idx_write_en;
logic idx_clk;
logic idx_reset;
logic [3:0] idx_out;
logic idx_done;
logic cond_reg_in;
logic cond_reg_write_en;
logic cond_reg_clk;
logic cond_reg_reset;
logic cond_reg_out;
logic cond_reg_done;
logic [3:0] adder_left;
logic [3:0] adder_right;
logic [3:0] adder_out;
logic [3:0] lt_left;
logic [3:0] lt_right;
logic lt_out;
logic [9:0] idx0_in;
logic idx0_write_en;
logic idx0_clk;
logic idx0_reset;
logic [9:0] idx0_out;
logic idx0_done;
logic cond_reg0_in;
logic cond_reg0_write_en;
logic cond_reg0_clk;
logic cond_reg0_reset;
logic cond_reg0_out;
logic cond_reg0_done;
logic [9:0] adder0_left;
logic [9:0] adder0_right;
logic [9:0] adder0_out;
logic [9:0] lt0_left;
logic [9:0] lt0_right;
logic lt0_out;
logic [3:0] idx1_in;
logic idx1_write_en;
logic idx1_clk;
logic idx1_reset;
logic [3:0] idx1_out;
logic idx1_done;
logic cond_reg1_in;
logic cond_reg1_write_en;
logic cond_reg1_clk;
logic cond_reg1_reset;
logic cond_reg1_out;
logic cond_reg1_done;
logic [3:0] adder1_left;
logic [3:0] adder1_right;
logic [3:0] adder1_out;
logic [3:0] lt1_left;
logic [3:0] lt1_right;
logic lt1_out;
logic [3:0] idx2_in;
logic idx2_write_en;
logic idx2_clk;
logic idx2_reset;
logic [3:0] idx2_out;
logic idx2_done;
logic cond_reg2_in;
logic cond_reg2_write_en;
logic cond_reg2_clk;
logic cond_reg2_reset;
logic cond_reg2_out;
logic cond_reg2_done;
logic [3:0] adder2_left;
logic [3:0] adder2_right;
logic [3:0] adder2_out;
logic [3:0] lt2_left;
logic [3:0] lt2_right;
logic lt2_out;
logic [1:0] fsm_in;
logic fsm_write_en;
logic fsm_clk;
logic fsm_reset;
logic [1:0] fsm_out;
logic fsm_done;
logic [2:0] fsm0_in;
logic fsm0_write_en;
logic fsm0_clk;
logic fsm0_reset;
logic [2:0] fsm0_out;
logic fsm0_done;
logic [3:0] fsm1_in;
logic fsm1_write_en;
logic fsm1_clk;
logic fsm1_reset;
logic [3:0] fsm1_out;
logic fsm1_done;
logic [1:0] adder3_left;
logic [1:0] adder3_right;
logic [1:0] adder3_out;
logic [2:0] adder4_left;
logic [2:0] adder4_right;
logic [2:0] adder4_out;
logic [3:0] adder5_left;
logic [3:0] adder5_right;
logic [3:0] adder5_out;
logic ud_out;
logic ud0_out;
logic ud1_out;
logic [2:0] adder6_left;
logic [2:0] adder6_right;
logic [2:0] adder6_out;
logic ud2_out;
logic [2:0] adder7_left;
logic [2:0] adder7_right;
logic [2:0] adder7_out;
logic ud3_out;
logic [2:0] adder8_left;
logic [2:0] adder8_right;
logic [2:0] adder8_out;
logic ud4_out;
logic [2:0] adder9_left;
logic [2:0] adder9_right;
logic [2:0] adder9_out;
logic ud5_out;
logic [2:0] adder10_left;
logic [2:0] adder10_right;
logic [2:0] adder10_out;
logic ud6_out;
logic [2:0] adder11_left;
logic [2:0] adder11_right;
logic [2:0] adder11_out;
logic ud7_out;
logic signal_reg_in;
logic signal_reg_write_en;
logic signal_reg_clk;
logic signal_reg_reset;
logic signal_reg_out;
logic signal_reg_done;
logic signal_reg0_in;
logic signal_reg0_write_en;
logic signal_reg0_clk;
logic signal_reg0_reset;
logic signal_reg0_out;
logic signal_reg0_done;
logic [4:0] fsm2_in;
logic fsm2_write_en;
logic fsm2_clk;
logic fsm2_reset;
logic [4:0] fsm2_out;
logic fsm2_done;
logic bb0_1_go_in;
logic bb0_1_go_out;
logic bb0_1_done_in;
logic bb0_1_done_out;
logic bb0_6_go_in;
logic bb0_6_go_out;
logic bb0_6_done_in;
logic bb0_6_done_out;
logic bb0_7_go_in;
logic bb0_7_go_out;
logic bb0_7_done_in;
logic bb0_7_done_out;
logic bb0_9_go_in;
logic bb0_9_go_out;
logic bb0_9_done_in;
logic bb0_9_done_out;
logic bb0_12_go_in;
logic bb0_12_go_out;
logic bb0_12_done_in;
logic bb0_12_done_out;
logic bb0_13_go_in;
logic bb0_13_go_out;
logic bb0_13_done_in;
logic bb0_13_done_out;
logic bb0_16_go_in;
logic bb0_16_go_out;
logic bb0_16_done_in;
logic bb0_16_done_out;
logic invoke14_go_in;
logic invoke14_go_out;
logic invoke14_done_in;
logic invoke14_done_out;
logic invoke15_go_in;
logic invoke15_go_out;
logic invoke15_done_in;
logic invoke15_done_out;
logic invoke20_go_in;
logic invoke20_go_out;
logic invoke20_done_in;
logic invoke20_done_out;
logic invoke23_go_in;
logic invoke23_go_out;
logic invoke23_done_in;
logic invoke23_done_out;
logic init_repeat_go_in;
logic init_repeat_go_out;
logic init_repeat_done_in;
logic init_repeat_done_out;
logic incr_repeat_go_in;
logic incr_repeat_go_out;
logic incr_repeat_done_in;
logic incr_repeat_done_out;
logic init_repeat0_go_in;
logic init_repeat0_go_out;
logic init_repeat0_done_in;
logic init_repeat0_done_out;
logic incr_repeat0_go_in;
logic incr_repeat0_go_out;
logic incr_repeat0_done_in;
logic incr_repeat0_done_out;
logic init_repeat1_go_in;
logic init_repeat1_go_out;
logic init_repeat1_done_in;
logic init_repeat1_done_out;
logic incr_repeat1_go_in;
logic incr_repeat1_go_out;
logic incr_repeat1_done_in;
logic incr_repeat1_done_out;
logic init_repeat2_go_in;
logic init_repeat2_go_out;
logic init_repeat2_done_in;
logic init_repeat2_done_out;
logic incr_repeat2_go_in;
logic incr_repeat2_go_out;
logic incr_repeat2_done_in;
logic incr_repeat2_done_out;
logic early_reset_static_par_thread_go_in;
logic early_reset_static_par_thread_go_out;
logic early_reset_static_par_thread_done_in;
logic early_reset_static_par_thread_done_out;
logic early_reset_static_seq0_go_in;
logic early_reset_static_seq0_go_out;
logic early_reset_static_seq0_done_in;
logic early_reset_static_seq0_done_out;
logic early_reset_static_par_thread0_go_in;
logic early_reset_static_par_thread0_go_out;
logic early_reset_static_par_thread0_done_in;
logic early_reset_static_par_thread0_done_out;
logic early_reset_static_par_thread1_go_in;
logic early_reset_static_par_thread1_go_out;
logic early_reset_static_par_thread1_done_in;
logic early_reset_static_par_thread1_done_out;
logic early_reset_static_seq3_go_in;
logic early_reset_static_seq3_go_out;
logic early_reset_static_seq3_done_in;
logic early_reset_static_seq3_done_out;
logic early_reset_static_seq4_go_in;
logic early_reset_static_seq4_go_out;
logic early_reset_static_seq4_done_in;
logic early_reset_static_seq4_done_out;
logic early_reset_static_seq5_go_in;
logic early_reset_static_seq5_go_out;
logic early_reset_static_seq5_done_in;
logic early_reset_static_seq5_done_out;
logic early_reset_static_seq6_go_in;
logic early_reset_static_seq6_go_out;
logic early_reset_static_seq6_done_in;
logic early_reset_static_seq6_done_out;
logic early_reset_static_seq7_go_in;
logic early_reset_static_seq7_go_out;
logic early_reset_static_seq7_done_in;
logic early_reset_static_seq7_done_out;
logic wrapper_early_reset_static_par_thread_go_in;
logic wrapper_early_reset_static_par_thread_go_out;
logic wrapper_early_reset_static_par_thread_done_in;
logic wrapper_early_reset_static_par_thread_done_out;
logic wrapper_early_reset_static_par_thread0_go_in;
logic wrapper_early_reset_static_par_thread0_go_out;
logic wrapper_early_reset_static_par_thread0_done_in;
logic wrapper_early_reset_static_par_thread0_done_out;
logic wrapper_early_reset_static_par_thread1_go_in;
logic wrapper_early_reset_static_par_thread1_go_out;
logic wrapper_early_reset_static_par_thread1_done_in;
logic wrapper_early_reset_static_par_thread1_done_out;
logic wrapper_early_reset_static_seq3_go_in;
logic wrapper_early_reset_static_seq3_go_out;
logic wrapper_early_reset_static_seq3_done_in;
logic wrapper_early_reset_static_seq3_done_out;
logic wrapper_early_reset_static_seq4_go_in;
logic wrapper_early_reset_static_seq4_go_out;
logic wrapper_early_reset_static_seq4_done_in;
logic wrapper_early_reset_static_seq4_done_out;
logic wrapper_early_reset_static_seq5_go_in;
logic wrapper_early_reset_static_seq5_go_out;
logic wrapper_early_reset_static_seq5_done_in;
logic wrapper_early_reset_static_seq5_done_out;
logic wrapper_early_reset_static_seq6_go_in;
logic wrapper_early_reset_static_seq6_go_out;
logic wrapper_early_reset_static_seq6_done_in;
logic wrapper_early_reset_static_seq6_done_out;
logic wrapper_early_reset_static_seq7_go_in;
logic wrapper_early_reset_static_seq7_go_out;
logic wrapper_early_reset_static_seq7_done_in;
logic wrapper_early_reset_static_seq7_done_out;
logic tdcc_go_in;
logic tdcc_go_out;
logic tdcc_done_in;
logic tdcc_done_out;
std_float_const # (
    .REP(0),
    .VALUE(0),
    .WIDTH(32)
) cst_0 (
    .out(cst_0_out)
);
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(4)
) std_slice_11 (
    .in(std_slice_11_in),
    .out(std_slice_11_out)
);
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(10)
) std_slice_10 (
    .in(std_slice_10_in),
    .out(std_slice_10_out)
);
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(1)
) std_slice_9 (
    .in(std_slice_9_in),
    .out(std_slice_9_out)
);
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(13)
) std_slice_7 (
    .in(std_slice_7_in),
    .out(std_slice_7_out)
);
std_add # (
    .WIDTH(32)
) std_add_5 (
    .left(std_add_5_left),
    .out(std_add_5_out),
    .right(std_add_5_right)
);
std_addFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_addFN_1 (
    .clk(std_addFN_1_clk),
    .control(std_addFN_1_control),
    .done(std_addFN_1_done),
    .exceptionFlags(std_addFN_1_exceptionFlags),
    .go(std_addFN_1_go),
    .left(std_addFN_1_left),
    .out(std_addFN_1_out),
    .reset(std_addFN_1_reset),
    .right(std_addFN_1_right),
    .roundingMode(std_addFN_1_roundingMode),
    .subOp(std_addFN_1_subOp)
);
std_reg # (
    .WIDTH(32)
) addf_0_reg (
    .clk(addf_0_reg_clk),
    .done(addf_0_reg_done),
    .in(addf_0_reg_in),
    .out(addf_0_reg_out),
    .reset(addf_0_reg_reset),
    .write_en(addf_0_reg_write_en)
);
std_addFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_addFN_0 (
    .clk(std_addFN_0_clk),
    .control(std_addFN_0_control),
    .done(std_addFN_0_done),
    .exceptionFlags(std_addFN_0_exceptionFlags),
    .go(std_addFN_0_go),
    .left(std_addFN_0_left),
    .out(std_addFN_0_out),
    .reset(std_addFN_0_reset),
    .right(std_addFN_0_right),
    .roundingMode(std_addFN_0_roundingMode),
    .subOp(std_addFN_0_subOp)
);
std_reg # (
    .WIDTH(32)
) load_1_reg (
    .clk(load_1_reg_clk),
    .done(load_1_reg_done),
    .in(load_1_reg_in),
    .out(load_1_reg_out),
    .reset(load_1_reg_reset),
    .write_en(load_1_reg_write_en)
);
std_reg # (
    .WIDTH(32)
) mulf_0_reg (
    .clk(mulf_0_reg_clk),
    .done(mulf_0_reg_done),
    .in(mulf_0_reg_in),
    .out(mulf_0_reg_out),
    .reset(mulf_0_reg_reset),
    .write_en(mulf_0_reg_write_en)
);
std_mulFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_mulFN_0 (
    .clk(std_mulFN_0_clk),
    .control(std_mulFN_0_control),
    .done(std_mulFN_0_done),
    .exceptionFlags(std_mulFN_0_exceptionFlags),
    .go(std_mulFN_0_go),
    .left(std_mulFN_0_left),
    .out(std_mulFN_0_out),
    .reset(std_mulFN_0_reset),
    .right(std_mulFN_0_right),
    .roundingMode(std_mulFN_0_roundingMode)
);
std_mult_pipe # (
    .WIDTH(32)
) std_mult_pipe_0 (
    .clk(std_mult_pipe_0_clk),
    .done(std_mult_pipe_0_done),
    .go(std_mult_pipe_0_go),
    .left(std_mult_pipe_0_left),
    .out(std_mult_pipe_0_out),
    .reset(std_mult_pipe_0_reset),
    .right(std_mult_pipe_0_right)
);
seq_mem_d1 # (
    .IDX_SIZE(1),
    .SIZE(1),
    .WIDTH(32)
) mem_2 (
    .addr0(mem_2_addr0),
    .clk(mem_2_clk),
    .content_en(mem_2_content_en),
    .done(mem_2_done),
    .read_data(mem_2_read_data),
    .reset(mem_2_reset),
    .write_data(mem_2_write_data),
    .write_en(mem_2_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(4),
    .SIZE(10),
    .WIDTH(32)
) mem_1 (
    .addr0(mem_1_addr0),
    .clk(mem_1_clk),
    .content_en(mem_1_content_en),
    .done(mem_1_done),
    .read_data(mem_1_read_data),
    .reset(mem_1_reset),
    .write_data(mem_1_write_data),
    .write_en(mem_1_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(4),
    .SIZE(10),
    .WIDTH(32)
) mem_0 (
    .addr0(mem_0_addr0),
    .clk(mem_0_clk),
    .content_en(mem_0_content_en),
    .done(mem_0_done),
    .read_data(mem_0_read_data),
    .reset(mem_0_reset),
    .write_data(mem_0_write_data),
    .write_en(mem_0_write_en)
);
std_reg # (
    .WIDTH(32)
) for_2_induction_var_reg (
    .clk(for_2_induction_var_reg_clk),
    .done(for_2_induction_var_reg_done),
    .in(for_2_induction_var_reg_in),
    .out(for_2_induction_var_reg_out),
    .reset(for_2_induction_var_reg_reset),
    .write_en(for_2_induction_var_reg_write_en)
);
std_reg # (
    .WIDTH(32)
) for_1_induction_var_reg (
    .clk(for_1_induction_var_reg_clk),
    .done(for_1_induction_var_reg_done),
    .in(for_1_induction_var_reg_in),
    .out(for_1_induction_var_reg_out),
    .reset(for_1_induction_var_reg_reset),
    .write_en(for_1_induction_var_reg_write_en)
);
std_reg # (
    .WIDTH(4)
) idx (
    .clk(idx_clk),
    .done(idx_done),
    .in(idx_in),
    .out(idx_out),
    .reset(idx_reset),
    .write_en(idx_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg (
    .clk(cond_reg_clk),
    .done(cond_reg_done),
    .in(cond_reg_in),
    .out(cond_reg_out),
    .reset(cond_reg_reset),
    .write_en(cond_reg_write_en)
);
std_add # (
    .WIDTH(4)
) adder (
    .left(adder_left),
    .out(adder_out),
    .right(adder_right)
);
std_lt # (
    .WIDTH(4)
) lt (
    .left(lt_left),
    .out(lt_out),
    .right(lt_right)
);
std_reg # (
    .WIDTH(10)
) idx0 (
    .clk(idx0_clk),
    .done(idx0_done),
    .in(idx0_in),
    .out(idx0_out),
    .reset(idx0_reset),
    .write_en(idx0_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg0 (
    .clk(cond_reg0_clk),
    .done(cond_reg0_done),
    .in(cond_reg0_in),
    .out(cond_reg0_out),
    .reset(cond_reg0_reset),
    .write_en(cond_reg0_write_en)
);
std_add # (
    .WIDTH(10)
) adder0 (
    .left(adder0_left),
    .out(adder0_out),
    .right(adder0_right)
);
std_lt # (
    .WIDTH(10)
) lt0 (
    .left(lt0_left),
    .out(lt0_out),
    .right(lt0_right)
);
std_reg # (
    .WIDTH(4)
) idx1 (
    .clk(idx1_clk),
    .done(idx1_done),
    .in(idx1_in),
    .out(idx1_out),
    .reset(idx1_reset),
    .write_en(idx1_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg1 (
    .clk(cond_reg1_clk),
    .done(cond_reg1_done),
    .in(cond_reg1_in),
    .out(cond_reg1_out),
    .reset(cond_reg1_reset),
    .write_en(cond_reg1_write_en)
);
std_add # (
    .WIDTH(4)
) adder1 (
    .left(adder1_left),
    .out(adder1_out),
    .right(adder1_right)
);
std_lt # (
    .WIDTH(4)
) lt1 (
    .left(lt1_left),
    .out(lt1_out),
    .right(lt1_right)
);
std_reg # (
    .WIDTH(4)
) idx2 (
    .clk(idx2_clk),
    .done(idx2_done),
    .in(idx2_in),
    .out(idx2_out),
    .reset(idx2_reset),
    .write_en(idx2_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg2 (
    .clk(cond_reg2_clk),
    .done(cond_reg2_done),
    .in(cond_reg2_in),
    .out(cond_reg2_out),
    .reset(cond_reg2_reset),
    .write_en(cond_reg2_write_en)
);
std_add # (
    .WIDTH(4)
) adder2 (
    .left(adder2_left),
    .out(adder2_out),
    .right(adder2_right)
);
std_lt # (
    .WIDTH(4)
) lt2 (
    .left(lt2_left),
    .out(lt2_out),
    .right(lt2_right)
);
std_reg # (
    .WIDTH(2)
) fsm (
    .clk(fsm_clk),
    .done(fsm_done),
    .in(fsm_in),
    .out(fsm_out),
    .reset(fsm_reset),
    .write_en(fsm_write_en)
);
std_reg # (
    .WIDTH(3)
) fsm0 (
    .clk(fsm0_clk),
    .done(fsm0_done),
    .in(fsm0_in),
    .out(fsm0_out),
    .reset(fsm0_reset),
    .write_en(fsm0_write_en)
);
std_reg # (
    .WIDTH(4)
) fsm1 (
    .clk(fsm1_clk),
    .done(fsm1_done),
    .in(fsm1_in),
    .out(fsm1_out),
    .reset(fsm1_reset),
    .write_en(fsm1_write_en)
);
std_add # (
    .WIDTH(2)
) adder3 (
    .left(adder3_left),
    .out(adder3_out),
    .right(adder3_right)
);
std_add # (
    .WIDTH(3)
) adder4 (
    .left(adder4_left),
    .out(adder4_out),
    .right(adder4_right)
);
std_add # (
    .WIDTH(4)
) adder5 (
    .left(adder5_left),
    .out(adder5_out),
    .right(adder5_right)
);
undef # (
    .WIDTH(1)
) ud (
    .out(ud_out)
);
undef # (
    .WIDTH(1)
) ud0 (
    .out(ud0_out)
);
undef # (
    .WIDTH(1)
) ud1 (
    .out(ud1_out)
);
std_add # (
    .WIDTH(3)
) adder6 (
    .left(adder6_left),
    .out(adder6_out),
    .right(adder6_right)
);
undef # (
    .WIDTH(1)
) ud2 (
    .out(ud2_out)
);
std_add # (
    .WIDTH(3)
) adder7 (
    .left(adder7_left),
    .out(adder7_out),
    .right(adder7_right)
);
undef # (
    .WIDTH(1)
) ud3 (
    .out(ud3_out)
);
std_add # (
    .WIDTH(3)
) adder8 (
    .left(adder8_left),
    .out(adder8_out),
    .right(adder8_right)
);
undef # (
    .WIDTH(1)
) ud4 (
    .out(ud4_out)
);
std_add # (
    .WIDTH(3)
) adder9 (
    .left(adder9_left),
    .out(adder9_out),
    .right(adder9_right)
);
undef # (
    .WIDTH(1)
) ud5 (
    .out(ud5_out)
);
std_add # (
    .WIDTH(3)
) adder10 (
    .left(adder10_left),
    .out(adder10_out),
    .right(adder10_right)
);
undef # (
    .WIDTH(1)
) ud6 (
    .out(ud6_out)
);
std_add # (
    .WIDTH(3)
) adder11 (
    .left(adder11_left),
    .out(adder11_out),
    .right(adder11_right)
);
undef # (
    .WIDTH(1)
) ud7 (
    .out(ud7_out)
);
std_reg # (
    .WIDTH(1)
) signal_reg (
    .clk(signal_reg_clk),
    .done(signal_reg_done),
    .in(signal_reg_in),
    .out(signal_reg_out),
    .reset(signal_reg_reset),
    .write_en(signal_reg_write_en)
);
std_reg # (
    .WIDTH(1)
) signal_reg0 (
    .clk(signal_reg0_clk),
    .done(signal_reg0_done),
    .in(signal_reg0_in),
    .out(signal_reg0_out),
    .reset(signal_reg0_reset),
    .write_en(signal_reg0_write_en)
);
std_reg # (
    .WIDTH(5)
) fsm2 (
    .clk(fsm2_clk),
    .done(fsm2_done),
    .in(fsm2_in),
    .out(fsm2_out),
    .reset(fsm2_reset),
    .write_en(fsm2_write_en)
);
std_wire # (
    .WIDTH(1)
) bb0_1_go (
    .in(bb0_1_go_in),
    .out(bb0_1_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_1_done (
    .in(bb0_1_done_in),
    .out(bb0_1_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_6_go (
    .in(bb0_6_go_in),
    .out(bb0_6_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_6_done (
    .in(bb0_6_done_in),
    .out(bb0_6_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_7_go (
    .in(bb0_7_go_in),
    .out(bb0_7_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_7_done (
    .in(bb0_7_done_in),
    .out(bb0_7_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_9_go (
    .in(bb0_9_go_in),
    .out(bb0_9_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_9_done (
    .in(bb0_9_done_in),
    .out(bb0_9_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_12_go (
    .in(bb0_12_go_in),
    .out(bb0_12_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_12_done (
    .in(bb0_12_done_in),
    .out(bb0_12_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_13_go (
    .in(bb0_13_go_in),
    .out(bb0_13_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_13_done (
    .in(bb0_13_done_in),
    .out(bb0_13_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_16_go (
    .in(bb0_16_go_in),
    .out(bb0_16_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_16_done (
    .in(bb0_16_done_in),
    .out(bb0_16_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke14_go (
    .in(invoke14_go_in),
    .out(invoke14_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke14_done (
    .in(invoke14_done_in),
    .out(invoke14_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke15_go (
    .in(invoke15_go_in),
    .out(invoke15_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke15_done (
    .in(invoke15_done_in),
    .out(invoke15_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke20_go (
    .in(invoke20_go_in),
    .out(invoke20_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke20_done (
    .in(invoke20_done_in),
    .out(invoke20_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke23_go (
    .in(invoke23_go_in),
    .out(invoke23_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke23_done (
    .in(invoke23_done_in),
    .out(invoke23_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat_go (
    .in(init_repeat_go_in),
    .out(init_repeat_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat_done (
    .in(init_repeat_done_in),
    .out(init_repeat_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat_go (
    .in(incr_repeat_go_in),
    .out(incr_repeat_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat_done (
    .in(incr_repeat_done_in),
    .out(incr_repeat_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat0_go (
    .in(init_repeat0_go_in),
    .out(init_repeat0_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat0_done (
    .in(init_repeat0_done_in),
    .out(init_repeat0_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat0_go (
    .in(incr_repeat0_go_in),
    .out(incr_repeat0_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat0_done (
    .in(incr_repeat0_done_in),
    .out(incr_repeat0_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat1_go (
    .in(init_repeat1_go_in),
    .out(init_repeat1_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat1_done (
    .in(init_repeat1_done_in),
    .out(init_repeat1_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat1_go (
    .in(incr_repeat1_go_in),
    .out(incr_repeat1_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat1_done (
    .in(incr_repeat1_done_in),
    .out(incr_repeat1_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat2_go (
    .in(init_repeat2_go_in),
    .out(init_repeat2_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat2_done (
    .in(init_repeat2_done_in),
    .out(init_repeat2_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat2_go (
    .in(incr_repeat2_go_in),
    .out(incr_repeat2_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat2_done (
    .in(incr_repeat2_done_in),
    .out(incr_repeat2_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread_go (
    .in(early_reset_static_par_thread_go_in),
    .out(early_reset_static_par_thread_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread_done (
    .in(early_reset_static_par_thread_done_in),
    .out(early_reset_static_par_thread_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq0_go (
    .in(early_reset_static_seq0_go_in),
    .out(early_reset_static_seq0_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq0_done (
    .in(early_reset_static_seq0_done_in),
    .out(early_reset_static_seq0_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread0_go (
    .in(early_reset_static_par_thread0_go_in),
    .out(early_reset_static_par_thread0_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread0_done (
    .in(early_reset_static_par_thread0_done_in),
    .out(early_reset_static_par_thread0_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread1_go (
    .in(early_reset_static_par_thread1_go_in),
    .out(early_reset_static_par_thread1_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread1_done (
    .in(early_reset_static_par_thread1_done_in),
    .out(early_reset_static_par_thread1_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq3_go (
    .in(early_reset_static_seq3_go_in),
    .out(early_reset_static_seq3_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq3_done (
    .in(early_reset_static_seq3_done_in),
    .out(early_reset_static_seq3_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq4_go (
    .in(early_reset_static_seq4_go_in),
    .out(early_reset_static_seq4_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq4_done (
    .in(early_reset_static_seq4_done_in),
    .out(early_reset_static_seq4_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq5_go (
    .in(early_reset_static_seq5_go_in),
    .out(early_reset_static_seq5_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq5_done (
    .in(early_reset_static_seq5_done_in),
    .out(early_reset_static_seq5_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq6_go (
    .in(early_reset_static_seq6_go_in),
    .out(early_reset_static_seq6_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq6_done (
    .in(early_reset_static_seq6_done_in),
    .out(early_reset_static_seq6_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq7_go (
    .in(early_reset_static_seq7_go_in),
    .out(early_reset_static_seq7_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq7_done (
    .in(early_reset_static_seq7_done_in),
    .out(early_reset_static_seq7_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread_go (
    .in(wrapper_early_reset_static_par_thread_go_in),
    .out(wrapper_early_reset_static_par_thread_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread_done (
    .in(wrapper_early_reset_static_par_thread_done_in),
    .out(wrapper_early_reset_static_par_thread_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread0_go (
    .in(wrapper_early_reset_static_par_thread0_go_in),
    .out(wrapper_early_reset_static_par_thread0_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread0_done (
    .in(wrapper_early_reset_static_par_thread0_done_in),
    .out(wrapper_early_reset_static_par_thread0_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread1_go (
    .in(wrapper_early_reset_static_par_thread1_go_in),
    .out(wrapper_early_reset_static_par_thread1_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread1_done (
    .in(wrapper_early_reset_static_par_thread1_done_in),
    .out(wrapper_early_reset_static_par_thread1_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq3_go (
    .in(wrapper_early_reset_static_seq3_go_in),
    .out(wrapper_early_reset_static_seq3_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq3_done (
    .in(wrapper_early_reset_static_seq3_done_in),
    .out(wrapper_early_reset_static_seq3_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq4_go (
    .in(wrapper_early_reset_static_seq4_go_in),
    .out(wrapper_early_reset_static_seq4_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq4_done (
    .in(wrapper_early_reset_static_seq4_done_in),
    .out(wrapper_early_reset_static_seq4_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq5_go (
    .in(wrapper_early_reset_static_seq5_go_in),
    .out(wrapper_early_reset_static_seq5_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq5_done (
    .in(wrapper_early_reset_static_seq5_done_in),
    .out(wrapper_early_reset_static_seq5_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq6_go (
    .in(wrapper_early_reset_static_seq6_go_in),
    .out(wrapper_early_reset_static_seq6_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq6_done (
    .in(wrapper_early_reset_static_seq6_done_in),
    .out(wrapper_early_reset_static_seq6_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq7_go (
    .in(wrapper_early_reset_static_seq7_go_in),
    .out(wrapper_early_reset_static_seq7_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq7_done (
    .in(wrapper_early_reset_static_seq7_done_in),
    .out(wrapper_early_reset_static_seq7_done_out)
);
std_wire # (
    .WIDTH(1)
) tdcc_go (
    .in(tdcc_go_in),
    .out(tdcc_go_out)
);
std_wire # (
    .WIDTH(1)
) tdcc_done (
    .in(tdcc_done_in),
    .out(tdcc_done_out)
);
wire _guard0 = 1;
wire _guard1 = bb0_1_go_out;
wire _guard2 = bb0_6_go_out;
wire _guard3 = fsm0_out == 3'd1;
wire _guard4 = early_reset_static_seq0_go_out;
wire _guard5 = _guard3 & _guard4;
wire _guard6 = _guard2 | _guard5;
wire _guard7 = fsm0_out == 3'd1;
wire _guard8 = early_reset_static_seq6_go_out;
wire _guard9 = _guard7 & _guard8;
wire _guard10 = invoke14_go_out;
wire _guard11 = fsm0_out == 3'd1;
wire _guard12 = early_reset_static_seq4_go_out;
wire _guard13 = _guard11 & _guard12;
wire _guard14 = invoke23_go_out;
wire _guard15 = invoke14_go_out;
wire _guard16 = invoke23_go_out;
wire _guard17 = _guard15 | _guard16;
wire _guard18 = fsm0_out == 3'd1;
wire _guard19 = early_reset_static_seq0_go_out;
wire _guard20 = _guard18 & _guard19;
wire _guard21 = _guard17 | _guard20;
wire _guard22 = fsm0_out == 3'd1;
wire _guard23 = early_reset_static_seq4_go_out;
wire _guard24 = _guard22 & _guard23;
wire _guard25 = _guard21 | _guard24;
wire _guard26 = fsm0_out == 3'd1;
wire _guard27 = early_reset_static_seq6_go_out;
wire _guard28 = _guard26 & _guard27;
wire _guard29 = _guard25 | _guard28;
wire _guard30 = bb0_6_go_out;
wire _guard31 = init_repeat1_go_out;
wire _guard32 = incr_repeat1_go_out;
wire _guard33 = _guard31 | _guard32;
wire _guard34 = init_repeat1_go_out;
wire _guard35 = incr_repeat1_go_out;
wire _guard36 = incr_repeat1_go_out;
wire _guard37 = incr_repeat1_go_out;
wire _guard38 = bb0_6_done_out;
wire _guard39 = ~_guard38;
wire _guard40 = fsm2_out == 5'd6;
wire _guard41 = _guard39 & _guard40;
wire _guard42 = tdcc_go_out;
wire _guard43 = _guard41 & _guard42;
wire _guard44 = init_repeat_done_out;
wire _guard45 = ~_guard44;
wire _guard46 = fsm2_out == 5'd4;
wire _guard47 = _guard45 & _guard46;
wire _guard48 = tdcc_go_out;
wire _guard49 = _guard47 & _guard48;
wire _guard50 = tdcc_done_out;
wire _guard51 = bb0_16_go_out;
wire _guard52 = bb0_16_go_out;
wire _guard53 = bb0_1_go_out;
wire _guard54 = bb0_1_go_out;
wire _guard55 = bb0_16_go_out;
wire _guard56 = bb0_16_go_out;
wire _guard57 = bb0_12_go_out;
wire _guard58 = bb0_12_go_out;
wire _guard59 = bb0_6_go_out;
wire _guard60 = bb0_6_go_out;
wire _guard61 = incr_repeat_go_out;
wire _guard62 = incr_repeat_go_out;
wire _guard63 = fsm_out != 2'd1;
wire _guard64 = early_reset_static_par_thread_go_out;
wire _guard65 = _guard63 & _guard64;
wire _guard66 = fsm_out == 2'd1;
wire _guard67 = fsm0_out == 3'd1;
wire _guard68 = fsm1_out == 4'd9;
wire _guard69 = _guard67 & _guard68;
wire _guard70 = _guard66 & _guard69;
wire _guard71 = early_reset_static_par_thread_go_out;
wire _guard72 = _guard70 & _guard71;
wire _guard73 = _guard65 | _guard72;
wire _guard74 = fsm_out == 2'd1;
wire _guard75 = fsm0_out == 3'd1;
wire _guard76 = fsm1_out == 4'd9;
wire _guard77 = _guard75 & _guard76;
wire _guard78 = _guard74 & _guard77;
wire _guard79 = early_reset_static_par_thread_go_out;
wire _guard80 = _guard78 & _guard79;
wire _guard81 = fsm_out != 2'd1;
wire _guard82 = early_reset_static_par_thread_go_out;
wire _guard83 = _guard81 & _guard82;
wire _guard84 = early_reset_static_seq6_go_out;
wire _guard85 = early_reset_static_seq6_go_out;
wire _guard86 = incr_repeat1_done_out;
wire _guard87 = ~_guard86;
wire _guard88 = fsm2_out == 5'd20;
wire _guard89 = _guard87 & _guard88;
wire _guard90 = tdcc_go_out;
wire _guard91 = _guard89 & _guard90;
wire _guard92 = wrapper_early_reset_static_par_thread1_go_out;
wire _guard93 = signal_reg0_out;
wire _guard94 = wrapper_early_reset_static_seq5_done_out;
wire _guard95 = ~_guard94;
wire _guard96 = fsm2_out == 5'd16;
wire _guard97 = _guard95 & _guard96;
wire _guard98 = tdcc_go_out;
wire _guard99 = _guard97 & _guard98;
wire _guard100 = init_repeat1_go_out;
wire _guard101 = incr_repeat1_go_out;
wire _guard102 = _guard100 | _guard101;
wire _guard103 = incr_repeat1_go_out;
wire _guard104 = init_repeat1_go_out;
wire _guard105 = incr_repeat1_go_out;
wire _guard106 = incr_repeat1_go_out;
wire _guard107 = incr_repeat2_go_out;
wire _guard108 = incr_repeat2_go_out;
wire _guard109 = early_reset_static_seq0_go_out;
wire _guard110 = early_reset_static_seq0_go_out;
wire _guard111 = signal_reg0_out;
wire _guard112 = _guard0 & _guard0;
wire _guard113 = signal_reg0_out;
wire _guard114 = ~_guard113;
wire _guard115 = _guard112 & _guard114;
wire _guard116 = wrapper_early_reset_static_par_thread0_go_out;
wire _guard117 = _guard115 & _guard116;
wire _guard118 = _guard111 | _guard117;
wire _guard119 = fsm0_out == 3'd3;
wire _guard120 = _guard119 & _guard0;
wire _guard121 = signal_reg0_out;
wire _guard122 = ~_guard121;
wire _guard123 = _guard120 & _guard122;
wire _guard124 = wrapper_early_reset_static_par_thread1_go_out;
wire _guard125 = _guard123 & _guard124;
wire _guard126 = _guard118 | _guard125;
wire _guard127 = fsm0_out == 3'd1;
wire _guard128 = _guard127 & _guard0;
wire _guard129 = signal_reg0_out;
wire _guard130 = ~_guard129;
wire _guard131 = _guard128 & _guard130;
wire _guard132 = wrapper_early_reset_static_seq3_go_out;
wire _guard133 = _guard131 & _guard132;
wire _guard134 = _guard126 | _guard133;
wire _guard135 = fsm0_out == 3'd1;
wire _guard136 = _guard135 & _guard0;
wire _guard137 = signal_reg0_out;
wire _guard138 = ~_guard137;
wire _guard139 = _guard136 & _guard138;
wire _guard140 = wrapper_early_reset_static_seq4_go_out;
wire _guard141 = _guard139 & _guard140;
wire _guard142 = _guard134 | _guard141;
wire _guard143 = fsm0_out == 3'd1;
wire _guard144 = _guard143 & _guard0;
wire _guard145 = signal_reg0_out;
wire _guard146 = ~_guard145;
wire _guard147 = _guard144 & _guard146;
wire _guard148 = wrapper_early_reset_static_seq5_go_out;
wire _guard149 = _guard147 & _guard148;
wire _guard150 = _guard142 | _guard149;
wire _guard151 = fsm0_out == 3'd1;
wire _guard152 = _guard151 & _guard0;
wire _guard153 = signal_reg0_out;
wire _guard154 = ~_guard153;
wire _guard155 = _guard152 & _guard154;
wire _guard156 = wrapper_early_reset_static_seq6_go_out;
wire _guard157 = _guard155 & _guard156;
wire _guard158 = _guard150 | _guard157;
wire _guard159 = fsm0_out == 3'd1;
wire _guard160 = _guard159 & _guard0;
wire _guard161 = signal_reg0_out;
wire _guard162 = ~_guard161;
wire _guard163 = _guard160 & _guard162;
wire _guard164 = wrapper_early_reset_static_seq7_go_out;
wire _guard165 = _guard163 & _guard164;
wire _guard166 = _guard158 | _guard165;
wire _guard167 = _guard0 & _guard0;
wire _guard168 = signal_reg0_out;
wire _guard169 = ~_guard168;
wire _guard170 = _guard167 & _guard169;
wire _guard171 = wrapper_early_reset_static_par_thread0_go_out;
wire _guard172 = _guard170 & _guard171;
wire _guard173 = fsm0_out == 3'd3;
wire _guard174 = _guard173 & _guard0;
wire _guard175 = signal_reg0_out;
wire _guard176 = ~_guard175;
wire _guard177 = _guard174 & _guard176;
wire _guard178 = wrapper_early_reset_static_par_thread1_go_out;
wire _guard179 = _guard177 & _guard178;
wire _guard180 = _guard172 | _guard179;
wire _guard181 = fsm0_out == 3'd1;
wire _guard182 = _guard181 & _guard0;
wire _guard183 = signal_reg0_out;
wire _guard184 = ~_guard183;
wire _guard185 = _guard182 & _guard184;
wire _guard186 = wrapper_early_reset_static_seq3_go_out;
wire _guard187 = _guard185 & _guard186;
wire _guard188 = _guard180 | _guard187;
wire _guard189 = fsm0_out == 3'd1;
wire _guard190 = _guard189 & _guard0;
wire _guard191 = signal_reg0_out;
wire _guard192 = ~_guard191;
wire _guard193 = _guard190 & _guard192;
wire _guard194 = wrapper_early_reset_static_seq4_go_out;
wire _guard195 = _guard193 & _guard194;
wire _guard196 = _guard188 | _guard195;
wire _guard197 = fsm0_out == 3'd1;
wire _guard198 = _guard197 & _guard0;
wire _guard199 = signal_reg0_out;
wire _guard200 = ~_guard199;
wire _guard201 = _guard198 & _guard200;
wire _guard202 = wrapper_early_reset_static_seq5_go_out;
wire _guard203 = _guard201 & _guard202;
wire _guard204 = _guard196 | _guard203;
wire _guard205 = fsm0_out == 3'd1;
wire _guard206 = _guard205 & _guard0;
wire _guard207 = signal_reg0_out;
wire _guard208 = ~_guard207;
wire _guard209 = _guard206 & _guard208;
wire _guard210 = wrapper_early_reset_static_seq6_go_out;
wire _guard211 = _guard209 & _guard210;
wire _guard212 = _guard204 | _guard211;
wire _guard213 = fsm0_out == 3'd1;
wire _guard214 = _guard213 & _guard0;
wire _guard215 = signal_reg0_out;
wire _guard216 = ~_guard215;
wire _guard217 = _guard214 & _guard216;
wire _guard218 = wrapper_early_reset_static_seq7_go_out;
wire _guard219 = _guard217 & _guard218;
wire _guard220 = _guard212 | _guard219;
wire _guard221 = signal_reg0_out;
wire _guard222 = wrapper_early_reset_static_par_thread_done_out;
wire _guard223 = ~_guard222;
wire _guard224 = fsm2_out == 5'd0;
wire _guard225 = _guard223 & _guard224;
wire _guard226 = tdcc_go_out;
wire _guard227 = _guard225 & _guard226;
wire _guard228 = early_reset_static_par_thread0_go_out;
wire _guard229 = early_reset_static_par_thread0_go_out;
wire _guard230 = fsm0_out == 3'd0;
wire _guard231 = early_reset_static_par_thread1_go_out;
wire _guard232 = _guard230 & _guard231;
wire _guard233 = _guard229 | _guard232;
wire _guard234 = early_reset_static_par_thread0_go_out;
wire _guard235 = fsm0_out == 3'd0;
wire _guard236 = early_reset_static_par_thread1_go_out;
wire _guard237 = _guard235 & _guard236;
wire _guard238 = _guard234 | _guard237;
wire _guard239 = early_reset_static_par_thread0_go_out;
wire _guard240 = init_repeat0_go_out;
wire _guard241 = incr_repeat0_go_out;
wire _guard242 = _guard240 | _guard241;
wire _guard243 = init_repeat0_go_out;
wire _guard244 = incr_repeat0_go_out;
wire _guard245 = wrapper_early_reset_static_seq4_go_out;
wire _guard246 = wrapper_early_reset_static_seq7_go_out;
wire _guard247 = init_repeat1_done_out;
wire _guard248 = ~_guard247;
wire _guard249 = fsm2_out == 5'd15;
wire _guard250 = _guard248 & _guard249;
wire _guard251 = tdcc_go_out;
wire _guard252 = _guard250 & _guard251;
wire _guard253 = fsm_out == 2'd1;
wire _guard254 = early_reset_static_par_thread_go_out;
wire _guard255 = _guard253 & _guard254;
wire _guard256 = wrapper_early_reset_static_seq5_go_out;
wire _guard257 = wrapper_early_reset_static_seq7_done_out;
wire _guard258 = ~_guard257;
wire _guard259 = fsm2_out == 5'd23;
wire _guard260 = _guard258 & _guard259;
wire _guard261 = tdcc_go_out;
wire _guard262 = _guard260 & _guard261;
wire _guard263 = init_repeat0_go_out;
wire _guard264 = incr_repeat0_go_out;
wire _guard265 = _guard263 | _guard264;
wire _guard266 = init_repeat0_go_out;
wire _guard267 = incr_repeat0_go_out;
wire _guard268 = fsm0_out == 3'd1;
wire _guard269 = fsm1_out != 4'd9;
wire _guard270 = _guard268 & _guard269;
wire _guard271 = early_reset_static_seq0_go_out;
wire _guard272 = _guard270 & _guard271;
wire _guard273 = fsm0_out == 3'd1;
wire _guard274 = fsm1_out == 4'd9;
wire _guard275 = _guard273 & _guard274;
wire _guard276 = early_reset_static_seq0_go_out;
wire _guard277 = _guard275 & _guard276;
wire _guard278 = _guard272 | _guard277;
wire _guard279 = fsm0_out == 3'd1;
wire _guard280 = fsm1_out == 4'd9;
wire _guard281 = _guard279 & _guard280;
wire _guard282 = early_reset_static_seq0_go_out;
wire _guard283 = _guard281 & _guard282;
wire _guard284 = fsm0_out == 3'd1;
wire _guard285 = fsm1_out != 4'd9;
wire _guard286 = _guard284 & _guard285;
wire _guard287 = early_reset_static_seq0_go_out;
wire _guard288 = _guard286 & _guard287;
wire _guard289 = bb0_9_done_out;
wire _guard290 = ~_guard289;
wire _guard291 = fsm2_out == 5'd9;
wire _guard292 = _guard290 & _guard291;
wire _guard293 = tdcc_go_out;
wire _guard294 = _guard292 & _guard293;
wire _guard295 = invoke23_done_out;
wire _guard296 = ~_guard295;
wire _guard297 = fsm2_out == 5'd25;
wire _guard298 = _guard296 & _guard297;
wire _guard299 = tdcc_go_out;
wire _guard300 = _guard298 & _guard299;
wire _guard301 = wrapper_early_reset_static_seq3_go_out;
wire _guard302 = wrapper_early_reset_static_seq6_go_out;
wire _guard303 = bb0_7_go_out;
wire _guard304 = std_mulFN_0_done;
wire _guard305 = ~_guard304;
wire _guard306 = bb0_7_go_out;
wire _guard307 = _guard305 & _guard306;
wire _guard308 = bb0_7_go_out;
wire _guard309 = early_reset_static_par_thread1_go_out;
wire _guard310 = early_reset_static_par_thread1_go_out;
wire _guard311 = bb0_16_done_out;
wire _guard312 = ~_guard311;
wire _guard313 = fsm2_out == 5'd24;
wire _guard314 = _guard312 & _guard313;
wire _guard315 = tdcc_go_out;
wire _guard316 = _guard314 & _guard315;
wire _guard317 = incr_repeat_done_out;
wire _guard318 = ~_guard317;
wire _guard319 = fsm2_out == 5'd11;
wire _guard320 = _guard318 & _guard319;
wire _guard321 = tdcc_go_out;
wire _guard322 = _guard320 & _guard321;
wire _guard323 = cond_reg1_done;
wire _guard324 = idx1_done;
wire _guard325 = _guard323 & _guard324;
wire _guard326 = fsm0_out == 3'd0;
wire _guard327 = early_reset_static_seq0_go_out;
wire _guard328 = _guard326 & _guard327;
wire _guard329 = fsm0_out == 3'd0;
wire _guard330 = early_reset_static_seq4_go_out;
wire _guard331 = _guard329 & _guard330;
wire _guard332 = _guard328 | _guard331;
wire _guard333 = fsm0_out == 3'd0;
wire _guard334 = early_reset_static_seq0_go_out;
wire _guard335 = _guard333 & _guard334;
wire _guard336 = fsm0_out == 3'd0;
wire _guard337 = early_reset_static_seq3_go_out;
wire _guard338 = _guard336 & _guard337;
wire _guard339 = _guard335 | _guard338;
wire _guard340 = fsm0_out == 3'd0;
wire _guard341 = early_reset_static_seq4_go_out;
wire _guard342 = _guard340 & _guard341;
wire _guard343 = _guard339 | _guard342;
wire _guard344 = fsm0_out == 3'd0;
wire _guard345 = early_reset_static_seq5_go_out;
wire _guard346 = _guard344 & _guard345;
wire _guard347 = _guard343 | _guard346;
wire _guard348 = fsm0_out == 3'd0;
wire _guard349 = early_reset_static_seq0_go_out;
wire _guard350 = _guard348 & _guard349;
wire _guard351 = fsm0_out == 3'd0;
wire _guard352 = early_reset_static_seq3_go_out;
wire _guard353 = _guard351 & _guard352;
wire _guard354 = _guard350 | _guard353;
wire _guard355 = fsm0_out == 3'd0;
wire _guard356 = early_reset_static_seq4_go_out;
wire _guard357 = _guard355 & _guard356;
wire _guard358 = _guard354 | _guard357;
wire _guard359 = fsm0_out == 3'd0;
wire _guard360 = early_reset_static_seq5_go_out;
wire _guard361 = _guard359 & _guard360;
wire _guard362 = _guard358 | _guard361;
wire _guard363 = fsm0_out == 3'd0;
wire _guard364 = early_reset_static_seq0_go_out;
wire _guard365 = _guard363 & _guard364;
wire _guard366 = fsm0_out == 3'd0;
wire _guard367 = early_reset_static_seq4_go_out;
wire _guard368 = _guard366 & _guard367;
wire _guard369 = bb0_6_go_out;
wire _guard370 = fsm_out == 2'd0;
wire _guard371 = early_reset_static_par_thread_go_out;
wire _guard372 = _guard370 & _guard371;
wire _guard373 = fsm0_out == 3'd1;
wire _guard374 = early_reset_static_seq0_go_out;
wire _guard375 = _guard373 & _guard374;
wire _guard376 = _guard372 | _guard375;
wire _guard377 = fsm0_out == 3'd3;
wire _guard378 = early_reset_static_par_thread1_go_out;
wire _guard379 = _guard377 & _guard378;
wire _guard380 = _guard376 | _guard379;
wire _guard381 = fsm0_out == 3'd1;
wire _guard382 = early_reset_static_seq7_go_out;
wire _guard383 = _guard381 & _guard382;
wire _guard384 = _guard380 | _guard383;
wire _guard385 = bb0_9_go_out;
wire _guard386 = bb0_13_go_out;
wire _guard387 = fsm0_out == 3'd1;
wire _guard388 = early_reset_static_seq0_go_out;
wire _guard389 = _guard387 & _guard388;
wire _guard390 = fsm_out == 2'd0;
wire _guard391 = early_reset_static_par_thread_go_out;
wire _guard392 = _guard390 & _guard391;
wire _guard393 = bb0_9_go_out;
wire _guard394 = fsm0_out == 3'd1;
wire _guard395 = early_reset_static_seq7_go_out;
wire _guard396 = _guard394 & _guard395;
wire _guard397 = bb0_13_go_out;
wire _guard398 = fsm0_out == 3'd3;
wire _guard399 = early_reset_static_par_thread1_go_out;
wire _guard400 = _guard398 & _guard399;
wire _guard401 = invoke15_go_out;
wire _guard402 = fsm0_out == 3'd1;
wire _guard403 = early_reset_static_seq6_go_out;
wire _guard404 = _guard402 & _guard403;
wire _guard405 = _guard401 | _guard404;
wire _guard406 = bb0_7_go_out;
wire _guard407 = fsm0_out == 3'd1;
wire _guard408 = early_reset_static_seq6_go_out;
wire _guard409 = _guard407 & _guard408;
wire _guard410 = invoke15_go_out;
wire _guard411 = bb0_7_go_out;
wire _guard412 = incr_repeat2_go_out;
wire _guard413 = incr_repeat2_go_out;
wire _guard414 = fsm0_out != 3'd1;
wire _guard415 = early_reset_static_seq0_go_out;
wire _guard416 = _guard414 & _guard415;
wire _guard417 = fsm0_out == 3'd1;
wire _guard418 = early_reset_static_seq0_go_out;
wire _guard419 = _guard417 & _guard418;
wire _guard420 = _guard416 | _guard419;
wire _guard421 = fsm0_out != 3'd3;
wire _guard422 = early_reset_static_par_thread1_go_out;
wire _guard423 = _guard421 & _guard422;
wire _guard424 = _guard420 | _guard423;
wire _guard425 = fsm0_out == 3'd3;
wire _guard426 = early_reset_static_par_thread1_go_out;
wire _guard427 = _guard425 & _guard426;
wire _guard428 = _guard424 | _guard427;
wire _guard429 = fsm0_out != 3'd1;
wire _guard430 = early_reset_static_seq3_go_out;
wire _guard431 = _guard429 & _guard430;
wire _guard432 = _guard428 | _guard431;
wire _guard433 = fsm0_out == 3'd1;
wire _guard434 = early_reset_static_seq3_go_out;
wire _guard435 = _guard433 & _guard434;
wire _guard436 = _guard432 | _guard435;
wire _guard437 = fsm0_out != 3'd1;
wire _guard438 = early_reset_static_seq4_go_out;
wire _guard439 = _guard437 & _guard438;
wire _guard440 = _guard436 | _guard439;
wire _guard441 = fsm0_out == 3'd1;
wire _guard442 = early_reset_static_seq4_go_out;
wire _guard443 = _guard441 & _guard442;
wire _guard444 = _guard440 | _guard443;
wire _guard445 = fsm0_out != 3'd1;
wire _guard446 = early_reset_static_seq5_go_out;
wire _guard447 = _guard445 & _guard446;
wire _guard448 = _guard444 | _guard447;
wire _guard449 = fsm0_out == 3'd1;
wire _guard450 = early_reset_static_seq5_go_out;
wire _guard451 = _guard449 & _guard450;
wire _guard452 = _guard448 | _guard451;
wire _guard453 = fsm0_out != 3'd1;
wire _guard454 = early_reset_static_seq6_go_out;
wire _guard455 = _guard453 & _guard454;
wire _guard456 = _guard452 | _guard455;
wire _guard457 = fsm0_out == 3'd1;
wire _guard458 = early_reset_static_seq6_go_out;
wire _guard459 = _guard457 & _guard458;
wire _guard460 = _guard456 | _guard459;
wire _guard461 = fsm0_out != 3'd1;
wire _guard462 = early_reset_static_seq7_go_out;
wire _guard463 = _guard461 & _guard462;
wire _guard464 = _guard460 | _guard463;
wire _guard465 = fsm0_out == 3'd1;
wire _guard466 = early_reset_static_seq7_go_out;
wire _guard467 = _guard465 & _guard466;
wire _guard468 = _guard464 | _guard467;
wire _guard469 = fsm0_out != 3'd1;
wire _guard470 = early_reset_static_seq6_go_out;
wire _guard471 = _guard469 & _guard470;
wire _guard472 = fsm0_out != 3'd1;
wire _guard473 = early_reset_static_seq0_go_out;
wire _guard474 = _guard472 & _guard473;
wire _guard475 = fsm0_out != 3'd3;
wire _guard476 = early_reset_static_par_thread1_go_out;
wire _guard477 = _guard475 & _guard476;
wire _guard478 = fsm0_out != 3'd1;
wire _guard479 = early_reset_static_seq7_go_out;
wire _guard480 = _guard478 & _guard479;
wire _guard481 = fsm0_out != 3'd1;
wire _guard482 = early_reset_static_seq4_go_out;
wire _guard483 = _guard481 & _guard482;
wire _guard484 = fsm0_out == 3'd1;
wire _guard485 = early_reset_static_seq0_go_out;
wire _guard486 = _guard484 & _guard485;
wire _guard487 = fsm0_out == 3'd3;
wire _guard488 = early_reset_static_par_thread1_go_out;
wire _guard489 = _guard487 & _guard488;
wire _guard490 = _guard486 | _guard489;
wire _guard491 = fsm0_out == 3'd1;
wire _guard492 = early_reset_static_seq3_go_out;
wire _guard493 = _guard491 & _guard492;
wire _guard494 = _guard490 | _guard493;
wire _guard495 = fsm0_out == 3'd1;
wire _guard496 = early_reset_static_seq4_go_out;
wire _guard497 = _guard495 & _guard496;
wire _guard498 = _guard494 | _guard497;
wire _guard499 = fsm0_out == 3'd1;
wire _guard500 = early_reset_static_seq5_go_out;
wire _guard501 = _guard499 & _guard500;
wire _guard502 = _guard498 | _guard501;
wire _guard503 = fsm0_out == 3'd1;
wire _guard504 = early_reset_static_seq6_go_out;
wire _guard505 = _guard503 & _guard504;
wire _guard506 = _guard502 | _guard505;
wire _guard507 = fsm0_out == 3'd1;
wire _guard508 = early_reset_static_seq7_go_out;
wire _guard509 = _guard507 & _guard508;
wire _guard510 = _guard506 | _guard509;
wire _guard511 = fsm0_out != 3'd1;
wire _guard512 = early_reset_static_seq3_go_out;
wire _guard513 = _guard511 & _guard512;
wire _guard514 = fsm0_out != 3'd1;
wire _guard515 = early_reset_static_seq5_go_out;
wire _guard516 = _guard514 & _guard515;
wire _guard517 = fsm2_out == 5'd27;
wire _guard518 = fsm2_out == 5'd0;
wire _guard519 = wrapper_early_reset_static_par_thread_done_out;
wire _guard520 = _guard518 & _guard519;
wire _guard521 = tdcc_go_out;
wire _guard522 = _guard520 & _guard521;
wire _guard523 = _guard517 | _guard522;
wire _guard524 = fsm2_out == 5'd1;
wire _guard525 = init_repeat0_done_out;
wire _guard526 = cond_reg0_out;
wire _guard527 = _guard525 & _guard526;
wire _guard528 = _guard524 & _guard527;
wire _guard529 = tdcc_go_out;
wire _guard530 = _guard528 & _guard529;
wire _guard531 = _guard523 | _guard530;
wire _guard532 = fsm2_out == 5'd13;
wire _guard533 = incr_repeat0_done_out;
wire _guard534 = cond_reg0_out;
wire _guard535 = _guard533 & _guard534;
wire _guard536 = _guard532 & _guard535;
wire _guard537 = tdcc_go_out;
wire _guard538 = _guard536 & _guard537;
wire _guard539 = _guard531 | _guard538;
wire _guard540 = fsm2_out == 5'd2;
wire _guard541 = bb0_1_done_out;
wire _guard542 = _guard540 & _guard541;
wire _guard543 = tdcc_go_out;
wire _guard544 = _guard542 & _guard543;
wire _guard545 = _guard539 | _guard544;
wire _guard546 = fsm2_out == 5'd3;
wire _guard547 = wrapper_early_reset_static_par_thread0_done_out;
wire _guard548 = _guard546 & _guard547;
wire _guard549 = tdcc_go_out;
wire _guard550 = _guard548 & _guard549;
wire _guard551 = _guard545 | _guard550;
wire _guard552 = fsm2_out == 5'd4;
wire _guard553 = init_repeat_done_out;
wire _guard554 = cond_reg_out;
wire _guard555 = _guard553 & _guard554;
wire _guard556 = _guard552 & _guard555;
wire _guard557 = tdcc_go_out;
wire _guard558 = _guard556 & _guard557;
wire _guard559 = _guard551 | _guard558;
wire _guard560 = fsm2_out == 5'd11;
wire _guard561 = incr_repeat_done_out;
wire _guard562 = cond_reg_out;
wire _guard563 = _guard561 & _guard562;
wire _guard564 = _guard560 & _guard563;
wire _guard565 = tdcc_go_out;
wire _guard566 = _guard564 & _guard565;
wire _guard567 = _guard559 | _guard566;
wire _guard568 = fsm2_out == 5'd5;
wire _guard569 = wrapper_early_reset_static_par_thread1_done_out;
wire _guard570 = _guard568 & _guard569;
wire _guard571 = tdcc_go_out;
wire _guard572 = _guard570 & _guard571;
wire _guard573 = _guard567 | _guard572;
wire _guard574 = fsm2_out == 5'd6;
wire _guard575 = bb0_6_done_out;
wire _guard576 = _guard574 & _guard575;
wire _guard577 = tdcc_go_out;
wire _guard578 = _guard576 & _guard577;
wire _guard579 = _guard573 | _guard578;
wire _guard580 = fsm2_out == 5'd7;
wire _guard581 = bb0_7_done_out;
wire _guard582 = _guard580 & _guard581;
wire _guard583 = tdcc_go_out;
wire _guard584 = _guard582 & _guard583;
wire _guard585 = _guard579 | _guard584;
wire _guard586 = fsm2_out == 5'd8;
wire _guard587 = wrapper_early_reset_static_seq3_done_out;
wire _guard588 = _guard586 & _guard587;
wire _guard589 = tdcc_go_out;
wire _guard590 = _guard588 & _guard589;
wire _guard591 = _guard585 | _guard590;
wire _guard592 = fsm2_out == 5'd9;
wire _guard593 = bb0_9_done_out;
wire _guard594 = _guard592 & _guard593;
wire _guard595 = tdcc_go_out;
wire _guard596 = _guard594 & _guard595;
wire _guard597 = _guard591 | _guard596;
wire _guard598 = fsm2_out == 5'd10;
wire _guard599 = wrapper_early_reset_static_seq4_done_out;
wire _guard600 = _guard598 & _guard599;
wire _guard601 = tdcc_go_out;
wire _guard602 = _guard600 & _guard601;
wire _guard603 = _guard597 | _guard602;
wire _guard604 = fsm2_out == 5'd4;
wire _guard605 = init_repeat_done_out;
wire _guard606 = cond_reg_out;
wire _guard607 = ~_guard606;
wire _guard608 = _guard605 & _guard607;
wire _guard609 = _guard604 & _guard608;
wire _guard610 = tdcc_go_out;
wire _guard611 = _guard609 & _guard610;
wire _guard612 = _guard603 | _guard611;
wire _guard613 = fsm2_out == 5'd11;
wire _guard614 = incr_repeat_done_out;
wire _guard615 = cond_reg_out;
wire _guard616 = ~_guard615;
wire _guard617 = _guard614 & _guard616;
wire _guard618 = _guard613 & _guard617;
wire _guard619 = tdcc_go_out;
wire _guard620 = _guard618 & _guard619;
wire _guard621 = _guard612 | _guard620;
wire _guard622 = fsm2_out == 5'd12;
wire _guard623 = invoke14_done_out;
wire _guard624 = _guard622 & _guard623;
wire _guard625 = tdcc_go_out;
wire _guard626 = _guard624 & _guard625;
wire _guard627 = _guard621 | _guard626;
wire _guard628 = fsm2_out == 5'd1;
wire _guard629 = init_repeat0_done_out;
wire _guard630 = cond_reg0_out;
wire _guard631 = ~_guard630;
wire _guard632 = _guard629 & _guard631;
wire _guard633 = _guard628 & _guard632;
wire _guard634 = tdcc_go_out;
wire _guard635 = _guard633 & _guard634;
wire _guard636 = _guard627 | _guard635;
wire _guard637 = fsm2_out == 5'd13;
wire _guard638 = incr_repeat0_done_out;
wire _guard639 = cond_reg0_out;
wire _guard640 = ~_guard639;
wire _guard641 = _guard638 & _guard640;
wire _guard642 = _guard637 & _guard641;
wire _guard643 = tdcc_go_out;
wire _guard644 = _guard642 & _guard643;
wire _guard645 = _guard636 | _guard644;
wire _guard646 = fsm2_out == 5'd14;
wire _guard647 = invoke15_done_out;
wire _guard648 = _guard646 & _guard647;
wire _guard649 = tdcc_go_out;
wire _guard650 = _guard648 & _guard649;
wire _guard651 = _guard645 | _guard650;
wire _guard652 = fsm2_out == 5'd15;
wire _guard653 = init_repeat1_done_out;
wire _guard654 = cond_reg1_out;
wire _guard655 = _guard653 & _guard654;
wire _guard656 = _guard652 & _guard655;
wire _guard657 = tdcc_go_out;
wire _guard658 = _guard656 & _guard657;
wire _guard659 = _guard651 | _guard658;
wire _guard660 = fsm2_out == 5'd20;
wire _guard661 = incr_repeat1_done_out;
wire _guard662 = cond_reg1_out;
wire _guard663 = _guard661 & _guard662;
wire _guard664 = _guard660 & _guard663;
wire _guard665 = tdcc_go_out;
wire _guard666 = _guard664 & _guard665;
wire _guard667 = _guard659 | _guard666;
wire _guard668 = fsm2_out == 5'd16;
wire _guard669 = wrapper_early_reset_static_seq5_done_out;
wire _guard670 = _guard668 & _guard669;
wire _guard671 = tdcc_go_out;
wire _guard672 = _guard670 & _guard671;
wire _guard673 = _guard667 | _guard672;
wire _guard674 = fsm2_out == 5'd17;
wire _guard675 = bb0_12_done_out;
wire _guard676 = _guard674 & _guard675;
wire _guard677 = tdcc_go_out;
wire _guard678 = _guard676 & _guard677;
wire _guard679 = _guard673 | _guard678;
wire _guard680 = fsm2_out == 5'd18;
wire _guard681 = bb0_13_done_out;
wire _guard682 = _guard680 & _guard681;
wire _guard683 = tdcc_go_out;
wire _guard684 = _guard682 & _guard683;
wire _guard685 = _guard679 | _guard684;
wire _guard686 = fsm2_out == 5'd19;
wire _guard687 = wrapper_early_reset_static_seq6_done_out;
wire _guard688 = _guard686 & _guard687;
wire _guard689 = tdcc_go_out;
wire _guard690 = _guard688 & _guard689;
wire _guard691 = _guard685 | _guard690;
wire _guard692 = fsm2_out == 5'd15;
wire _guard693 = init_repeat1_done_out;
wire _guard694 = cond_reg1_out;
wire _guard695 = ~_guard694;
wire _guard696 = _guard693 & _guard695;
wire _guard697 = _guard692 & _guard696;
wire _guard698 = tdcc_go_out;
wire _guard699 = _guard697 & _guard698;
wire _guard700 = _guard691 | _guard699;
wire _guard701 = fsm2_out == 5'd20;
wire _guard702 = incr_repeat1_done_out;
wire _guard703 = cond_reg1_out;
wire _guard704 = ~_guard703;
wire _guard705 = _guard702 & _guard704;
wire _guard706 = _guard701 & _guard705;
wire _guard707 = tdcc_go_out;
wire _guard708 = _guard706 & _guard707;
wire _guard709 = _guard700 | _guard708;
wire _guard710 = fsm2_out == 5'd21;
wire _guard711 = invoke20_done_out;
wire _guard712 = _guard710 & _guard711;
wire _guard713 = tdcc_go_out;
wire _guard714 = _guard712 & _guard713;
wire _guard715 = _guard709 | _guard714;
wire _guard716 = fsm2_out == 5'd22;
wire _guard717 = init_repeat2_done_out;
wire _guard718 = cond_reg2_out;
wire _guard719 = _guard717 & _guard718;
wire _guard720 = _guard716 & _guard719;
wire _guard721 = tdcc_go_out;
wire _guard722 = _guard720 & _guard721;
wire _guard723 = _guard715 | _guard722;
wire _guard724 = fsm2_out == 5'd26;
wire _guard725 = incr_repeat2_done_out;
wire _guard726 = cond_reg2_out;
wire _guard727 = _guard725 & _guard726;
wire _guard728 = _guard724 & _guard727;
wire _guard729 = tdcc_go_out;
wire _guard730 = _guard728 & _guard729;
wire _guard731 = _guard723 | _guard730;
wire _guard732 = fsm2_out == 5'd23;
wire _guard733 = wrapper_early_reset_static_seq7_done_out;
wire _guard734 = _guard732 & _guard733;
wire _guard735 = tdcc_go_out;
wire _guard736 = _guard734 & _guard735;
wire _guard737 = _guard731 | _guard736;
wire _guard738 = fsm2_out == 5'd24;
wire _guard739 = bb0_16_done_out;
wire _guard740 = _guard738 & _guard739;
wire _guard741 = tdcc_go_out;
wire _guard742 = _guard740 & _guard741;
wire _guard743 = _guard737 | _guard742;
wire _guard744 = fsm2_out == 5'd25;
wire _guard745 = invoke23_done_out;
wire _guard746 = _guard744 & _guard745;
wire _guard747 = tdcc_go_out;
wire _guard748 = _guard746 & _guard747;
wire _guard749 = _guard743 | _guard748;
wire _guard750 = fsm2_out == 5'd22;
wire _guard751 = init_repeat2_done_out;
wire _guard752 = cond_reg2_out;
wire _guard753 = ~_guard752;
wire _guard754 = _guard751 & _guard753;
wire _guard755 = _guard750 & _guard754;
wire _guard756 = tdcc_go_out;
wire _guard757 = _guard755 & _guard756;
wire _guard758 = _guard749 | _guard757;
wire _guard759 = fsm2_out == 5'd26;
wire _guard760 = incr_repeat2_done_out;
wire _guard761 = cond_reg2_out;
wire _guard762 = ~_guard761;
wire _guard763 = _guard760 & _guard762;
wire _guard764 = _guard759 & _guard763;
wire _guard765 = tdcc_go_out;
wire _guard766 = _guard764 & _guard765;
wire _guard767 = _guard758 | _guard766;
wire _guard768 = fsm2_out == 5'd0;
wire _guard769 = wrapper_early_reset_static_par_thread_done_out;
wire _guard770 = _guard768 & _guard769;
wire _guard771 = tdcc_go_out;
wire _guard772 = _guard770 & _guard771;
wire _guard773 = fsm2_out == 5'd14;
wire _guard774 = invoke15_done_out;
wire _guard775 = _guard773 & _guard774;
wire _guard776 = tdcc_go_out;
wire _guard777 = _guard775 & _guard776;
wire _guard778 = fsm2_out == 5'd22;
wire _guard779 = init_repeat2_done_out;
wire _guard780 = cond_reg2_out;
wire _guard781 = _guard779 & _guard780;
wire _guard782 = _guard778 & _guard781;
wire _guard783 = tdcc_go_out;
wire _guard784 = _guard782 & _guard783;
wire _guard785 = fsm2_out == 5'd26;
wire _guard786 = incr_repeat2_done_out;
wire _guard787 = cond_reg2_out;
wire _guard788 = _guard786 & _guard787;
wire _guard789 = _guard785 & _guard788;
wire _guard790 = tdcc_go_out;
wire _guard791 = _guard789 & _guard790;
wire _guard792 = _guard784 | _guard791;
wire _guard793 = fsm2_out == 5'd17;
wire _guard794 = bb0_12_done_out;
wire _guard795 = _guard793 & _guard794;
wire _guard796 = tdcc_go_out;
wire _guard797 = _guard795 & _guard796;
wire _guard798 = fsm2_out == 5'd23;
wire _guard799 = wrapper_early_reset_static_seq7_done_out;
wire _guard800 = _guard798 & _guard799;
wire _guard801 = tdcc_go_out;
wire _guard802 = _guard800 & _guard801;
wire _guard803 = fsm2_out == 5'd15;
wire _guard804 = init_repeat1_done_out;
wire _guard805 = cond_reg1_out;
wire _guard806 = _guard804 & _guard805;
wire _guard807 = _guard803 & _guard806;
wire _guard808 = tdcc_go_out;
wire _guard809 = _guard807 & _guard808;
wire _guard810 = fsm2_out == 5'd20;
wire _guard811 = incr_repeat1_done_out;
wire _guard812 = cond_reg1_out;
wire _guard813 = _guard811 & _guard812;
wire _guard814 = _guard810 & _guard813;
wire _guard815 = tdcc_go_out;
wire _guard816 = _guard814 & _guard815;
wire _guard817 = _guard809 | _guard816;
wire _guard818 = fsm2_out == 5'd25;
wire _guard819 = invoke23_done_out;
wire _guard820 = _guard818 & _guard819;
wire _guard821 = tdcc_go_out;
wire _guard822 = _guard820 & _guard821;
wire _guard823 = fsm2_out == 5'd27;
wire _guard824 = fsm2_out == 5'd2;
wire _guard825 = bb0_1_done_out;
wire _guard826 = _guard824 & _guard825;
wire _guard827 = tdcc_go_out;
wire _guard828 = _guard826 & _guard827;
wire _guard829 = fsm2_out == 5'd12;
wire _guard830 = invoke14_done_out;
wire _guard831 = _guard829 & _guard830;
wire _guard832 = tdcc_go_out;
wire _guard833 = _guard831 & _guard832;
wire _guard834 = fsm2_out == 5'd1;
wire _guard835 = init_repeat0_done_out;
wire _guard836 = cond_reg0_out;
wire _guard837 = ~_guard836;
wire _guard838 = _guard835 & _guard837;
wire _guard839 = _guard834 & _guard838;
wire _guard840 = tdcc_go_out;
wire _guard841 = _guard839 & _guard840;
wire _guard842 = fsm2_out == 5'd13;
wire _guard843 = incr_repeat0_done_out;
wire _guard844 = cond_reg0_out;
wire _guard845 = ~_guard844;
wire _guard846 = _guard843 & _guard845;
wire _guard847 = _guard842 & _guard846;
wire _guard848 = tdcc_go_out;
wire _guard849 = _guard847 & _guard848;
wire _guard850 = _guard841 | _guard849;
wire _guard851 = fsm2_out == 5'd4;
wire _guard852 = init_repeat_done_out;
wire _guard853 = cond_reg_out;
wire _guard854 = _guard852 & _guard853;
wire _guard855 = _guard851 & _guard854;
wire _guard856 = tdcc_go_out;
wire _guard857 = _guard855 & _guard856;
wire _guard858 = fsm2_out == 5'd11;
wire _guard859 = incr_repeat_done_out;
wire _guard860 = cond_reg_out;
wire _guard861 = _guard859 & _guard860;
wire _guard862 = _guard858 & _guard861;
wire _guard863 = tdcc_go_out;
wire _guard864 = _guard862 & _guard863;
wire _guard865 = _guard857 | _guard864;
wire _guard866 = fsm2_out == 5'd4;
wire _guard867 = init_repeat_done_out;
wire _guard868 = cond_reg_out;
wire _guard869 = ~_guard868;
wire _guard870 = _guard867 & _guard869;
wire _guard871 = _guard866 & _guard870;
wire _guard872 = tdcc_go_out;
wire _guard873 = _guard871 & _guard872;
wire _guard874 = fsm2_out == 5'd11;
wire _guard875 = incr_repeat_done_out;
wire _guard876 = cond_reg_out;
wire _guard877 = ~_guard876;
wire _guard878 = _guard875 & _guard877;
wire _guard879 = _guard874 & _guard878;
wire _guard880 = tdcc_go_out;
wire _guard881 = _guard879 & _guard880;
wire _guard882 = _guard873 | _guard881;
wire _guard883 = fsm2_out == 5'd1;
wire _guard884 = init_repeat0_done_out;
wire _guard885 = cond_reg0_out;
wire _guard886 = _guard884 & _guard885;
wire _guard887 = _guard883 & _guard886;
wire _guard888 = tdcc_go_out;
wire _guard889 = _guard887 & _guard888;
wire _guard890 = fsm2_out == 5'd13;
wire _guard891 = incr_repeat0_done_out;
wire _guard892 = cond_reg0_out;
wire _guard893 = _guard891 & _guard892;
wire _guard894 = _guard890 & _guard893;
wire _guard895 = tdcc_go_out;
wire _guard896 = _guard894 & _guard895;
wire _guard897 = _guard889 | _guard896;
wire _guard898 = fsm2_out == 5'd7;
wire _guard899 = bb0_7_done_out;
wire _guard900 = _guard898 & _guard899;
wire _guard901 = tdcc_go_out;
wire _guard902 = _guard900 & _guard901;
wire _guard903 = fsm2_out == 5'd9;
wire _guard904 = bb0_9_done_out;
wire _guard905 = _guard903 & _guard904;
wire _guard906 = tdcc_go_out;
wire _guard907 = _guard905 & _guard906;
wire _guard908 = fsm2_out == 5'd6;
wire _guard909 = bb0_6_done_out;
wire _guard910 = _guard908 & _guard909;
wire _guard911 = tdcc_go_out;
wire _guard912 = _guard910 & _guard911;
wire _guard913 = fsm2_out == 5'd10;
wire _guard914 = wrapper_early_reset_static_seq4_done_out;
wire _guard915 = _guard913 & _guard914;
wire _guard916 = tdcc_go_out;
wire _guard917 = _guard915 & _guard916;
wire _guard918 = fsm2_out == 5'd15;
wire _guard919 = init_repeat1_done_out;
wire _guard920 = cond_reg1_out;
wire _guard921 = ~_guard920;
wire _guard922 = _guard919 & _guard921;
wire _guard923 = _guard918 & _guard922;
wire _guard924 = tdcc_go_out;
wire _guard925 = _guard923 & _guard924;
wire _guard926 = fsm2_out == 5'd20;
wire _guard927 = incr_repeat1_done_out;
wire _guard928 = cond_reg1_out;
wire _guard929 = ~_guard928;
wire _guard930 = _guard927 & _guard929;
wire _guard931 = _guard926 & _guard930;
wire _guard932 = tdcc_go_out;
wire _guard933 = _guard931 & _guard932;
wire _guard934 = _guard925 | _guard933;
wire _guard935 = fsm2_out == 5'd22;
wire _guard936 = init_repeat2_done_out;
wire _guard937 = cond_reg2_out;
wire _guard938 = ~_guard937;
wire _guard939 = _guard936 & _guard938;
wire _guard940 = _guard935 & _guard939;
wire _guard941 = tdcc_go_out;
wire _guard942 = _guard940 & _guard941;
wire _guard943 = fsm2_out == 5'd26;
wire _guard944 = incr_repeat2_done_out;
wire _guard945 = cond_reg2_out;
wire _guard946 = ~_guard945;
wire _guard947 = _guard944 & _guard946;
wire _guard948 = _guard943 & _guard947;
wire _guard949 = tdcc_go_out;
wire _guard950 = _guard948 & _guard949;
wire _guard951 = _guard942 | _guard950;
wire _guard952 = fsm2_out == 5'd18;
wire _guard953 = bb0_13_done_out;
wire _guard954 = _guard952 & _guard953;
wire _guard955 = tdcc_go_out;
wire _guard956 = _guard954 & _guard955;
wire _guard957 = fsm2_out == 5'd21;
wire _guard958 = invoke20_done_out;
wire _guard959 = _guard957 & _guard958;
wire _guard960 = tdcc_go_out;
wire _guard961 = _guard959 & _guard960;
wire _guard962 = fsm2_out == 5'd24;
wire _guard963 = bb0_16_done_out;
wire _guard964 = _guard962 & _guard963;
wire _guard965 = tdcc_go_out;
wire _guard966 = _guard964 & _guard965;
wire _guard967 = fsm2_out == 5'd3;
wire _guard968 = wrapper_early_reset_static_par_thread0_done_out;
wire _guard969 = _guard967 & _guard968;
wire _guard970 = tdcc_go_out;
wire _guard971 = _guard969 & _guard970;
wire _guard972 = fsm2_out == 5'd5;
wire _guard973 = wrapper_early_reset_static_par_thread1_done_out;
wire _guard974 = _guard972 & _guard973;
wire _guard975 = tdcc_go_out;
wire _guard976 = _guard974 & _guard975;
wire _guard977 = fsm2_out == 5'd19;
wire _guard978 = wrapper_early_reset_static_seq6_done_out;
wire _guard979 = _guard977 & _guard978;
wire _guard980 = tdcc_go_out;
wire _guard981 = _guard979 & _guard980;
wire _guard982 = fsm2_out == 5'd16;
wire _guard983 = wrapper_early_reset_static_seq5_done_out;
wire _guard984 = _guard982 & _guard983;
wire _guard985 = tdcc_go_out;
wire _guard986 = _guard984 & _guard985;
wire _guard987 = fsm2_out == 5'd8;
wire _guard988 = wrapper_early_reset_static_seq3_done_out;
wire _guard989 = _guard987 & _guard988;
wire _guard990 = tdcc_go_out;
wire _guard991 = _guard989 & _guard990;
wire _guard992 = cond_reg0_done;
wire _guard993 = idx0_done;
wire _guard994 = _guard992 & _guard993;
wire _guard995 = incr_repeat2_done_out;
wire _guard996 = ~_guard995;
wire _guard997 = fsm2_out == 5'd26;
wire _guard998 = _guard996 & _guard997;
wire _guard999 = tdcc_go_out;
wire _guard1000 = _guard998 & _guard999;
wire _guard1001 = signal_reg0_out;
wire _guard1002 = bb0_9_go_out;
wire _guard1003 = bb0_9_go_out;
wire _guard1004 = std_addFN_0_done;
wire _guard1005 = ~_guard1004;
wire _guard1006 = bb0_9_go_out;
wire _guard1007 = _guard1005 & _guard1006;
wire _guard1008 = bb0_9_go_out;
wire _guard1009 = init_repeat_go_out;
wire _guard1010 = incr_repeat_go_out;
wire _guard1011 = _guard1009 | _guard1010;
wire _guard1012 = incr_repeat_go_out;
wire _guard1013 = init_repeat_go_out;
wire _guard1014 = early_reset_static_par_thread_go_out;
wire _guard1015 = early_reset_static_par_thread_go_out;
wire _guard1016 = early_reset_static_seq0_go_out;
wire _guard1017 = early_reset_static_seq0_go_out;
wire _guard1018 = cond_reg_done;
wire _guard1019 = idx_done;
wire _guard1020 = _guard1018 & _guard1019;
wire _guard1021 = cond_reg_done;
wire _guard1022 = idx_done;
wire _guard1023 = _guard1021 & _guard1022;
wire _guard1024 = cond_reg0_done;
wire _guard1025 = idx0_done;
wire _guard1026 = _guard1024 & _guard1025;
wire _guard1027 = wrapper_early_reset_static_seq3_done_out;
wire _guard1028 = ~_guard1027;
wire _guard1029 = fsm2_out == 5'd8;
wire _guard1030 = _guard1028 & _guard1029;
wire _guard1031 = tdcc_go_out;
wire _guard1032 = _guard1030 & _guard1031;
wire _guard1033 = incr_repeat0_go_out;
wire _guard1034 = incr_repeat0_go_out;
wire _guard1035 = early_reset_static_seq7_go_out;
wire _guard1036 = early_reset_static_seq7_go_out;
wire _guard1037 = init_repeat0_done_out;
wire _guard1038 = ~_guard1037;
wire _guard1039 = fsm2_out == 5'd1;
wire _guard1040 = _guard1038 & _guard1039;
wire _guard1041 = tdcc_go_out;
wire _guard1042 = _guard1040 & _guard1041;
wire _guard1043 = incr_repeat0_done_out;
wire _guard1044 = ~_guard1043;
wire _guard1045 = fsm2_out == 5'd13;
wire _guard1046 = _guard1044 & _guard1045;
wire _guard1047 = tdcc_go_out;
wire _guard1048 = _guard1046 & _guard1047;
wire _guard1049 = init_repeat2_done_out;
wire _guard1050 = ~_guard1049;
wire _guard1051 = fsm2_out == 5'd22;
wire _guard1052 = _guard1050 & _guard1051;
wire _guard1053 = tdcc_go_out;
wire _guard1054 = _guard1052 & _guard1053;
wire _guard1055 = wrapper_early_reset_static_par_thread0_done_out;
wire _guard1056 = ~_guard1055;
wire _guard1057 = fsm2_out == 5'd3;
wire _guard1058 = _guard1056 & _guard1057;
wire _guard1059 = tdcc_go_out;
wire _guard1060 = _guard1058 & _guard1059;
wire _guard1061 = fsm0_out == 3'd0;
wire _guard1062 = early_reset_static_seq6_go_out;
wire _guard1063 = _guard1061 & _guard1062;
wire _guard1064 = fsm0_out == 3'd0;
wire _guard1065 = early_reset_static_seq6_go_out;
wire _guard1066 = _guard1064 & _guard1065;
wire _guard1067 = fsm0_out == 3'd0;
wire _guard1068 = early_reset_static_seq7_go_out;
wire _guard1069 = _guard1067 & _guard1068;
wire _guard1070 = _guard1066 | _guard1069;
wire _guard1071 = fsm0_out == 3'd0;
wire _guard1072 = early_reset_static_seq6_go_out;
wire _guard1073 = _guard1071 & _guard1072;
wire _guard1074 = fsm0_out == 3'd0;
wire _guard1075 = early_reset_static_seq7_go_out;
wire _guard1076 = _guard1074 & _guard1075;
wire _guard1077 = _guard1073 | _guard1076;
wire _guard1078 = fsm0_out == 3'd0;
wire _guard1079 = early_reset_static_seq6_go_out;
wire _guard1080 = _guard1078 & _guard1079;
wire _guard1081 = bb0_13_go_out;
wire _guard1082 = bb0_13_go_out;
wire _guard1083 = std_addFN_1_done;
wire _guard1084 = ~_guard1083;
wire _guard1085 = bb0_13_go_out;
wire _guard1086 = _guard1084 & _guard1085;
wire _guard1087 = bb0_13_go_out;
wire _guard1088 = fsm0_out < 3'd3;
wire _guard1089 = early_reset_static_par_thread1_go_out;
wire _guard1090 = _guard1088 & _guard1089;
wire _guard1091 = fsm0_out < 3'd3;
wire _guard1092 = early_reset_static_par_thread1_go_out;
wire _guard1093 = _guard1091 & _guard1092;
wire _guard1094 = fsm0_out < 3'd3;
wire _guard1095 = early_reset_static_par_thread1_go_out;
wire _guard1096 = _guard1094 & _guard1095;
wire _guard1097 = early_reset_static_seq4_go_out;
wire _guard1098 = early_reset_static_seq4_go_out;
wire _guard1099 = signal_reg_out;
wire _guard1100 = fsm_out == 2'd1;
wire _guard1101 = fsm0_out == 3'd1;
wire _guard1102 = fsm1_out == 4'd9;
wire _guard1103 = _guard1101 & _guard1102;
wire _guard1104 = _guard1100 & _guard1103;
wire _guard1105 = _guard1104 & _guard0;
wire _guard1106 = signal_reg_out;
wire _guard1107 = ~_guard1106;
wire _guard1108 = _guard1105 & _guard1107;
wire _guard1109 = wrapper_early_reset_static_par_thread_go_out;
wire _guard1110 = _guard1108 & _guard1109;
wire _guard1111 = _guard1099 | _guard1110;
wire _guard1112 = fsm_out == 2'd1;
wire _guard1113 = fsm0_out == 3'd1;
wire _guard1114 = fsm1_out == 4'd9;
wire _guard1115 = _guard1113 & _guard1114;
wire _guard1116 = _guard1112 & _guard1115;
wire _guard1117 = _guard1116 & _guard0;
wire _guard1118 = signal_reg_out;
wire _guard1119 = ~_guard1118;
wire _guard1120 = _guard1117 & _guard1119;
wire _guard1121 = wrapper_early_reset_static_par_thread_go_out;
wire _guard1122 = _guard1120 & _guard1121;
wire _guard1123 = signal_reg_out;
wire _guard1124 = cond_reg1_done;
wire _guard1125 = idx1_done;
wire _guard1126 = _guard1124 & _guard1125;
wire _guard1127 = cond_reg2_done;
wire _guard1128 = idx2_done;
wire _guard1129 = _guard1127 & _guard1128;
wire _guard1130 = wrapper_early_reset_static_par_thread_go_out;
wire _guard1131 = signal_reg0_out;
wire _guard1132 = wrapper_early_reset_static_par_thread1_done_out;
wire _guard1133 = ~_guard1132;
wire _guard1134 = fsm2_out == 5'd5;
wire _guard1135 = _guard1133 & _guard1134;
wire _guard1136 = tdcc_go_out;
wire _guard1137 = _guard1135 & _guard1136;
wire _guard1138 = invoke14_go_out;
wire _guard1139 = fsm_out == 2'd0;
wire _guard1140 = early_reset_static_par_thread_go_out;
wire _guard1141 = _guard1139 & _guard1140;
wire _guard1142 = _guard1138 | _guard1141;
wire _guard1143 = invoke14_go_out;
wire _guard1144 = fsm_out == 2'd0;
wire _guard1145 = early_reset_static_par_thread_go_out;
wire _guard1146 = _guard1144 & _guard1145;
wire _guard1147 = wrapper_early_reset_static_par_thread0_go_out;
wire _guard1148 = signal_reg_out;
wire _guard1149 = signal_reg0_out;
wire _guard1150 = invoke20_done_out;
wire _guard1151 = ~_guard1150;
wire _guard1152 = fsm2_out == 5'd21;
wire _guard1153 = _guard1151 & _guard1152;
wire _guard1154 = tdcc_go_out;
wire _guard1155 = _guard1153 & _guard1154;
wire _guard1156 = fsm2_out == 5'd27;
wire _guard1157 = early_reset_static_par_thread0_go_out;
wire _guard1158 = fsm0_out == 3'd1;
wire _guard1159 = early_reset_static_seq4_go_out;
wire _guard1160 = _guard1158 & _guard1159;
wire _guard1161 = _guard1157 | _guard1160;
wire _guard1162 = fsm0_out == 3'd1;
wire _guard1163 = early_reset_static_seq4_go_out;
wire _guard1164 = _guard1162 & _guard1163;
wire _guard1165 = early_reset_static_par_thread0_go_out;
wire _guard1166 = incr_repeat_go_out;
wire _guard1167 = incr_repeat_go_out;
wire _guard1168 = init_repeat2_go_out;
wire _guard1169 = incr_repeat2_go_out;
wire _guard1170 = _guard1168 | _guard1169;
wire _guard1171 = init_repeat2_go_out;
wire _guard1172 = incr_repeat2_go_out;
wire _guard1173 = bb0_7_done_out;
wire _guard1174 = ~_guard1173;
wire _guard1175 = fsm2_out == 5'd7;
wire _guard1176 = _guard1174 & _guard1175;
wire _guard1177 = tdcc_go_out;
wire _guard1178 = _guard1176 & _guard1177;
wire _guard1179 = invoke15_done_out;
wire _guard1180 = ~_guard1179;
wire _guard1181 = fsm2_out == 5'd14;
wire _guard1182 = _guard1180 & _guard1181;
wire _guard1183 = tdcc_go_out;
wire _guard1184 = _guard1182 & _guard1183;
wire _guard1185 = signal_reg0_out;
wire _guard1186 = signal_reg0_out;
wire _guard1187 = wrapper_early_reset_static_seq6_done_out;
wire _guard1188 = ~_guard1187;
wire _guard1189 = fsm2_out == 5'd19;
wire _guard1190 = _guard1188 & _guard1189;
wire _guard1191 = tdcc_go_out;
wire _guard1192 = _guard1190 & _guard1191;
wire _guard1193 = fsm0_out == 3'd0;
wire _guard1194 = early_reset_static_seq0_go_out;
wire _guard1195 = _guard1193 & _guard1194;
wire _guard1196 = bb0_12_go_out;
wire _guard1197 = fsm0_out == 3'd0;
wire _guard1198 = early_reset_static_seq5_go_out;
wire _guard1199 = _guard1197 & _guard1198;
wire _guard1200 = _guard1196 | _guard1199;
wire _guard1201 = fsm0_out == 3'd0;
wire _guard1202 = early_reset_static_seq6_go_out;
wire _guard1203 = _guard1201 & _guard1202;
wire _guard1204 = _guard1200 | _guard1203;
wire _guard1205 = fsm0_out == 3'd0;
wire _guard1206 = early_reset_static_seq3_go_out;
wire _guard1207 = _guard1205 & _guard1206;
wire _guard1208 = fsm0_out == 3'd0;
wire _guard1209 = early_reset_static_seq4_go_out;
wire _guard1210 = _guard1208 & _guard1209;
wire _guard1211 = _guard1207 | _guard1210;
wire _guard1212 = bb0_16_go_out;
wire _guard1213 = fsm0_out == 3'd0;
wire _guard1214 = early_reset_static_seq7_go_out;
wire _guard1215 = _guard1213 & _guard1214;
wire _guard1216 = _guard1212 | _guard1215;
wire _guard1217 = bb0_1_done_out;
wire _guard1218 = ~_guard1217;
wire _guard1219 = fsm2_out == 5'd2;
wire _guard1220 = _guard1218 & _guard1219;
wire _guard1221 = tdcc_go_out;
wire _guard1222 = _guard1220 & _guard1221;
wire _guard1223 = wrapper_early_reset_static_seq4_done_out;
wire _guard1224 = ~_guard1223;
wire _guard1225 = fsm2_out == 5'd10;
wire _guard1226 = _guard1224 & _guard1225;
wire _guard1227 = tdcc_go_out;
wire _guard1228 = _guard1226 & _guard1227;
wire _guard1229 = early_reset_static_par_thread0_go_out;
wire _guard1230 = fsm0_out == 3'd0;
wire _guard1231 = early_reset_static_par_thread1_go_out;
wire _guard1232 = _guard1230 & _guard1231;
wire _guard1233 = _guard1229 | _guard1232;
wire _guard1234 = invoke20_go_out;
wire _guard1235 = invoke23_go_out;
wire _guard1236 = _guard1234 | _guard1235;
wire _guard1237 = fsm0_out == 3'd1;
wire _guard1238 = early_reset_static_par_thread1_go_out;
wire _guard1239 = _guard1237 & _guard1238;
wire _guard1240 = _guard1236 | _guard1239;
wire _guard1241 = fsm0_out == 3'd1;
wire _guard1242 = early_reset_static_seq3_go_out;
wire _guard1243 = _guard1241 & _guard1242;
wire _guard1244 = _guard1240 | _guard1243;
wire _guard1245 = fsm0_out == 3'd1;
wire _guard1246 = early_reset_static_seq5_go_out;
wire _guard1247 = _guard1245 & _guard1246;
wire _guard1248 = _guard1244 | _guard1247;
wire _guard1249 = invoke23_go_out;
wire _guard1250 = invoke20_go_out;
wire _guard1251 = fsm0_out == 3'd1;
wire _guard1252 = early_reset_static_par_thread1_go_out;
wire _guard1253 = _guard1251 & _guard1252;
wire _guard1254 = fsm0_out == 3'd1;
wire _guard1255 = early_reset_static_seq3_go_out;
wire _guard1256 = _guard1254 & _guard1255;
wire _guard1257 = fsm0_out == 3'd1;
wire _guard1258 = early_reset_static_seq5_go_out;
wire _guard1259 = _guard1257 & _guard1258;
wire _guard1260 = _guard1256 | _guard1259;
wire _guard1261 = init_repeat_go_out;
wire _guard1262 = incr_repeat_go_out;
wire _guard1263 = _guard1261 | _guard1262;
wire _guard1264 = init_repeat_go_out;
wire _guard1265 = incr_repeat_go_out;
wire _guard1266 = incr_repeat0_go_out;
wire _guard1267 = incr_repeat0_go_out;
wire _guard1268 = init_repeat2_go_out;
wire _guard1269 = incr_repeat2_go_out;
wire _guard1270 = _guard1268 | _guard1269;
wire _guard1271 = init_repeat2_go_out;
wire _guard1272 = incr_repeat2_go_out;
wire _guard1273 = early_reset_static_seq3_go_out;
wire _guard1274 = early_reset_static_seq3_go_out;
wire _guard1275 = early_reset_static_seq5_go_out;
wire _guard1276 = early_reset_static_seq5_go_out;
wire _guard1277 = bb0_12_done_out;
wire _guard1278 = ~_guard1277;
wire _guard1279 = fsm2_out == 5'd17;
wire _guard1280 = _guard1278 & _guard1279;
wire _guard1281 = tdcc_go_out;
wire _guard1282 = _guard1280 & _guard1281;
wire _guard1283 = bb0_13_done_out;
wire _guard1284 = ~_guard1283;
wire _guard1285 = fsm2_out == 5'd18;
wire _guard1286 = _guard1284 & _guard1285;
wire _guard1287 = tdcc_go_out;
wire _guard1288 = _guard1286 & _guard1287;
wire _guard1289 = invoke14_done_out;
wire _guard1290 = ~_guard1289;
wire _guard1291 = fsm2_out == 5'd12;
wire _guard1292 = _guard1290 & _guard1291;
wire _guard1293 = tdcc_go_out;
wire _guard1294 = _guard1292 & _guard1293;
wire _guard1295 = cond_reg2_done;
wire _guard1296 = idx2_done;
wire _guard1297 = _guard1295 & _guard1296;
wire _guard1298 = signal_reg0_out;
assign std_slice_10_in = for_2_induction_var_reg_out;
assign std_add_5_left =
  _guard6 ? addf_0_reg_out :
  _guard9 ? mulf_0_reg_out :
  _guard10 ? for_2_induction_var_reg_out :
  _guard13 ? for_1_induction_var_reg_out :
  _guard14 ? load_1_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard14, _guard13, _guard10, _guard9, _guard6})) begin
    $fatal(2, "Multiple assignment to port `std_add_5.left'.");
end
end
assign std_add_5_right =
  _guard29 ? 32'd1 :
  _guard30 ? for_2_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard30, _guard29})) begin
    $fatal(2, "Multiple assignment to port `std_add_5.right'.");
end
end
assign cond_reg1_write_en = _guard33;
assign cond_reg1_clk = clk;
assign cond_reg1_reset = reset;
assign cond_reg1_in =
  _guard34 ? 1'd1 :
  _guard35 ? lt1_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard35, _guard34})) begin
    $fatal(2, "Multiple assignment to port `cond_reg1.in'.");
end
end
assign adder1_left =
  _guard36 ? idx1_out :
  4'd0;
assign adder1_right =
  _guard37 ? 4'd1 :
  4'd0;
assign bb0_6_go_in = _guard43;
assign init_repeat_go_in = _guard49;
assign early_reset_static_seq7_done_in = ud7_out;
assign done = _guard50;
assign arg_mem_3_addr0 = std_slice_11_out;
assign arg_mem_3_write_data = addf_0_reg_out;
assign arg_mem_0_content_en = _guard53;
assign arg_mem_0_addr0 = std_slice_10_out;
assign arg_mem_3_content_en = _guard55;
assign arg_mem_3_write_en = _guard56;
assign arg_mem_2_addr0 = std_slice_11_out;
assign arg_mem_2_content_en = _guard58;
assign arg_mem_1_addr0 = std_slice_7_out;
assign arg_mem_1_content_en = _guard60;
assign adder_left =
  _guard61 ? idx_out :
  4'd0;
assign adder_right =
  _guard62 ? 4'd1 :
  4'd0;
assign fsm_write_en = _guard73;
assign fsm_clk = clk;
assign fsm_reset = reset;
assign fsm_in =
  _guard80 ? 2'd0 :
  _guard83 ? adder3_out :
  2'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard83, _guard80})) begin
    $fatal(2, "Multiple assignment to port `fsm.in'.");
end
end
assign adder10_left =
  _guard84 ? fsm0_out :
  3'd0;
assign adder10_right =
  _guard85 ? 3'd1 :
  3'd0;
assign invoke14_done_in = for_2_induction_var_reg_done;
assign incr_repeat1_go_in = _guard91;
assign early_reset_static_par_thread1_go_in = _guard92;
assign wrapper_early_reset_static_seq4_done_in = _guard93;
assign wrapper_early_reset_static_seq5_go_in = _guard99;
assign idx1_write_en = _guard102;
assign idx1_clk = clk;
assign idx1_reset = reset;
assign idx1_in =
  _guard103 ? adder1_out :
  _guard104 ? 4'd0 :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard104, _guard103})) begin
    $fatal(2, "Multiple assignment to port `idx1.in'.");
end
end
assign lt1_left =
  _guard105 ? adder1_out :
  4'd0;
assign lt1_right =
  _guard106 ? 4'd10 :
  4'd0;
assign lt2_left =
  _guard107 ? adder2_out :
  4'd0;
assign lt2_right =
  _guard108 ? 4'd10 :
  4'd0;
assign adder4_left =
  _guard109 ? fsm0_out :
  3'd0;
assign adder4_right =
  _guard110 ? 3'd1 :
  3'd0;
assign signal_reg0_write_en = _guard166;
assign signal_reg0_clk = clk;
assign signal_reg0_reset = reset;
assign signal_reg0_in =
  _guard220 ? 1'd1 :
  _guard221 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard221, _guard220})) begin
    $fatal(2, "Multiple assignment to port `signal_reg0.in'.");
end
end
assign wrapper_early_reset_static_par_thread_go_in = _guard227;
assign mem_2_write_en = _guard228;
assign mem_2_clk = clk;
assign mem_2_addr0 = std_slice_9_out;
assign mem_2_content_en = _guard238;
assign mem_2_reset = reset;
assign mem_2_write_data = arg_mem_0_read_data;
assign cond_reg0_write_en = _guard242;
assign cond_reg0_clk = clk;
assign cond_reg0_reset = reset;
assign cond_reg0_in =
  _guard243 ? 1'd1 :
  _guard244 ? lt0_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard244, _guard243})) begin
    $fatal(2, "Multiple assignment to port `cond_reg0.in'.");
end
end
assign bb0_12_done_in = arg_mem_2_done;
assign early_reset_static_par_thread0_done_in = ud1_out;
assign early_reset_static_seq3_done_in = ud3_out;
assign early_reset_static_seq4_go_in = _guard245;
assign early_reset_static_seq7_go_in = _guard246;
assign init_repeat1_go_in = _guard252;
assign early_reset_static_seq0_go_in = _guard255;
assign early_reset_static_seq5_go_in = _guard256;
assign wrapper_early_reset_static_seq7_go_in = _guard262;
assign idx0_write_en = _guard265;
assign idx0_clk = clk;
assign idx0_reset = reset;
assign idx0_in =
  _guard266 ? 10'd0 :
  _guard267 ? adder0_out :
  10'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard267, _guard266})) begin
    $fatal(2, "Multiple assignment to port `idx0.in'.");
end
end
assign fsm1_write_en = _guard278;
assign fsm1_clk = clk;
assign fsm1_reset = reset;
assign fsm1_in =
  _guard283 ? 4'd0 :
  _guard288 ? adder5_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard288, _guard283})) begin
    $fatal(2, "Multiple assignment to port `fsm1.in'.");
end
end
assign bb0_9_go_in = _guard294;
assign bb0_13_done_in = addf_0_reg_done;
assign invoke20_done_in = load_1_reg_done;
assign invoke23_go_in = _guard300;
assign early_reset_static_seq3_go_in = _guard301;
assign early_reset_static_seq6_go_in = _guard302;
assign early_reset_static_seq6_done_in = ud6_out;
assign std_mulFN_0_roundingMode = 3'd0;
assign std_mulFN_0_control = 1'd0;
assign std_mulFN_0_clk = clk;
assign std_mulFN_0_left =
  _guard303 ? load_1_reg_out :
  32'd0;
assign std_mulFN_0_reset = reset;
assign std_mulFN_0_go = _guard307;
assign std_mulFN_0_right =
  _guard308 ? arg_mem_1_read_data :
  32'd0;
assign adder6_left =
  _guard309 ? fsm0_out :
  3'd0;
assign adder6_right =
  _guard310 ? 3'd1 :
  3'd0;
assign bb0_16_go_in = _guard316;
assign invoke23_done_in = load_1_reg_done;
assign incr_repeat_go_in = _guard322;
assign init_repeat1_done_in = _guard325;
assign tdcc_go_in = go;
assign mem_1_write_en = _guard332;
assign mem_1_clk = clk;
assign mem_1_addr0 = std_slice_11_out;
assign mem_1_content_en = _guard362;
assign mem_1_reset = reset;
assign mem_1_write_data =
  _guard365 ? cst_0_out :
  _guard368 ? addf_0_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard368, _guard365})) begin
    $fatal(2, "Multiple assignment to port `mem_1.write_data'.");
end
end
assign std_slice_7_in = std_add_5_out;
assign addf_0_reg_write_en =
  _guard384 ? 1'd1 :
  _guard385 ? std_addFN_0_done :
  _guard386 ? std_addFN_1_done :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard386, _guard385, _guard384})) begin
    $fatal(2, "Multiple assignment to port `addf_0_reg.write_en'.");
end
end
assign addf_0_reg_clk = clk;
assign addf_0_reg_reset = reset;
assign addf_0_reg_in =
  _guard389 ? std_add_5_out :
  _guard392 ? 32'd0 :
  _guard393 ? std_addFN_0_out :
  _guard396 ? mem_0_read_data :
  _guard397 ? std_addFN_1_out :
  _guard400 ? std_mult_pipe_0_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard400, _guard397, _guard396, _guard393, _guard392, _guard389})) begin
    $fatal(2, "Multiple assignment to port `addf_0_reg.in'.");
end
end
assign mulf_0_reg_write_en =
  _guard405 ? 1'd1 :
  _guard406 ? std_mulFN_0_done :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard406, _guard405})) begin
    $fatal(2, "Multiple assignment to port `mulf_0_reg.write_en'.");
end
end
assign mulf_0_reg_clk = clk;
assign mulf_0_reg_reset = reset;
assign mulf_0_reg_in =
  _guard409 ? std_add_5_out :
  _guard410 ? 32'd0 :
  _guard411 ? std_mulFN_0_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard411, _guard410, _guard409})) begin
    $fatal(2, "Multiple assignment to port `mulf_0_reg.in'.");
end
end
assign adder2_left =
  _guard412 ? idx2_out :
  4'd0;
assign adder2_right =
  _guard413 ? 4'd1 :
  4'd0;
assign fsm0_write_en = _guard468;
assign fsm0_clk = clk;
assign fsm0_reset = reset;
assign fsm0_in =
  _guard471 ? adder10_out :
  _guard474 ? adder4_out :
  _guard477 ? adder6_out :
  _guard480 ? adder11_out :
  _guard483 ? adder8_out :
  _guard510 ? 3'd0 :
  _guard513 ? adder7_out :
  _guard516 ? adder9_out :
  3'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard516, _guard513, _guard510, _guard483, _guard480, _guard477, _guard474, _guard471})) begin
    $fatal(2, "Multiple assignment to port `fsm0.in'.");
end
end
assign fsm2_write_en = _guard767;
assign fsm2_clk = clk;
assign fsm2_reset = reset;
assign fsm2_in =
  _guard772 ? 5'd1 :
  _guard777 ? 5'd15 :
  _guard792 ? 5'd23 :
  _guard797 ? 5'd18 :
  _guard802 ? 5'd24 :
  _guard817 ? 5'd16 :
  _guard822 ? 5'd26 :
  _guard823 ? 5'd0 :
  _guard828 ? 5'd3 :
  _guard833 ? 5'd13 :
  _guard850 ? 5'd14 :
  _guard865 ? 5'd5 :
  _guard882 ? 5'd12 :
  _guard897 ? 5'd2 :
  _guard902 ? 5'd8 :
  _guard907 ? 5'd10 :
  _guard912 ? 5'd7 :
  _guard917 ? 5'd11 :
  _guard934 ? 5'd21 :
  _guard951 ? 5'd27 :
  _guard956 ? 5'd19 :
  _guard961 ? 5'd22 :
  _guard966 ? 5'd25 :
  _guard971 ? 5'd4 :
  _guard976 ? 5'd6 :
  _guard981 ? 5'd20 :
  _guard986 ? 5'd17 :
  _guard991 ? 5'd9 :
  5'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard991, _guard986, _guard981, _guard976, _guard971, _guard966, _guard961, _guard956, _guard951, _guard934, _guard917, _guard912, _guard907, _guard902, _guard897, _guard882, _guard865, _guard850, _guard833, _guard828, _guard823, _guard822, _guard817, _guard802, _guard797, _guard792, _guard777, _guard772})) begin
    $fatal(2, "Multiple assignment to port `fsm2.in'.");
end
end
assign incr_repeat0_done_in = _guard994;
assign incr_repeat2_go_in = _guard1000;
assign wrapper_early_reset_static_seq7_done_in = _guard1001;
assign std_addFN_0_roundingMode = 3'd0;
assign std_addFN_0_control = 1'd0;
assign std_addFN_0_clk = clk;
assign std_addFN_0_left =
  _guard1002 ? load_1_reg_out :
  32'd0;
assign std_addFN_0_subOp =
  _guard1003 ? 1'd0 :
  1'd0;
assign std_addFN_0_reset = reset;
assign std_addFN_0_go = _guard1007;
assign std_addFN_0_right =
  _guard1008 ? mulf_0_reg_out :
  32'd0;
assign idx_write_en = _guard1011;
assign idx_clk = clk;
assign idx_reset = reset;
assign idx_in =
  _guard1012 ? adder_out :
  _guard1013 ? 4'd0 :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1013, _guard1012})) begin
    $fatal(2, "Multiple assignment to port `idx.in'.");
end
end
assign adder3_left =
  _guard1014 ? fsm_out :
  2'd0;
assign adder3_right =
  _guard1015 ? 2'd1 :
  2'd0;
assign adder5_left =
  _guard1016 ? fsm1_out :
  4'd0;
assign adder5_right =
  _guard1017 ? 4'd1 :
  4'd0;
assign bb0_9_done_in = addf_0_reg_done;
assign init_repeat_done_in = _guard1020;
assign incr_repeat_done_in = _guard1023;
assign init_repeat0_done_in = _guard1026;
assign early_reset_static_par_thread1_done_in = ud2_out;
assign wrapper_early_reset_static_seq3_go_in = _guard1032;
assign adder0_left =
  _guard1033 ? idx0_out :
  10'd0;
assign adder0_right =
  _guard1034 ? 10'd1 :
  10'd0;
assign adder11_left =
  _guard1035 ? fsm0_out :
  3'd0;
assign adder11_right =
  _guard1036 ? 3'd1 :
  3'd0;
assign bb0_7_done_in = mulf_0_reg_done;
assign bb0_16_done_in = arg_mem_3_done;
assign init_repeat0_go_in = _guard1042;
assign incr_repeat0_go_in = _guard1048;
assign init_repeat2_go_in = _guard1054;
assign wrapper_early_reset_static_par_thread0_go_in = _guard1060;
assign mem_0_write_en = _guard1063;
assign mem_0_clk = clk;
assign mem_0_addr0 = std_slice_11_out;
assign mem_0_content_en = _guard1077;
assign mem_0_reset = reset;
assign mem_0_write_data = addf_0_reg_out;
assign std_addFN_1_roundingMode = 3'd0;
assign std_addFN_1_control = 1'd0;
assign std_addFN_1_clk = clk;
assign std_addFN_1_left =
  _guard1081 ? load_1_reg_out :
  32'd0;
assign std_addFN_1_subOp =
  _guard1082 ? 1'd0 :
  1'd0;
assign std_addFN_1_reset = reset;
assign std_addFN_1_go = _guard1086;
assign std_addFN_1_right =
  _guard1087 ? arg_mem_2_read_data :
  32'd0;
assign std_mult_pipe_0_clk = clk;
assign std_mult_pipe_0_left = for_1_induction_var_reg_out;
assign std_mult_pipe_0_reset = reset;
assign std_mult_pipe_0_go = _guard1093;
assign std_mult_pipe_0_right = 32'd784;
assign adder8_left =
  _guard1097 ? fsm0_out :
  3'd0;
assign adder8_right =
  _guard1098 ? 3'd1 :
  3'd0;
assign signal_reg_write_en = _guard1111;
assign signal_reg_clk = clk;
assign signal_reg_reset = reset;
assign signal_reg_in =
  _guard1122 ? 1'd1 :
  _guard1123 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1123, _guard1122})) begin
    $fatal(2, "Multiple assignment to port `signal_reg.in'.");
end
end
assign bb0_6_done_in = arg_mem_1_done;
assign incr_repeat1_done_in = _guard1126;
assign init_repeat2_done_in = _guard1129;
assign early_reset_static_par_thread_go_in = _guard1130;
assign early_reset_static_seq5_done_in = ud5_out;
assign wrapper_early_reset_static_par_thread0_done_in = _guard1131;
assign wrapper_early_reset_static_par_thread1_go_in = _guard1137;
assign for_2_induction_var_reg_write_en = _guard1142;
assign for_2_induction_var_reg_clk = clk;
assign for_2_induction_var_reg_reset = reset;
assign for_2_induction_var_reg_in =
  _guard1143 ? std_add_5_out :
  _guard1146 ? 32'd0 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1146, _guard1143})) begin
    $fatal(2, "Multiple assignment to port `for_2_induction_var_reg.in'.");
end
end
assign early_reset_static_par_thread0_go_in = _guard1147;
assign early_reset_static_seq4_done_in = ud4_out;
assign wrapper_early_reset_static_par_thread_done_in = _guard1148;
assign wrapper_early_reset_static_seq6_done_in = _guard1149;
assign bb0_1_done_in = arg_mem_0_done;
assign invoke20_go_in = _guard1155;
assign tdcc_done_in = _guard1156;
assign for_1_induction_var_reg_write_en = _guard1161;
assign for_1_induction_var_reg_clk = clk;
assign for_1_induction_var_reg_reset = reset;
assign for_1_induction_var_reg_in =
  _guard1164 ? std_add_5_out :
  _guard1165 ? 32'd0 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1165, _guard1164})) begin
    $fatal(2, "Multiple assignment to port `for_1_induction_var_reg.in'.");
end
end
assign lt_left =
  _guard1166 ? adder_out :
  4'd0;
assign lt_right =
  _guard1167 ? 4'd10 :
  4'd0;
assign cond_reg2_write_en = _guard1170;
assign cond_reg2_clk = clk;
assign cond_reg2_reset = reset;
assign cond_reg2_in =
  _guard1171 ? 1'd1 :
  _guard1172 ? lt2_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1172, _guard1171})) begin
    $fatal(2, "Multiple assignment to port `cond_reg2.in'.");
end
end
assign bb0_7_go_in = _guard1178;
assign invoke15_go_in = _guard1184;
assign invoke15_done_in = mulf_0_reg_done;
assign wrapper_early_reset_static_par_thread1_done_in = _guard1185;
assign wrapper_early_reset_static_seq3_done_in = _guard1186;
assign wrapper_early_reset_static_seq6_go_in = _guard1192;
assign std_slice_11_in =
  _guard1195 ? addf_0_reg_out :
  _guard1204 ? mulf_0_reg_out :
  _guard1211 ? for_1_induction_var_reg_out :
  _guard1216 ? load_1_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1216, _guard1211, _guard1204, _guard1195})) begin
    $fatal(2, "Multiple assignment to port `std_slice_11.in'.");
end
end
assign bb0_1_go_in = _guard1222;
assign early_reset_static_par_thread_done_in = ud_out;
assign early_reset_static_seq0_done_in = ud0_out;
assign wrapper_early_reset_static_seq4_go_in = _guard1228;
assign std_slice_9_in = 32'd0;
assign load_1_reg_write_en = _guard1248;
assign load_1_reg_clk = clk;
assign load_1_reg_reset = reset;
assign load_1_reg_in =
  _guard1249 ? std_add_5_out :
  _guard1250 ? 32'd0 :
  _guard1253 ? mem_2_read_data :
  _guard1260 ? mem_1_read_data :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1260, _guard1253, _guard1250, _guard1249})) begin
    $fatal(2, "Multiple assignment to port `load_1_reg.in'.");
end
end
assign cond_reg_write_en = _guard1263;
assign cond_reg_clk = clk;
assign cond_reg_reset = reset;
assign cond_reg_in =
  _guard1264 ? 1'd1 :
  _guard1265 ? lt_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1265, _guard1264})) begin
    $fatal(2, "Multiple assignment to port `cond_reg.in'.");
end
end
assign lt0_left =
  _guard1266 ? adder0_out :
  10'd0;
assign lt0_right =
  _guard1267 ? 10'd784 :
  10'd0;
assign idx2_write_en = _guard1270;
assign idx2_clk = clk;
assign idx2_reset = reset;
assign idx2_in =
  _guard1271 ? 4'd0 :
  _guard1272 ? adder2_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1272, _guard1271})) begin
    $fatal(2, "Multiple assignment to port `idx2.in'.");
end
end
assign adder7_left =
  _guard1273 ? fsm0_out :
  3'd0;
assign adder7_right =
  _guard1274 ? 3'd1 :
  3'd0;
assign adder9_left =
  _guard1275 ? fsm0_out :
  3'd0;
assign adder9_right =
  _guard1276 ? 3'd1 :
  3'd0;
assign bb0_12_go_in = _guard1282;
assign bb0_13_go_in = _guard1288;
assign invoke14_go_in = _guard1294;
assign incr_repeat2_done_in = _guard1297;
assign wrapper_early_reset_static_seq5_done_in = _guard1298;
// COMPONENT END: linear2d_0
endmodule
module forward(
  input logic clk,
  input logic reset,
  input logic go,
  output logic done,
  output logic [3:0] arg_mem_4_addr0,
  output logic arg_mem_4_content_en,
  output logic arg_mem_4_write_en,
  output logic [31:0] arg_mem_4_write_data,
  input logic [31:0] arg_mem_4_read_data,
  input logic arg_mem_4_done,
  output logic [3:0] arg_mem_3_addr0,
  output logic arg_mem_3_content_en,
  output logic arg_mem_3_write_en,
  output logic [31:0] arg_mem_3_write_data,
  input logic [31:0] arg_mem_3_read_data,
  input logic arg_mem_3_done,
  output logic [12:0] arg_mem_2_addr0,
  output logic arg_mem_2_content_en,
  output logic arg_mem_2_write_en,
  output logic [31:0] arg_mem_2_write_data,
  input logic [31:0] arg_mem_2_read_data,
  input logic arg_mem_2_done,
  output logic [3:0] arg_mem_1_addr0,
  output logic arg_mem_1_content_en,
  output logic arg_mem_1_write_en,
  output logic [31:0] arg_mem_1_write_data,
  input logic [31:0] arg_mem_1_read_data,
  input logic arg_mem_1_done,
  output logic [9:0] arg_mem_0_addr0,
  output logic arg_mem_0_content_en,
  output logic arg_mem_0_write_en,
  output logic [31:0] arg_mem_0_write_data,
  input logic [31:0] arg_mem_0_read_data,
  input logic arg_mem_0_done
);
// COMPONENT START: forward
logic [31:0] std_slice_1_in;
logic [3:0] std_slice_1_out;
logic [31:0] std_add_0_left;
logic [31:0] std_add_0_right;
logic [31:0] std_add_0_out;
logic [31:0] for_0_induction_var_reg_in;
logic for_0_induction_var_reg_write_en;
logic for_0_induction_var_reg_clk;
logic for_0_induction_var_reg_reset;
logic [31:0] for_0_induction_var_reg_out;
logic for_0_induction_var_reg_done;
logic linear2d_0_instance_clk;
logic linear2d_0_instance_reset;
logic linear2d_0_instance_go;
logic linear2d_0_instance_done;
logic [31:0] linear2d_0_instance_arg_mem_0_read_data;
logic linear2d_0_instance_arg_mem_0_done;
logic [31:0] linear2d_0_instance_arg_mem_1_write_data;
logic [31:0] linear2d_0_instance_arg_mem_3_read_data;
logic [31:0] linear2d_0_instance_arg_mem_2_read_data;
logic [3:0] linear2d_0_instance_arg_mem_3_addr0;
logic [31:0] linear2d_0_instance_arg_mem_3_write_data;
logic [31:0] linear2d_0_instance_arg_mem_1_read_data;
logic linear2d_0_instance_arg_mem_0_content_en;
logic [9:0] linear2d_0_instance_arg_mem_0_addr0;
logic linear2d_0_instance_arg_mem_3_content_en;
logic linear2d_0_instance_arg_mem_3_done;
logic linear2d_0_instance_arg_mem_0_write_en;
logic linear2d_0_instance_arg_mem_3_write_en;
logic [3:0] linear2d_0_instance_arg_mem_2_addr0;
logic linear2d_0_instance_arg_mem_2_done;
logic linear2d_0_instance_arg_mem_1_done;
logic linear2d_0_instance_arg_mem_2_content_en;
logic [31:0] linear2d_0_instance_arg_mem_0_write_data;
logic linear2d_0_instance_arg_mem_1_write_en;
logic linear2d_0_instance_arg_mem_2_write_en;
logic [31:0] linear2d_0_instance_arg_mem_2_write_data;
logic [12:0] linear2d_0_instance_arg_mem_1_addr0;
logic linear2d_0_instance_arg_mem_1_content_en;
logic [3:0] idx_in;
logic idx_write_en;
logic idx_clk;
logic idx_reset;
logic [3:0] idx_out;
logic idx_done;
logic cond_reg_in;
logic cond_reg_write_en;
logic cond_reg_clk;
logic cond_reg_reset;
logic cond_reg_out;
logic cond_reg_done;
logic [3:0] adder_left;
logic [3:0] adder_right;
logic [3:0] adder_out;
logic [3:0] lt_left;
logic [3:0] lt_right;
logic lt_out;
logic [2:0] fsm_in;
logic fsm_write_en;
logic fsm_clk;
logic fsm_reset;
logic [2:0] fsm_out;
logic fsm_done;
logic bb0_0_go_in;
logic bb0_0_go_out;
logic bb0_0_done_in;
logic bb0_0_done_out;
logic bb0_1_go_in;
logic bb0_1_go_out;
logic bb0_1_done_in;
logic bb0_1_done_out;
logic invoke0_go_in;
logic invoke0_go_out;
logic invoke0_done_in;
logic invoke0_done_out;
logic invoke1_go_in;
logic invoke1_go_out;
logic invoke1_done_in;
logic invoke1_done_out;
logic invoke2_go_in;
logic invoke2_go_out;
logic invoke2_done_in;
logic invoke2_done_out;
logic init_repeat_go_in;
logic init_repeat_go_out;
logic init_repeat_done_in;
logic init_repeat_done_out;
logic incr_repeat_go_in;
logic incr_repeat_go_out;
logic incr_repeat_done_in;
logic incr_repeat_done_out;
logic tdcc_go_in;
logic tdcc_go_out;
logic tdcc_done_in;
logic tdcc_done_out;
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(4)
) std_slice_1 (
    .in(std_slice_1_in),
    .out(std_slice_1_out)
);
std_add # (
    .WIDTH(32)
) std_add_0 (
    .left(std_add_0_left),
    .out(std_add_0_out),
    .right(std_add_0_right)
);
std_reg # (
    .WIDTH(32)
) for_0_induction_var_reg (
    .clk(for_0_induction_var_reg_clk),
    .done(for_0_induction_var_reg_done),
    .in(for_0_induction_var_reg_in),
    .out(for_0_induction_var_reg_out),
    .reset(for_0_induction_var_reg_reset),
    .write_en(for_0_induction_var_reg_write_en)
);
linear2d_0 linear2d_0_instance (
    .arg_mem_0_addr0(linear2d_0_instance_arg_mem_0_addr0),
    .arg_mem_0_content_en(linear2d_0_instance_arg_mem_0_content_en),
    .arg_mem_0_done(linear2d_0_instance_arg_mem_0_done),
    .arg_mem_0_read_data(linear2d_0_instance_arg_mem_0_read_data),
    .arg_mem_0_write_data(linear2d_0_instance_arg_mem_0_write_data),
    .arg_mem_0_write_en(linear2d_0_instance_arg_mem_0_write_en),
    .arg_mem_1_addr0(linear2d_0_instance_arg_mem_1_addr0),
    .arg_mem_1_content_en(linear2d_0_instance_arg_mem_1_content_en),
    .arg_mem_1_done(linear2d_0_instance_arg_mem_1_done),
    .arg_mem_1_read_data(linear2d_0_instance_arg_mem_1_read_data),
    .arg_mem_1_write_data(linear2d_0_instance_arg_mem_1_write_data),
    .arg_mem_1_write_en(linear2d_0_instance_arg_mem_1_write_en),
    .arg_mem_2_addr0(linear2d_0_instance_arg_mem_2_addr0),
    .arg_mem_2_content_en(linear2d_0_instance_arg_mem_2_content_en),
    .arg_mem_2_done(linear2d_0_instance_arg_mem_2_done),
    .arg_mem_2_read_data(linear2d_0_instance_arg_mem_2_read_data),
    .arg_mem_2_write_data(linear2d_0_instance_arg_mem_2_write_data),
    .arg_mem_2_write_en(linear2d_0_instance_arg_mem_2_write_en),
    .arg_mem_3_addr0(linear2d_0_instance_arg_mem_3_addr0),
    .arg_mem_3_content_en(linear2d_0_instance_arg_mem_3_content_en),
    .arg_mem_3_done(linear2d_0_instance_arg_mem_3_done),
    .arg_mem_3_read_data(linear2d_0_instance_arg_mem_3_read_data),
    .arg_mem_3_write_data(linear2d_0_instance_arg_mem_3_write_data),
    .arg_mem_3_write_en(linear2d_0_instance_arg_mem_3_write_en),
    .clk(linear2d_0_instance_clk),
    .done(linear2d_0_instance_done),
    .go(linear2d_0_instance_go),
    .reset(linear2d_0_instance_reset)
);
std_reg # (
    .WIDTH(4)
) idx (
    .clk(idx_clk),
    .done(idx_done),
    .in(idx_in),
    .out(idx_out),
    .reset(idx_reset),
    .write_en(idx_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg (
    .clk(cond_reg_clk),
    .done(cond_reg_done),
    .in(cond_reg_in),
    .out(cond_reg_out),
    .reset(cond_reg_reset),
    .write_en(cond_reg_write_en)
);
std_add # (
    .WIDTH(4)
) adder (
    .left(adder_left),
    .out(adder_out),
    .right(adder_right)
);
std_lt # (
    .WIDTH(4)
) lt (
    .left(lt_left),
    .out(lt_out),
    .right(lt_right)
);
std_reg # (
    .WIDTH(3)
) fsm (
    .clk(fsm_clk),
    .done(fsm_done),
    .in(fsm_in),
    .out(fsm_out),
    .reset(fsm_reset),
    .write_en(fsm_write_en)
);
std_wire # (
    .WIDTH(1)
) bb0_0_go (
    .in(bb0_0_go_in),
    .out(bb0_0_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_0_done (
    .in(bb0_0_done_in),
    .out(bb0_0_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_1_go (
    .in(bb0_1_go_in),
    .out(bb0_1_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_1_done (
    .in(bb0_1_done_in),
    .out(bb0_1_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke0_go (
    .in(invoke0_go_in),
    .out(invoke0_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke0_done (
    .in(invoke0_done_in),
    .out(invoke0_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke1_go (
    .in(invoke1_go_in),
    .out(invoke1_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke1_done (
    .in(invoke1_done_in),
    .out(invoke1_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke2_go (
    .in(invoke2_go_in),
    .out(invoke2_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke2_done (
    .in(invoke2_done_in),
    .out(invoke2_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat_go (
    .in(init_repeat_go_in),
    .out(init_repeat_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat_done (
    .in(init_repeat_done_in),
    .out(init_repeat_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat_go (
    .in(incr_repeat_go_in),
    .out(incr_repeat_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat_done (
    .in(incr_repeat_done_in),
    .out(incr_repeat_done_out)
);
std_wire # (
    .WIDTH(1)
) tdcc_go (
    .in(tdcc_go_in),
    .out(tdcc_go_out)
);
std_wire # (
    .WIDTH(1)
) tdcc_done (
    .in(tdcc_done_in),
    .out(tdcc_done_out)
);
wire _guard0 = 1;
wire _guard1 = init_repeat_done_out;
wire _guard2 = ~_guard1;
wire _guard3 = fsm_out == 3'd2;
wire _guard4 = _guard2 & _guard3;
wire _guard5 = tdcc_go_out;
wire _guard6 = _guard4 & _guard5;
wire _guard7 = tdcc_done_out;
wire _guard8 = bb0_1_go_out;
wire _guard9 = invoke0_go_out;
wire _guard10 = invoke0_go_out;
wire _guard11 = invoke0_go_out;
wire _guard12 = invoke0_go_out;
wire _guard13 = invoke0_go_out;
wire _guard14 = bb0_0_go_out;
wire _guard15 = invoke0_go_out;
wire _guard16 = invoke0_go_out;
wire _guard17 = invoke0_go_out;
wire _guard18 = bb0_1_go_out;
wire _guard19 = bb0_0_go_out;
wire _guard20 = invoke0_go_out;
wire _guard21 = invoke0_go_out;
wire _guard22 = bb0_1_go_out;
wire _guard23 = bb0_1_go_out;
wire _guard24 = incr_repeat_go_out;
wire _guard25 = incr_repeat_go_out;
wire _guard26 = fsm_out == 3'd7;
wire _guard27 = fsm_out == 3'd0;
wire _guard28 = invoke0_done_out;
wire _guard29 = _guard27 & _guard28;
wire _guard30 = tdcc_go_out;
wire _guard31 = _guard29 & _guard30;
wire _guard32 = _guard26 | _guard31;
wire _guard33 = fsm_out == 3'd1;
wire _guard34 = invoke1_done_out;
wire _guard35 = _guard33 & _guard34;
wire _guard36 = tdcc_go_out;
wire _guard37 = _guard35 & _guard36;
wire _guard38 = _guard32 | _guard37;
wire _guard39 = fsm_out == 3'd2;
wire _guard40 = init_repeat_done_out;
wire _guard41 = cond_reg_out;
wire _guard42 = _guard40 & _guard41;
wire _guard43 = _guard39 & _guard42;
wire _guard44 = tdcc_go_out;
wire _guard45 = _guard43 & _guard44;
wire _guard46 = _guard38 | _guard45;
wire _guard47 = fsm_out == 3'd6;
wire _guard48 = incr_repeat_done_out;
wire _guard49 = cond_reg_out;
wire _guard50 = _guard48 & _guard49;
wire _guard51 = _guard47 & _guard50;
wire _guard52 = tdcc_go_out;
wire _guard53 = _guard51 & _guard52;
wire _guard54 = _guard46 | _guard53;
wire _guard55 = fsm_out == 3'd3;
wire _guard56 = bb0_0_done_out;
wire _guard57 = _guard55 & _guard56;
wire _guard58 = tdcc_go_out;
wire _guard59 = _guard57 & _guard58;
wire _guard60 = _guard54 | _guard59;
wire _guard61 = fsm_out == 3'd4;
wire _guard62 = bb0_1_done_out;
wire _guard63 = _guard61 & _guard62;
wire _guard64 = tdcc_go_out;
wire _guard65 = _guard63 & _guard64;
wire _guard66 = _guard60 | _guard65;
wire _guard67 = fsm_out == 3'd5;
wire _guard68 = invoke2_done_out;
wire _guard69 = _guard67 & _guard68;
wire _guard70 = tdcc_go_out;
wire _guard71 = _guard69 & _guard70;
wire _guard72 = _guard66 | _guard71;
wire _guard73 = fsm_out == 3'd2;
wire _guard74 = init_repeat_done_out;
wire _guard75 = cond_reg_out;
wire _guard76 = ~_guard75;
wire _guard77 = _guard74 & _guard76;
wire _guard78 = _guard73 & _guard77;
wire _guard79 = tdcc_go_out;
wire _guard80 = _guard78 & _guard79;
wire _guard81 = _guard72 | _guard80;
wire _guard82 = fsm_out == 3'd6;
wire _guard83 = incr_repeat_done_out;
wire _guard84 = cond_reg_out;
wire _guard85 = ~_guard84;
wire _guard86 = _guard83 & _guard85;
wire _guard87 = _guard82 & _guard86;
wire _guard88 = tdcc_go_out;
wire _guard89 = _guard87 & _guard88;
wire _guard90 = _guard81 | _guard89;
wire _guard91 = fsm_out == 3'd2;
wire _guard92 = init_repeat_done_out;
wire _guard93 = cond_reg_out;
wire _guard94 = ~_guard93;
wire _guard95 = _guard92 & _guard94;
wire _guard96 = _guard91 & _guard95;
wire _guard97 = tdcc_go_out;
wire _guard98 = _guard96 & _guard97;
wire _guard99 = fsm_out == 3'd6;
wire _guard100 = incr_repeat_done_out;
wire _guard101 = cond_reg_out;
wire _guard102 = ~_guard101;
wire _guard103 = _guard100 & _guard102;
wire _guard104 = _guard99 & _guard103;
wire _guard105 = tdcc_go_out;
wire _guard106 = _guard104 & _guard105;
wire _guard107 = _guard98 | _guard106;
wire _guard108 = fsm_out == 3'd5;
wire _guard109 = invoke2_done_out;
wire _guard110 = _guard108 & _guard109;
wire _guard111 = tdcc_go_out;
wire _guard112 = _guard110 & _guard111;
wire _guard113 = fsm_out == 3'd4;
wire _guard114 = bb0_1_done_out;
wire _guard115 = _guard113 & _guard114;
wire _guard116 = tdcc_go_out;
wire _guard117 = _guard115 & _guard116;
wire _guard118 = fsm_out == 3'd1;
wire _guard119 = invoke1_done_out;
wire _guard120 = _guard118 & _guard119;
wire _guard121 = tdcc_go_out;
wire _guard122 = _guard120 & _guard121;
wire _guard123 = fsm_out == 3'd3;
wire _guard124 = bb0_0_done_out;
wire _guard125 = _guard123 & _guard124;
wire _guard126 = tdcc_go_out;
wire _guard127 = _guard125 & _guard126;
wire _guard128 = fsm_out == 3'd0;
wire _guard129 = invoke0_done_out;
wire _guard130 = _guard128 & _guard129;
wire _guard131 = tdcc_go_out;
wire _guard132 = _guard130 & _guard131;
wire _guard133 = fsm_out == 3'd7;
wire _guard134 = fsm_out == 3'd2;
wire _guard135 = init_repeat_done_out;
wire _guard136 = cond_reg_out;
wire _guard137 = _guard135 & _guard136;
wire _guard138 = _guard134 & _guard137;
wire _guard139 = tdcc_go_out;
wire _guard140 = _guard138 & _guard139;
wire _guard141 = fsm_out == 3'd6;
wire _guard142 = incr_repeat_done_out;
wire _guard143 = cond_reg_out;
wire _guard144 = _guard142 & _guard143;
wire _guard145 = _guard141 & _guard144;
wire _guard146 = tdcc_go_out;
wire _guard147 = _guard145 & _guard146;
wire _guard148 = _guard140 | _guard147;
wire _guard149 = bb0_0_done_out;
wire _guard150 = ~_guard149;
wire _guard151 = fsm_out == 3'd3;
wire _guard152 = _guard150 & _guard151;
wire _guard153 = tdcc_go_out;
wire _guard154 = _guard152 & _guard153;
wire _guard155 = invoke2_done_out;
wire _guard156 = ~_guard155;
wire _guard157 = fsm_out == 3'd5;
wire _guard158 = _guard156 & _guard157;
wire _guard159 = tdcc_go_out;
wire _guard160 = _guard158 & _guard159;
wire _guard161 = invoke1_go_out;
wire _guard162 = invoke2_go_out;
wire _guard163 = _guard161 | _guard162;
wire _guard164 = invoke1_go_out;
wire _guard165 = invoke2_go_out;
wire _guard166 = invoke0_done_out;
wire _guard167 = ~_guard166;
wire _guard168 = fsm_out == 3'd0;
wire _guard169 = _guard167 & _guard168;
wire _guard170 = tdcc_go_out;
wire _guard171 = _guard169 & _guard170;
wire _guard172 = incr_repeat_done_out;
wire _guard173 = ~_guard172;
wire _guard174 = fsm_out == 3'd6;
wire _guard175 = _guard173 & _guard174;
wire _guard176 = tdcc_go_out;
wire _guard177 = _guard175 & _guard176;
wire _guard178 = invoke2_go_out;
wire _guard179 = invoke2_go_out;
wire _guard180 = invoke0_go_out;
wire _guard181 = invoke0_go_out;
wire _guard182 = invoke0_go_out;
wire _guard183 = invoke0_go_out;
wire _guard184 = invoke0_go_out;
wire _guard185 = invoke0_go_out;
wire _guard186 = invoke0_go_out;
wire _guard187 = invoke0_go_out;
wire _guard188 = init_repeat_go_out;
wire _guard189 = incr_repeat_go_out;
wire _guard190 = _guard188 | _guard189;
wire _guard191 = incr_repeat_go_out;
wire _guard192 = init_repeat_go_out;
wire _guard193 = cond_reg_done;
wire _guard194 = idx_done;
wire _guard195 = _guard193 & _guard194;
wire _guard196 = cond_reg_done;
wire _guard197 = idx_done;
wire _guard198 = _guard196 & _guard197;
wire _guard199 = invoke1_done_out;
wire _guard200 = ~_guard199;
wire _guard201 = fsm_out == 3'd1;
wire _guard202 = _guard200 & _guard201;
wire _guard203 = tdcc_go_out;
wire _guard204 = _guard202 & _guard203;
wire _guard205 = bb0_0_go_out;
wire _guard206 = bb0_1_go_out;
wire _guard207 = _guard205 | _guard206;
wire _guard208 = fsm_out == 3'd7;
wire _guard209 = incr_repeat_go_out;
wire _guard210 = incr_repeat_go_out;
wire _guard211 = bb0_1_done_out;
wire _guard212 = ~_guard211;
wire _guard213 = fsm_out == 3'd4;
wire _guard214 = _guard212 & _guard213;
wire _guard215 = tdcc_go_out;
wire _guard216 = _guard214 & _guard215;
wire _guard217 = init_repeat_go_out;
wire _guard218 = incr_repeat_go_out;
wire _guard219 = _guard217 | _guard218;
wire _guard220 = init_repeat_go_out;
wire _guard221 = incr_repeat_go_out;
assign init_repeat_go_in = _guard6;
assign done = _guard7;
assign arg_mem_1_write_data = arg_mem_4_read_data;
assign arg_mem_3_addr0 = linear2d_0_instance_arg_mem_2_addr0;
assign arg_mem_0_content_en =
  _guard10 ? linear2d_0_instance_arg_mem_0_content_en :
  1'd0;
assign arg_mem_4_write_data = linear2d_0_instance_arg_mem_3_write_data;
assign arg_mem_0_addr0 = linear2d_0_instance_arg_mem_0_addr0;
assign arg_mem_4_addr0 =
  _guard13 ? linear2d_0_instance_arg_mem_3_addr0 :
  _guard14 ? std_slice_1_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard14, _guard13})) begin
    $fatal(2, "Multiple assignment to port `_this.arg_mem_4_addr0'.");
end
end
assign arg_mem_3_content_en =
  _guard15 ? linear2d_0_instance_arg_mem_2_content_en :
  1'd0;
assign arg_mem_2_addr0 = linear2d_0_instance_arg_mem_1_addr0;
assign arg_mem_2_content_en =
  _guard17 ? linear2d_0_instance_arg_mem_1_content_en :
  1'd0;
assign arg_mem_1_write_en = _guard18;
assign arg_mem_4_content_en =
  _guard19 ? 1'd1 :
  _guard20 ? linear2d_0_instance_arg_mem_3_content_en :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard20, _guard19})) begin
    $fatal(2, "Multiple assignment to port `_this.arg_mem_4_content_en'.");
end
end
assign arg_mem_4_write_en =
  _guard21 ? linear2d_0_instance_arg_mem_3_write_en :
  1'd0;
assign arg_mem_1_addr0 = std_slice_1_out;
assign arg_mem_1_content_en = _guard23;
assign adder_left =
  _guard24 ? idx_out :
  4'd0;
assign adder_right =
  _guard25 ? 4'd1 :
  4'd0;
assign fsm_write_en = _guard90;
assign fsm_clk = clk;
assign fsm_reset = reset;
assign fsm_in =
  _guard107 ? 3'd7 :
  _guard112 ? 3'd6 :
  _guard117 ? 3'd5 :
  _guard122 ? 3'd2 :
  _guard127 ? 3'd4 :
  _guard132 ? 3'd1 :
  _guard133 ? 3'd0 :
  _guard148 ? 3'd3 :
  3'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard148, _guard133, _guard132, _guard127, _guard122, _guard117, _guard112, _guard107})) begin
    $fatal(2, "Multiple assignment to port `fsm.in'.");
end
end
assign bb0_0_go_in = _guard154;
assign invoke2_go_in = _guard160;
assign for_0_induction_var_reg_write_en = _guard163;
assign for_0_induction_var_reg_clk = clk;
assign for_0_induction_var_reg_reset = reset;
assign for_0_induction_var_reg_in =
  _guard164 ? 32'd0 :
  _guard165 ? std_add_0_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard165, _guard164})) begin
    $fatal(2, "Multiple assignment to port `for_0_induction_var_reg.in'.");
end
end
assign invoke0_go_in = _guard171;
assign incr_repeat_go_in = _guard177;
assign tdcc_go_in = go;
assign bb0_0_done_in = arg_mem_4_done;
assign std_add_0_left = for_0_induction_var_reg_out;
assign std_add_0_right = 32'd1;
assign linear2d_0_instance_arg_mem_0_read_data =
  _guard180 ? arg_mem_0_read_data :
  32'd0;
assign linear2d_0_instance_arg_mem_0_done =
  _guard181 ? arg_mem_0_done :
  1'd0;
assign linear2d_0_instance_arg_mem_2_read_data =
  _guard182 ? arg_mem_3_read_data :
  32'd0;
assign linear2d_0_instance_arg_mem_1_read_data =
  _guard183 ? arg_mem_2_read_data :
  32'd0;
assign linear2d_0_instance_clk = clk;
assign linear2d_0_instance_arg_mem_3_done =
  _guard184 ? arg_mem_4_done :
  1'd0;
assign linear2d_0_instance_reset = reset;
assign linear2d_0_instance_go = _guard185;
assign linear2d_0_instance_arg_mem_2_done =
  _guard186 ? arg_mem_3_done :
  1'd0;
assign linear2d_0_instance_arg_mem_1_done =
  _guard187 ? arg_mem_2_done :
  1'd0;
assign idx_write_en = _guard190;
assign idx_clk = clk;
assign idx_reset = reset;
assign idx_in =
  _guard191 ? adder_out :
  _guard192 ? 4'd0 :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard192, _guard191})) begin
    $fatal(2, "Multiple assignment to port `idx.in'.");
end
end
assign init_repeat_done_in = _guard195;
assign incr_repeat_done_in = _guard198;
assign invoke0_done_in = linear2d_0_instance_done;
assign invoke1_go_in = _guard204;
assign invoke2_done_in = for_0_induction_var_reg_done;
assign std_slice_1_in = for_0_induction_var_reg_out;
assign bb0_1_done_in = arg_mem_1_done;
assign tdcc_done_in = _guard208;
assign lt_left =
  _guard209 ? adder_out :
  4'd0;
assign lt_right =
  _guard210 ? 4'd10 :
  4'd0;
assign bb0_1_go_in = _guard216;
assign invoke1_done_in = for_0_induction_var_reg_done;
assign cond_reg_write_en = _guard219;
assign cond_reg_clk = clk;
assign cond_reg_reset = reset;
assign cond_reg_in =
  _guard220 ? 1'd1 :
  _guard221 ? lt_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard221, _guard220})) begin
    $fatal(2, "Multiple assignment to port `cond_reg.in'.");
end
end
// COMPONENT END: forward
endmodule

/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    recFNToFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth):0] in,
        output [(expWidth + sigWidth - 1):0] out
    );

/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

function integer clog2;
    input integer a;

    begin
        a = a - 1;
        for (clog2 = 0; a > 0; clog2 = clog2 + 1) a = a>>1;
    end

endfunction



    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam [expWidth:0] minNormExp = (1<<(expWidth - 1)) + 2;
    localparam normDistWidth = clog2(sigWidth);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaN, isInf, isZero, sign;
    wire signed [(expWidth + 1):0] sExp;
    wire [sigWidth:0] sig;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN(in, isNaN, isInf, isZero, sign, sExp, sig);
    wire isSubnormal = (sExp < minNormExp);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [(normDistWidth - 1):0] denormShiftDist = minNormExp - 1 - sExp;
    wire [(expWidth - 1):0] expOut =
        (isSubnormal ? 0 : sExp - minNormExp + 1)
            | (isNaN || isInf ? {expWidth{1'b1}} : 0);
    wire [(sigWidth - 2):0] fractOut =
        isSubnormal ? (sig>>1)>>denormShiftDist : isInf ? 0 : sig;
    assign out = {sign, expOut, fractOut};

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/


/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define round_near_even   3'b000
`define round_minMag      3'b001
`define round_min         3'b010
`define round_max         3'b011
`define round_near_maxMag 3'b100
`define round_odd         3'b110

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define floatControlWidth 1
`define flControl_tininessBeforeRounding 1'b0
`define flControl_tininessAfterRounding  1'b1

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flRoundOpt_sigMSBitAlwaysZero  1
`define flRoundOpt_subnormsAlwaysExact 2
`define flRoundOpt_neverUnderflows     4
`define flRoundOpt_neverOverflows      8



/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flControl_default `flControl_tininessAfterRounding

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
//`define HardFloat_propagateNaNPayloads

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define HardFloat_signDefaultNaN 0
`define HardFloat_fractDefaultNaN(sigWidth) {1'b1, {((sigWidth) - 2){1'b0}}}



/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    mulRecFNToFullRaw#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        output invalidExc,
        output out_isNaN,
        output out_isInf,
        output out_isZero,
        output out_sign,
        output signed [(expWidth + 1):0] out_sExp,
        output [(sigWidth*2 - 1):0] out_sig
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaNA, isInfA, isZeroA, signA;
    wire signed [(expWidth + 1):0] sExpA;
    wire [sigWidth:0] sigA;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_a(a, isNaNA, isInfA, isZeroA, signA, sExpA, sigA);
    wire isSigNaNA;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_a(a, isSigNaNA);
    wire isNaNB, isInfB, isZeroB, signB;
    wire signed [(expWidth + 1):0] sExpB;
    wire [sigWidth:0] sigB;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_b(b, isNaNB, isInfB, isZeroB, signB, sExpB, sigB);
    wire isSigNaNB;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_b(b, isSigNaNB);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire notSigNaN_invalidExc = (isInfA && isZeroB) || (isZeroA && isInfB);
    wire notNaN_isInfOut = isInfA || isInfB;
    wire notNaN_isZeroOut = isZeroA || isZeroB;
    wire notNaN_signOut = signA ^ signB;
    wire signed [(expWidth + 1):0] common_sExpOut =
        sExpA + sExpB - (1<<expWidth);
    wire [(sigWidth*2 - 1):0] common_sigOut = sigA * sigB;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    assign invalidExc = isSigNaNA || isSigNaNB || notSigNaN_invalidExc;
    assign out_isInf = notNaN_isInfOut;
    assign out_isZero = notNaN_isZeroOut;
    assign out_sExp = common_sExpOut;
assign out_isNaN = isNaNA || isNaNB;
    assign out_sign = notNaN_signOut;
    assign out_sig = common_sigOut;


endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    mulRecFNToRaw#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        output invalidExc,
        output out_isNaN,
        output out_isInf,
        output out_isZero,
        output out_sign,
        output signed [(expWidth + 1):0] out_sExp,
        output [(sigWidth + 2):0] out_sig
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaNA, isInfA, isZeroA, signA;
    wire signed [(expWidth + 1):0] sExpA;
    wire [sigWidth:0] sigA;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_a(a, isNaNA, isInfA, isZeroA, signA, sExpA, sigA);
    wire isSigNaNA;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_a(a, isSigNaNA);
    wire isNaNB, isInfB, isZeroB, signB;
    wire signed [(expWidth + 1):0] sExpB;
    wire [sigWidth:0] sigB;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_b(b, isNaNB, isInfB, isZeroB, signB, sExpB, sigB);
    wire isSigNaNB;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_b(b, isSigNaNB);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire notSigNaN_invalidExc = (isInfA && isZeroB) || (isZeroA && isInfB);
    wire notNaN_isInfOut = isInfA || isInfB;
    wire notNaN_isZeroOut = isZeroA || isZeroB;
    wire notNaN_signOut = signA ^ signB;
    wire signed [(expWidth + 1):0] common_sExpOut =
        sExpA + sExpB - (1<<expWidth);
    wire [(sigWidth*2 - 1):0] sigProd = sigA * sigB;
    wire [(sigWidth + 2):0] common_sigOut =
        {sigProd[(sigWidth*2 - 1):(sigWidth - 2)], |sigProd[(sigWidth - 3):0]};
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    assign invalidExc = isSigNaNA || isSigNaNB || notSigNaN_invalidExc;
    assign out_isInf = notNaN_isInfOut;
    assign out_isZero = notNaN_isZeroOut;
    assign out_sExp = common_sExpOut;
assign out_isNaN = isNaNA || isNaNB;
    assign out_sign = notNaN_signOut;
    assign out_sig = common_sigOut;


endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    mulRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        input [2:0] roundingMode,
        output [(expWidth + sigWidth):0] out,
        output [4:0] exceptionFlags
    );

    wire invalidExc, out_isNaN, out_isInf, out_isZero, out_sign;
    wire signed [(expWidth + 1):0] out_sExp;
    wire [(sigWidth + 2):0] out_sig;
    mulRecFNToRaw#(expWidth, sigWidth)
        mulRecFNToRaw(
            control,
            a,
            b,
            invalidExc,
            out_isNaN,
            out_isInf,
            out_isZero,
            out_sign,
            out_sExp,
            out_sig
        );
    roundRawFNToRecFN#(expWidth, sigWidth, 0)
        roundRawOut(
            control,
            invalidExc,
            1'b0,
            out_isNaN,
            out_isInf,
            out_isZero,
            out_sign,
            out_sExp,
            out_sig,
            roundingMode,
            out,
            exceptionFlags
        );

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    isSigNaNRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth):0] in, output isSigNaN
    );

    wire isNaN =
        (in[(expWidth + sigWidth - 1):(expWidth + sigWidth - 3)] == 'b111);
    assign isSigNaN = isNaN && !in[sigWidth - 2];

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    fNToRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth - 1):0] in,
        output [(expWidth + sigWidth):0] out
    );

/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

function integer clog2;
    input integer a;

    begin
        a = a - 1;
        for (clog2 = 0; a > 0; clog2 = clog2 + 1) a = a>>1;
    end

endfunction



    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam normDistWidth = clog2(sigWidth);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire sign;
    wire [(expWidth - 1):0] expIn;
    wire [(sigWidth - 2):0] fractIn;
    assign {sign, expIn, fractIn} = in;
    wire isZeroExpIn = (expIn == 0);
    wire isZeroFractIn = (fractIn == 0);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [(normDistWidth - 1):0] normDist;
    countLeadingZeros#(sigWidth - 1, normDistWidth)
        countLeadingZeros(fractIn, normDist);
    wire [(sigWidth - 2):0] subnormFract = (fractIn<<normDist)<<1;
    wire [expWidth:0] adjustedExp =
        (isZeroExpIn ? normDist ^ ((1<<(expWidth + 1)) - 1) : expIn)
            + ((1<<(expWidth - 1)) | (isZeroExpIn ? 2 : 1));
    wire isZero = isZeroExpIn && isZeroFractIn;
    wire isSpecial = (adjustedExp[expWidth:(expWidth - 1)] == 'b11);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [expWidth:0] exp;
    assign exp[expWidth:(expWidth - 2)] =
        isSpecial ? {2'b11, !isZeroFractIn}
            : isZero ? 3'b000 : adjustedExp[expWidth:(expWidth - 2)];
    assign exp[(expWidth - 3):0] = adjustedExp;
    assign out = {sign, exp, isZeroExpIn ? subnormFract : fractIn};

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    reverse#(parameter width = 1) (
        input [(width - 1):0] in, output [(width - 1):0] out
    );

    genvar ix;
    generate
        for (ix = 0; ix < width; ix = ix + 1) begin :Bit
            assign out[ix] = in[width - 1 - ix];
        end
    endgenerate

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    lowMaskHiLo#(
        parameter inWidth = 1,
        parameter topBound = 1,
        parameter bottomBound = 0
    ) (
        input [(inWidth - 1):0] in,
        output [(topBound - bottomBound - 1):0] out
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam numInVals = 1<<inWidth;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire signed [numInVals:0] c;
    assign c[numInVals] = 1;
    assign c[(numInVals - 1):0] = 0;
    wire [(topBound - bottomBound - 1):0] reverseOut =
        (c>>>in)>>(numInVals - topBound);
    reverse#(topBound - bottomBound) reverse(reverseOut, out);

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    lowMaskLoHi#(
        parameter inWidth = 1,
        parameter topBound = 0,
        parameter bottomBound = 1
    ) (
        input [(inWidth - 1):0] in,
        output [(bottomBound - topBound - 1):0] out
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam numInVals = 1<<inWidth;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire signed [numInVals:0] c;
    assign c[numInVals] = 1;
    assign c[(numInVals - 1):0] = 0;
    wire [(bottomBound - topBound - 1):0] reverseOut =
        (c>>>~in)>>(topBound + 1);
    reverse#(bottomBound - topBound) reverse(reverseOut, out);

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    countLeadingZeros#(parameter inWidth = 1, parameter countWidth = 1) (
        input [(inWidth - 1):0] in, output [(countWidth - 1):0] count
    );

    wire [(inWidth - 1):0] reverseIn;
    reverse#(inWidth) reverse_in(in, reverseIn);
    wire [inWidth:0] oneLeastReverseIn =
        {1'b1, reverseIn} & ({1'b0, ~reverseIn} + 1);
    genvar ix;
    generate
        for (ix = 0; ix <= inWidth; ix = ix + 1) begin :Bit
            wire [(countWidth - 1):0] countSoFar;
            if (ix == 0) begin
                assign countSoFar = 0;
            end else begin
                assign countSoFar =
                    Bit[ix - 1].countSoFar | (oneLeastReverseIn[ix] ? ix : 0);
                if (ix == inWidth) assign count = countSoFar;
            end
        end
    endgenerate

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    compressBy2#(parameter inWidth = 1) (
        input [(inWidth - 1):0] in, output [((inWidth - 1)/2):0] out
    );

    localparam maxBitNumReduced = (inWidth - 1)/2;
    genvar ix;
    generate
        for (ix = 0; ix < maxBitNumReduced; ix = ix + 1) begin :Bit
            assign out[ix] = |in[(ix*2 + 1):ix*2];
        end
    endgenerate
    assign out[maxBitNumReduced] = |in[(inWidth - 1):maxBitNumReduced*2];

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    compressBy4#(parameter inWidth = 1) (
        input [(inWidth - 1):0] in, output [(inWidth - 1)/4:0] out
    );

    localparam maxBitNumReduced = (inWidth - 1)/4;
    genvar ix;
    generate
        for (ix = 0; ix < maxBitNumReduced; ix = ix + 1) begin :Bit
            assign out[ix] = |in[(ix*4 + 3):ix*4];
        end
    endgenerate
    assign out[maxBitNumReduced] = |in[(inWidth - 1):maxBitNumReduced*4];

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/


/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define round_near_even   3'b000
`define round_minMag      3'b001
`define round_min         3'b010
`define round_max         3'b011
`define round_near_maxMag 3'b100
`define round_odd         3'b110

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define floatControlWidth 1
`define flControl_tininessBeforeRounding 1'b0
`define flControl_tininessAfterRounding  1'b1

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flRoundOpt_sigMSBitAlwaysZero  1
`define flRoundOpt_subnormsAlwaysExact 2
`define flRoundOpt_neverUnderflows     4
`define flRoundOpt_neverOverflows      8



/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flControl_default `flControl_tininessAfterRounding

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
//`define HardFloat_propagateNaNPayloads

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define HardFloat_signDefaultNaN 0
`define HardFloat_fractDefaultNaN(sigWidth) {1'b1, {((sigWidth) - 2){1'b0}}}



/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    recFNToRawFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth):0] in,
        output isNaN,
        output isInf,
        output isZero,
        output sign,
        output signed [(expWidth + 1):0] sExp,
        output [sigWidth:0] sig
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [expWidth:0] exp;
    wire [(sigWidth - 2):0] fract;
    assign {sign, exp, fract} = in;
    wire isSpecial = (exp>>(expWidth - 1) == 'b11);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    assign isNaN = isSpecial &&  exp[expWidth - 2];
    assign isInf = isSpecial && !exp[expWidth - 2];
    assign isZero = (exp>>(expWidth - 2) == 'b000);
    assign sExp = exp;
    assign sig = {1'b0, !isZero, fract};

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    roundAnyRawFNToRecFN#(
        parameter inExpWidth = 3,
        parameter inSigWidth = 3,
        parameter outExpWidth = 3,
        parameter outSigWidth = 3,
        parameter options = 0
    ) (
        input [(1 - 1):0] control,
        input invalidExc,     // overrides 'infiniteExc' and 'in_*' inputs
        input infiniteExc,    // overrides 'in_*' inputs except 'in_sign'
        input in_isNaN,
        input in_isInf,
        input in_isZero,
        input in_sign,
        input signed [(inExpWidth + 1):0] in_sExp,   // limited range allowed
        input [inSigWidth:0] in_sig,
        input [2:0] roundingMode,
        output [(outExpWidth + outSigWidth):0] out,
        output [4:0] exceptionFlags
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam sigMSBitAlwaysZero =
        ((options & 1) != 0);
    localparam effectiveInSigWidth =
        sigMSBitAlwaysZero ? inSigWidth : inSigWidth + 1;
    localparam neverUnderflows =
        ((options
              & (4
                     | 2))
             != 0)
            || (inExpWidth < outExpWidth);
    localparam neverOverflows =
        ((options & 8) != 0)
            || (inExpWidth < outExpWidth);
    localparam adjustedExpWidth =
          (inExpWidth < outExpWidth) ? outExpWidth + 1
        : (inExpWidth == outExpWidth) ? inExpWidth + 2
        : inExpWidth + 3;
    localparam outNaNExp = 7<<(outExpWidth - 2);
    localparam outInfExp = 6<<(outExpWidth - 2);
    localparam outMaxFiniteExp = outInfExp - 1;
    localparam outMinNormExp = (1<<(outExpWidth - 1)) + 2;
    localparam outMinNonzeroExp = outMinNormExp - outSigWidth + 1;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire roundingMode_near_even   = (roundingMode == 3'b000);
    wire roundingMode_minMag      = (roundingMode == 3'b001);
    wire roundingMode_min         = (roundingMode == 3'b010);
    wire roundingMode_max         = (roundingMode == 3'b011);
    wire roundingMode_near_maxMag = (roundingMode == 3'b100);
    wire roundingMode_odd         = (roundingMode == 3'b110);
    wire roundMagUp =
        (roundingMode_min && in_sign) || (roundingMode_max && !in_sign);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaNOut = invalidExc || (!infiniteExc && in_isNaN);
wire propagateNaNPayload = 0;

    wire signed [(adjustedExpWidth - 1):0] sAdjustedExp =
        in_sExp + ((1<<outExpWidth) - (1<<inExpWidth));
    wire [(outSigWidth + 2):0] adjustedSig;
    generate
        if (inSigWidth <= outSigWidth + 2) begin
            assign adjustedSig = in_sig<<(outSigWidth - inSigWidth + 2);
        end else begin
            assign adjustedSig =
                {in_sig[inSigWidth:(inSigWidth - outSigWidth - 1)],
                 |in_sig[(inSigWidth - outSigWidth - 2):0]};
        end
    endgenerate
    wire doShiftSigDown1 =
        sigMSBitAlwaysZero ? 0 : adjustedSig[outSigWidth + 2];
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [outExpWidth:0] common_expOut;
    wire [(outSigWidth - 2):0] common_fractOut;
    wire common_overflow, common_totalUnderflow, common_underflow;
    wire common_inexact;
    generate
        if (
            neverOverflows && neverUnderflows
                && (effectiveInSigWidth <= outSigWidth)
        ) begin
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            assign common_expOut = sAdjustedExp + doShiftSigDown1;
            assign common_fractOut =
                doShiftSigDown1 ? adjustedSig>>3 : adjustedSig>>2;
            assign common_overflow       = 0;
            assign common_totalUnderflow = 0;
            assign common_underflow      = 0;
            assign common_inexact        = 0;
        end else begin
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            wire [(outSigWidth + 2):0] roundMask;
            if (neverUnderflows) begin
                assign roundMask = {doShiftSigDown1, 2'b11};
            end else begin
                wire [outSigWidth:0] roundMask_main;
                lowMaskLoHi#(
                    outExpWidth + 1,
                    outMinNormExp - outSigWidth - 1,
                    outMinNormExp
                ) lowMask_roundMask(
                        sAdjustedExp[outExpWidth:0]
                            | (propagateNaNPayload ? 1'b1<<outExpWidth : 1'b0),
                        roundMask_main
                    );
                assign roundMask = {roundMask_main | doShiftSigDown1, 2'b11};
            end
            wire [(outSigWidth + 2):0] shiftedRoundMask = roundMask>>1;
            wire [(outSigWidth + 2):0] roundPosMask =
                ~shiftedRoundMask & roundMask;
            wire roundPosBit =
                (|(adjustedSig[(outSigWidth + 2):3]
                       & roundPosMask[(outSigWidth + 2):3]))
                    || ((|(adjustedSig[2:0] & roundPosMask[2:0]))
                            && !propagateNaNPayload);
            wire anyRoundExtra =
                (|(adjustedSig[(outSigWidth + 2):3]
                       & shiftedRoundMask[(outSigWidth + 2):3]))
                    || ((|(adjustedSig[2:0] & shiftedRoundMask[2:0]))
                            && !propagateNaNPayload);
            wire anyRound = roundPosBit || anyRoundExtra;
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            wire roundIncr =
                ((roundingMode_near_even || roundingMode_near_maxMag)
                     && roundPosBit)
                    || (roundMagUp && anyRound);
            wire [(outSigWidth + 1):0] roundedSig =
                roundIncr
                    ? (((adjustedSig | roundMask)>>2) + 1)
                          & ~(roundingMode_near_even && roundPosBit
                                  && !anyRoundExtra
                                  ? roundMask>>1 : 0)
                    : (adjustedSig & ~roundMask)>>2
                          | (roundingMode_odd && anyRound
                                 ? roundPosMask>>1 : 0);
            wire signed [adjustedExpWidth:0] sExtAdjustedExp = sAdjustedExp;
            wire signed [adjustedExpWidth:0] sRoundedExp =
                sExtAdjustedExp + (roundedSig>>outSigWidth);
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            assign common_expOut = sRoundedExp;
            assign common_fractOut =
                doShiftSigDown1 ? roundedSig>>1 : roundedSig;
            assign common_overflow =
                neverOverflows ? 0 : (sRoundedExp>>>(outExpWidth - 1) >= 3);
            assign common_totalUnderflow =
                neverUnderflows ? 0 : (sRoundedExp < outMinNonzeroExp);
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            wire unboundedRange_roundPosBit =
                doShiftSigDown1 ? adjustedSig[2] : adjustedSig[1];
            wire unboundedRange_anyRound =
                (doShiftSigDown1 && adjustedSig[2]) || (|adjustedSig[1:0]);
            wire unboundedRange_roundIncr =
                ((roundingMode_near_even || roundingMode_near_maxMag)
                     && unboundedRange_roundPosBit)
                    || (roundMagUp && unboundedRange_anyRound);
            wire roundCarry =
                doShiftSigDown1
                    ? roundedSig[outSigWidth + 1] : roundedSig[outSigWidth];
            assign common_underflow =
                neverUnderflows ? 0
                    : common_totalUnderflow
                          || (anyRound && (sAdjustedExp>>>outExpWidth <= 0)
                                  && (doShiftSigDown1
                                          ? roundMask[3] : roundMask[2])
                                  && !(((control
                                           & 1'b1)
                                            != 0)
                                           && !(doShiftSigDown1 ? roundMask[4]
                                                    : roundMask[3])
                                           && roundCarry && roundPosBit
                                           && unboundedRange_roundIncr));
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            assign common_inexact = common_totalUnderflow || anyRound;
        end
    endgenerate
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire notNaN_isSpecialInfOut = infiniteExc || in_isInf;
    wire commonCase = !isNaNOut && !notNaN_isSpecialInfOut && !in_isZero;
    wire overflow  = commonCase && common_overflow;
    wire underflow = commonCase && common_underflow;
    wire inexact = overflow || (commonCase && common_inexact);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire overflow_roundMagUp =
        roundingMode_near_even || roundingMode_near_maxMag || roundMagUp;
    wire pegMinNonzeroMagOut =
        commonCase && common_totalUnderflow
            && (roundMagUp || roundingMode_odd);
    wire pegMaxFiniteMagOut = overflow && !overflow_roundMagUp;
    wire notNaN_isInfOut =
        notNaN_isSpecialInfOut || (overflow && overflow_roundMagUp);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
wire signOut = isNaNOut ? 0 : in_sign;

    wire [outExpWidth:0] expOut =
        (common_expOut
             & ~(in_isZero || common_totalUnderflow ? 7<<(outExpWidth - 2) : 0)
             & ~(pegMinNonzeroMagOut               ? ~outMinNonzeroExp    : 0)
             & ~(pegMaxFiniteMagOut                ? 1<<(outExpWidth - 1) : 0)
             & ~(notNaN_isInfOut                   ? 1<<(outExpWidth - 2) : 0))
            | (pegMinNonzeroMagOut ? outMinNonzeroExp : 0)
            | (pegMaxFiniteMagOut  ? outMaxFiniteExp  : 0)
            | (notNaN_isInfOut     ? outInfExp        : 0)
            | (isNaNOut            ? outNaNExp        : 0);
wire [(outSigWidth - 2):0] fractOut =
          (isNaNOut ? {1'b1, {((outSigWidth) - 2){1'b0}}} : 0)
        | (!in_isZero && !common_totalUnderflow
               ? common_fractOut & {1'b1, {((outSigWidth) - 2){1'b0}}} : 0)
        | (!isNaNOut && !in_isZero && !common_totalUnderflow
               ? common_fractOut & ~{1'b1, {((outSigWidth) - 2){1'b0}}}
               : 0)
        | {(outSigWidth - 1){pegMaxFiniteMagOut}};

    assign out = {signOut, expOut, fractOut};
    assign exceptionFlags =
        {invalidExc, infiniteExc, overflow, underflow, inexact};

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    roundRawFNToRecFN#(
        parameter expWidth = 3,
        parameter sigWidth = 3,
        parameter options = 0
    ) (
        input [(1 - 1):0] control,
        input invalidExc,     // overrides 'infiniteExc' and 'in_*' inputs
        input infiniteExc,    // overrides 'in_*' inputs except 'in_sign'
        input in_isNaN,
        input in_isInf,
        input in_isZero,
        input in_sign,
        input signed [(expWidth + 1):0] in_sExp,   // limited range allowed
        input [(sigWidth + 2):0] in_sig,
        input [2:0] roundingMode,
        output [(expWidth + sigWidth):0] out,
        output [4:0] exceptionFlags
    );

    roundAnyRawFNToRecFN#(expWidth, sigWidth + 2, expWidth, sigWidth, options)
        roundAnyRawFNToRecFN(
            control,
            invalidExc,
            infiniteExc,
            in_isNaN,
            in_isInf,
            in_isZero,
            in_sign,
            in_sExp,
            in_sig,
            roundingMode,
            out,
            exceptionFlags
        );

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/


/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define round_near_even   3'b000
`define round_minMag      3'b001
`define round_min         3'b010
`define round_max         3'b011
`define round_near_maxMag 3'b100
`define round_odd         3'b110

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define floatControlWidth 1
`define flControl_tininessBeforeRounding 1'b0
`define flControl_tininessAfterRounding  1'b1

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flRoundOpt_sigMSBitAlwaysZero  1
`define flRoundOpt_subnormsAlwaysExact 2
`define flRoundOpt_neverUnderflows     4
`define flRoundOpt_neverOverflows      8



/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flControl_default `flControl_tininessAfterRounding

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
//`define HardFloat_propagateNaNPayloads

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define HardFloat_signDefaultNaN 0
`define HardFloat_fractDefaultNaN(sigWidth) {1'b1, {((sigWidth) - 2){1'b0}}}



/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    addRecFNToRaw#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input subOp,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        input [2:0] roundingMode,
        output invalidExc,
        output out_isNaN,
        output out_isInf,
        output out_isZero,
        output out_sign,
        output signed [(expWidth + 1):0] out_sExp,
        output [(sigWidth + 2):0] out_sig
    );

/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

function integer clog2;
    input integer a;

    begin
        a = a - 1;
        for (clog2 = 0; a > 0; clog2 = clog2 + 1) a = a>>1;
    end

endfunction



    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam alignDistWidth = clog2(sigWidth);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaNA, isInfA, isZeroA, signA;
    wire signed [(expWidth + 1):0] sExpA;
    wire [sigWidth:0] sigA;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_a(a, isNaNA, isInfA, isZeroA, signA, sExpA, sigA);
    wire isSigNaNA;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_a(a, isSigNaNA);
    wire isNaNB, isInfB, isZeroB, signB;
    wire signed [(expWidth + 1):0] sExpB;
    wire [sigWidth:0] sigB;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_b(b, isNaNB, isInfB, isZeroB, signB, sExpB, sigB);
    wire effSignB = subOp ? !signB : signB;
    wire isSigNaNB;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_b(b, isSigNaNB);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire eqSigns = (signA == effSignB);
    wire notEqSigns_signZero = (roundingMode == 3'b010) ? 1 : 0;
    wire signed [(expWidth + 1):0] sDiffExps = sExpA - sExpB;
    wire [(alignDistWidth - 1):0] modNatAlignDist =
        (sDiffExps < 0) ? sExpB - sExpA : sDiffExps;
    wire isMaxAlign =
        (sDiffExps>>>alignDistWidth != 0)
            && ((sDiffExps>>>alignDistWidth != -1)
                    || (sDiffExps[(alignDistWidth - 1):0] == 0));
    wire [(alignDistWidth - 1):0] alignDist =
        isMaxAlign ? (1<<alignDistWidth) - 1 : modNatAlignDist;
    wire closeSubMags = !eqSigns && !isMaxAlign && (modNatAlignDist <= 1);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire signed [(sigWidth + 2):0] close_alignedSigA =
          ((0 <= sDiffExps) &&  sDiffExps[0] ? sigA<<2 : 0)
        | ((0 <= sDiffExps) && !sDiffExps[0] ? sigA<<1 : 0)
        | ((sDiffExps < 0)                   ? sigA    : 0);
    wire signed [(sigWidth + 2):0] close_sSigSum =
        close_alignedSigA - (sigB<<1);
    wire [(sigWidth + 1):0] close_sigSum =
        (close_sSigSum < 0) ? -close_sSigSum : close_sSigSum;
    wire [(sigWidth + 1 + (sigWidth & 1)):0] close_adjustedSigSum =
        close_sigSum<<(sigWidth & 1);
    wire [(sigWidth + 1)/2:0] close_reduced2SigSum;
    compressBy2#(sigWidth + 2 + (sigWidth & 1))
        compressBy2_close_sigSum(close_adjustedSigSum, close_reduced2SigSum);
    wire [(alignDistWidth - 1):0] close_normDistReduced2;
    countLeadingZeros#((sigWidth + 3)/2, alignDistWidth)
        countLeadingZeros_close(close_reduced2SigSum, close_normDistReduced2);
    wire [(alignDistWidth - 1):0] close_nearNormDist =
        close_normDistReduced2<<1;
    wire [(sigWidth + 2):0] close_sigOut =
        (close_sigSum<<close_nearNormDist)<<1;
    wire close_totalCancellation =
        !(|close_sigOut[(sigWidth + 2):(sigWidth + 1)]);
    wire close_notTotalCancellation_signOut = signA ^ (close_sSigSum < 0);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire far_signOut = (sDiffExps < 0) ? effSignB : signA;
    wire [(sigWidth - 1):0] far_sigLarger  = (sDiffExps < 0) ? sigB : sigA;
    wire [(sigWidth - 1):0] far_sigSmaller = (sDiffExps < 0) ? sigA : sigB;
    wire [(sigWidth + 4):0] far_mainAlignedSigSmaller =
        {far_sigSmaller, 5'b0}>>alignDist;
    wire [(sigWidth + 1)/4:0] far_reduced4SigSmaller;
    compressBy4#(sigWidth + 2)
        compressBy4_far_sigSmaller(
            {far_sigSmaller, 2'b00}, far_reduced4SigSmaller);
    wire [(sigWidth + 1)/4:0] far_roundExtraMask;
    lowMaskHiLo#(alignDistWidth - 2, (sigWidth + 5)/4, 0)
        lowMask_far_roundExtraMask(
            alignDist[(alignDistWidth - 1):2], far_roundExtraMask);
    wire [(sigWidth + 2):0] far_alignedSigSmaller =
        {far_mainAlignedSigSmaller>>3,
         (|far_mainAlignedSigSmaller[2:0])
             || (|(far_reduced4SigSmaller & far_roundExtraMask))};
    wire far_subMags = !eqSigns;
    wire [(sigWidth + 3):0] far_negAlignedSigSmaller =
        far_subMags ? {1'b1, ~far_alignedSigSmaller}
            : {1'b0, far_alignedSigSmaller};
    wire [(sigWidth + 3):0] far_sigSum =
        (far_sigLarger<<3) + far_negAlignedSigSmaller + far_subMags;
    wire [(sigWidth + 2):0] far_sigOut =
        far_subMags ? far_sigSum : far_sigSum>>1 | far_sigSum[0];
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire notSigNaN_invalidExc = isInfA && isInfB && !eqSigns;
    wire notNaN_isInfOut = isInfA || isInfB;
    wire addZeros = isZeroA && isZeroB;
    wire notNaN_specialCase = notNaN_isInfOut || addZeros;
    wire notNaN_isZeroOut =
        addZeros
            || (!notNaN_isInfOut && closeSubMags && close_totalCancellation);
    wire notNaN_signOut =
           (eqSigns                      && signA              )
        || (isInfA                       && signA              )
        || (isInfB                       && effSignB           )
        || (notNaN_isZeroOut && !eqSigns && notEqSigns_signZero)
        || (!notNaN_specialCase && closeSubMags && !close_totalCancellation
                                        && close_notTotalCancellation_signOut)
        || (!notNaN_specialCase && !closeSubMags && far_signOut);
    wire signed [(expWidth + 1):0] common_sExpOut =
        (closeSubMags || (sDiffExps < 0) ? sExpB : sExpA)
            - (closeSubMags ? close_nearNormDist : far_subMags);
    wire [(sigWidth + 2):0] common_sigOut =
        closeSubMags ? close_sigOut : far_sigOut;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    assign invalidExc = isSigNaNA || isSigNaNB || notSigNaN_invalidExc;
    assign out_isInf = notNaN_isInfOut;
    assign out_isZero = notNaN_isZeroOut;
    assign out_sExp = common_sExpOut;
assign out_isNaN = isNaNA || isNaNB;
    assign out_sign = notNaN_signOut;
    assign out_sig = common_sigOut;


endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    addRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input subOp,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        input [2:0] roundingMode,
        output [(expWidth + sigWidth):0] out,
        output [4:0] exceptionFlags
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire invalidExc, out_isNaN, out_isInf, out_isZero, out_sign;
    wire signed [(expWidth + 1):0] out_sExp;
    wire [(sigWidth + 2):0] out_sig;
    addRecFNToRaw#(expWidth, sigWidth)
        addRecFNToRaw(
            control,
            subOp,
            a,
            b,
            roundingMode,
            invalidExc,
            out_isNaN,
            out_isInf,
            out_isZero,
            out_sign,
            out_sExp,
            out_sig
        );
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    roundRawFNToRecFN#(expWidth, sigWidth, 2)
        roundRawOut(
            control,
            invalidExc,
            1'b0,
            out_isNaN,
            out_isInf,
            out_isZero,
            out_sign,
            out_sExp,
            out_sig,
            roundingMode,
            out,
            exceptionFlags
        );

endmodule

