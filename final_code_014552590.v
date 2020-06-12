module fpadd();

real num1 = 37.5;
real num2 = -78.25;
real n1, n2, n3, n4, num3, n5;
real add, mul, m1, m2, m3, m4; 
  
reg sign_num1, sign_num2, sign_add, sign_mult;
  reg [7:0] exp_num1, exp_num2, true_exp1, true_exp2, difference, exp_add, exp_mult, true_exp_mult;
  reg [22:0] frac_num1, frac_num2, frac_add, frac_mult;
  reg [5:0] frac1_buff;
  reg [7:0] frac2_buff;
  reg [24:0] num1_buff, num2_buff; 
  reg [31:0] num1_bin, num2_bin, bin_add, mult_final;
  reg [25:0] sum;
  reg [9:0] ban;
  reg [13:0] frac1_mult;
  
integer i, j;

initial begin
  $dumpfile("add.vcd");
  $dumpvars;
end 

initial begin
  $display("                          ");
  $display("                          ");
  $display("                          ");
  $display("IEE754 ADDITION START");
  add = (num1 + num2);
  sign_num1 = 1'b0;
  sign_num2 = 1'b1;
  num3 = (0 - num2);
  $display("num1 = %f, num2 = %f, num3 = %f, sign_num1 = %b, sign_num2 = %b", num1, num2, num3, sign_num1, sign_num2); 

  exp_num1 = 5;
  exp_num2 = 6;
  true_exp1 = (exp_num1 + 127);
  true_exp2 = (exp_num2 + 127);
  n1 = ((num1)/(2**exp_num1));
  n2 = ((num3)/(2**exp_num2));
  $display("true_exp1 = %d, true_exp2 = %d, n1 = %f, n2 = %f", true_exp1, true_exp2, n1, n2);
  $display("true_exp1 = %b, true_exp2 = %b", true_exp1, true_exp2);
  n3 = (n1-1);
  n4 = (n2-1);
  $display("n3 = %f, n4 = %f", n3, n4);
  for(i = 5; i >= 0 ; i = i-1)
    begin
      n3 = n3*2;
      if(n3 == 1)
        begin
          frac1_buff[i] = 1'b1;
        end
      else if(n3 > 1)
        begin
          n5 = (n3 - 1);
          frac1_buff[i] = 1'b1;
          n3 = n5;
        end
      else
        begin
          n5 = n3;
          frac1_buff[i] = 1'b0;
          n3 = n5;
        end
    end
  frac_num1 = {frac1_buff, 17'b0};
  for(i = 7; i >= 0 ; i = i-1)
    begin
      n4 = n4*2;
      if(n4 == 1)
        begin
          frac2_buff[i] = 1'b1;
        end
      else if(n4 > 1)
        begin
          n5 = (n4 - 1);
          frac2_buff[i] = 1'b1;
          n4 = n5;
        end
      else
        begin
          n5 = n4;
          frac2_buff[i] = 1'b0;
          n4 = n5;
        end
    end
  frac_num2 = {frac2_buff, 15'b0} ;
  $display("frac_num1 = %b, frac_num2 = %b", frac_num1, frac_num2);
  num1_bin = {sign_num1, true_exp1, frac_num1};
  num2_bin = {sign_num2, true_exp2, frac_num2};
  $display("IEEE754 of num1 in hexadecimal(%h) in binary(%b)", num1_bin, num1_bin);
  $display("IEEE754 of num2 in hexadecimal(%h) in binary(%b)", num2_bin, num2_bin);
  num1_buff = {sign_num1, 1'b1, frac_num1};
  num2_buff = {sign_num2, 1'b1, frac_num2};
  $display("num1_buff = %b", num1_buff);
  $display("num2_buff = %b", num2_buff);
  if(exp_num1>exp_num2)
    begin
      difference = (exp_num1 - exp_num2);
      num2_buff = num2_buff >> difference;
      exp_add = (true_exp1 - difference);
    end
  else
    begin
      difference = (exp_num2 - exp_num1);
      num1_buff = num1_buff >> difference;
      exp_add = (true_exp2 - difference);
    end
  $display("difference = %b", difference);
  $display("num1_buff = %b, num2_buff = %b, exp_add = %b", num1_buff, num2_buff,
           exp_add);
  if(num2 < 0)
    begin
      num2_buff = ((~num2_buff) + 1'b1);
    end
    $display("num1_buff = %b, num2_buff = %b", num1_buff, num2_buff);
  
  sum = (num1_buff + num2_buff);
  $display("sum = %b ", sum);
  sum = ((~sum) + 1'b1);
  sum = sum[24:0];
  $display("sum = %b ", sum[24:0]);
  sign_add = sum[24];
  frac_add = sum[22:0];
  $display("frac_add_old = %b ", frac_add);
  while(frac_add[22] == 1'b1 )
    begin 
      frac_add = frac_add << 1;
    end
  if(frac_add[22] == 1'b0) 
    begin
      frac_add = frac_add;
    end
  $display("sign_add = %b, frac_add = %b", sign_add, frac_add);
  bin_add = {sign_add, exp_add, frac_add};
  $display("Addition of both numbers = %f", add);
  $display("IEEE754 of addition hexadecimal(%h) in binary(%b) ", bin_add, bin_add);
  $display("IEEE754 ADDITION ENDS HERE");
  $display("                          ");
  $display("                          ");
  $display("                          ");
  $display("IEEE754 MULTIPLICATION START");
  mul = (num1*num2);
  m1 = (num1*num3);
  exp_mult = (exp_num1 + exp_num2);
  m2 = ((m1)/(2**exp_mult));
  m3 = (m2 - 1);
  $display("m1 = %f, m2 = %f, m3 = %f", m1, m2, m3);
  for(i = 13; i >= 0 ; i = i-1)
    begin
      m3 = m3*2;
      if(m3 == 1)
        begin
          frac1_mult[i] = 1'b1;
        end
      else if(m3 > 1)
        begin
          m4 = (m3 - 1);
          frac1_mult[i] = 1'b1;
          m3 = m4;
        end
      else
        begin
          m4 = m3;
          frac1_mult[i] = 1'b0;
          m3 = m4;
        end
    end
  frac_mult = {frac1_mult, 9'b0};
  true_exp_mult = (exp_mult + 127);
  sign_mult = (sign_num1^sign_num2);
  $display("sign_mult = %b, exp_mult = %b, frac_mult = %b", sign_mult, true_exp_mult
           , frac_mult);
  mult_final = {sign_mult, true_exp_mult, frac_mult};
  $display("Multiplication of both number = %f", mul);
  $display("IEEE754 of multiplication in Hexadecimal(%h) in binary(%b)", mult_final, 
          mult_final);
  $display("IEEE754 MULTIPLICATION CODE ENDS HERE");
  $display("                          ");
  $display("                          ");
  $display("                          ");
end 
  
  



endmodule 