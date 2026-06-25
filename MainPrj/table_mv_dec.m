function [ mvx length ] = table_mv_dec( CD )


if CD(1)==1
    mvx=0;
    length=1;
elseif all( CD(1:4)==[0 0 1 0] )
    mvx=1;
    length=4;
elseif all( CD(1:4)==[0 0 1 1] )
    mvx=-1;
    length=4;
elseif all( CD(1:7)==[0 0 0 0 1 1 0] )
    mvx=2;
    length=7;
elseif all( CD(1:7)==[0 0 0 0 1 1 1] )
    mvx=-2;
    length=7;
elseif all( CD(1:8)==[0 0 0 0 1 0 0 0] )
    mvx=3;
    length=8;
elseif all( CD(1:8)==[0 0 0 0 1 0 0 1] )
    mvx=-3;
    length=8;
elseif all( CD(1:10)==[0 0 0 0 0 1 0 0 1 0] )
    mvx=5;
    length=10;
elseif all( CD(1:10)==[0 0 0 0 0 1 0 0 1 1] )
    mvx=-5;
    length=10;
elseif all( CD(1:10)==[0 0 0 0 0 1 0 1 1 0] )
    mvx=4;
    length=10;
elseif all( CD(1:10)==[0 0 0 0 0 1 0 1 1 1] )
    mvx=-4;
    length=10;
elseif all( CD(1:11)==[0 0 0 0 0 1 0 0 0 0 0] )
    mvx=6;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 1 1 1 0 0] )
    mvx=7;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 1 1 0 0 0] )
    mvx=8;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 1 0 1 0 0] )
    mvx=9;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 1 0 0 0 0] )
    mvx=10;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 0 1 1 0 0] )
    mvx=11;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 0 1 0 0 0] )
    mvx=12;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 1 0 0 0 0 1] )
    mvx=-6;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 1 1 1 0 1] )
    mvx=-7;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 1 1 0 0 1] )
    mvx=-8;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 1 0 1 0 1] )
    mvx=-9;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 1 0 0 0 1] )
    mvx=-10;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 0 1 1 0 1] )
    mvx=-11;
    length=11;
elseif all( CD(1:11)==[0 0 0 0 0 0 0 1 0 0 1] )
    mvx=-12;
    length=11;
elseif all( CD(1:12)==[0 0 0 0 0 0 0 0 1 0 0 0] )
    mvx=13;
    length=12;
elseif all( CD(1:12)==[0 0 0 0 0 0 0 0 1 1 0 0] )
    mvx=14;
    length=12;
elseif all( CD(1:12)==[0 0 0 0 0 0 0 0 0 1 0 0] )
    mvx=15;
    length=12;
elseif all( CD(1:12)==[0 0 0 0 0 0 0 0 1 1 0 1] )
    mvx=-13;
    length=12;
elseif all( CD(1:12)==[0 0 0 0 0 0 0 0 1 0 0 1] )
    mvx=-14;
    length=12;
elseif all( CD(1:12)==[0 0 0 0 0 0 0 0 0 1 0 1] )
    mvx=-15;
    length=12;
elseif all( CD(1:13)==[0 0 0 0 0 0 0 0 0 0 1 0 1] )
    mvx=-16;
    length=13;
end