// Implementation of the register file
module regfile (
    input logic clk,
    reset,
    input logic we3,
    input logic [4:0] ra1,
    ra2,
    wa3,
    input logic [31:0] wd3,
    output logic [31:0] rd1,
    rd2,
    reg_v0
);

  reg [31:0] rf[32];

  integer i;

  always @(posedge clk) begin
    if (reset) begin  //sets all the regs in the regfile to 0 is reset signal is high
      for (i = 0; i < 32; i = i + 1) begin
        rf[i] <= 32'b0;
      end
    end else begin
      if (we3) rf[wa3] <= wd3;
    end
  end

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
  assign reg_v0 = rf[2];
endmodule


module delay_slot_register (
    input logic clk,
    reset,
    clk_enable,
    input logic [31:0] d,
    output logic [31:0] q
);


  always @(negedge reset) begin
    q <= 32'hBFC00004;
  end

  always_ff @(posedge clk) begin
    if (reset) begin  //sets all the regs in the regfile to 0 is reset signal is high
      q <= 0;
    end else begin
      if (clk_enable) q <= d;
    end
  end
endmodule


module mux2 #(
    parameter WIDTH = 32
) (
    input logic [WIDTH - 1:0] a,
    b,
    input logic s,
    output logic [WIDTH - 1:0] y
);

  assign y = s ? b : a;
endmodule


module adder (
    input  logic [31:0] a,
    b,
    output logic [31:0] y
);

  assign y = a + b;
endmodule


module shiftleft2 (
    input  logic [31:0] a,
    output logic [31:0] y
);

  assign y = {{a[29:0]}, 2'b00};
endmodule


module shiftleft16 (
    input  logic [31:0] a,
    output logic [31:0] y
);

  assign y = {{a[15:0]}, 16'b0};
endmodule


module signext (
    input logic [15:0] a,
    input logic selector,
    output logic [31:0] y
);

  always @(*) begin
    if (selector) begin
      y = {16'b0, a};
    end else begin
      y = {{16{a[15]}}, a};
    end
  end
endmodule


module pc_register (
    input logic clk,
    reset,
    clk_enable,
    output logic active,
    input logic [31:0] d,
    output logic [31:0] q
);

  always @(negedge reset) begin
    active = 1'b1;
    q = 32'hBFC00000;
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      q <= 32'b0;
    end else if (clk_enable) begin
      if (d == 32'b0) active <= 0;
      q <= d;
    end
  end

endmodule
