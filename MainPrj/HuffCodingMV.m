function [ MVBits ] = HuffCodingMV( mvh, mvv )

MVBits = [ table_mv( mvh ) table_mv( mvv ) ];