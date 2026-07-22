function [ dec ]  = binary2decimal(bin)

dec = 0;
n = size(bin,2);
temp = 1;

for i=n:-1:1
    dec = dec + bin(i) * temp;
    temp = temp*2;  % temp = 2^(i-1) !
end