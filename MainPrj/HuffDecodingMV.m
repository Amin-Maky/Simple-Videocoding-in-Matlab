function [ mvh mvv length ] = HuffDecodingMV( MVBits )


[ mvh l ] = table_mv_dec( MVBits(  1:min(  13,end) ) );
length = l;
[ mvv l ]=  table_mv_dec( MVBits(l+1:min(l+13,end) ) );
length = length + l;