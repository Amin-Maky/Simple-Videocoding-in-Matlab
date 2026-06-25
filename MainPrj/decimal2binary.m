function [ bin ]  = decimal2binary(dec,n)

bin = zeros(1,52);
i=0;
if dec==0
    bin=0;
    i = 1;
end

while dec>0 || i<n
    
    temp = fix(dec/2);
    remainder = dec - temp * 2;
    dec = temp;
    i = i+1;
    bin(i) = remainder;
    
end

bin = bin(i:-1:1);