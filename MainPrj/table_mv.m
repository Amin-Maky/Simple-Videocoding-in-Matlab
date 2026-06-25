function CD = table_mv( mvx )


if mvx==-16
    CD=[0 0 0 0 0 0 0 0 0 0 1 0 1];
elseif mvx==-15
    CD=[0 0 0 0 0 0 0 0 0 1 0 1];
elseif mvx==-14
    CD=[0 0 0 0 0 0 0 0 1 0 0 1];
elseif mvx==-13
    CD=[0 0 0 0 0 0 0 0 1 1 0 1];
elseif mvx==-12
    CD=[0 0 0 0 0 0 0 1 0 0 1];
elseif mvx==-11
    CD=[0 0 0 0 0 0 0 1 1 0 1];
elseif mvx==-10
    CD=[0 0 0 0 0 0 1 0 0 0 1];
elseif mvx==-9
    CD=[0 0 0 0 0 0 1 0 1 0 1];
elseif mvx==-8
    CD=[0 0 0 0 0 0 1 1 0 0 1];
elseif mvx==-7
    CD=[0 0 0 0 0 0 1 1 1 0 1];
elseif mvx==-6
    CD=[0 0 0 0 0 1 0 0 0 0 1];
elseif mvx==-5
    CD=[0 0 0 0 0 1 0 0 1 1];
elseif mvx==-4
    CD=[0 0 0 0 0 1 0 1 1 1];
elseif mvx==-3
    CD=[0 0 0 0 1 0 0 1];
elseif mvx==-2
    CD=[0 0 0 0 1 1 1];
elseif mvx==-1
    CD=[0 0 1 1];
elseif mvx==0
    CD=1;
elseif mvx==1
    CD=[0 0 1 0];
elseif mvx==2
    CD=[0 0 0 0 1 1 0];
elseif mvx==3
    CD=[0 0 0 0 1 0 0 0];
elseif mvx==4
    CD=[0 0 0 0 0 1 0 1 1 0];
elseif mvx==5
    CD=[0 0 0 0 0 1 0 0 1 0];
elseif mvx==6
    CD=[0 0 0 0 0 1 0 0 0 0 0];
elseif mvx==7
    CD=[0 0 0 0 0 0 1 1 1 0 0];
elseif mvx==8
    CD=[0 0 0 0 0 0 1 1 0 0 0];
elseif mvx==9
    CD=[0 0 0 0 0 0 1 0 1 0 0];
elseif mvx==10
    CD=[0 0 0 0 0 0 1 0 0 0 0];
elseif mvx==11
    CD=[0 0 0 0 0 0 0 1 1 0 0];
elseif mvx==12
    CD=[0 0 0 0 0 0 0 1 0 0 0];
elseif mvx==13
    CD=[0 0 0 0 0 0 0 0 1 0 0 0];
elseif mvx==14
    CD=[0 0 0 0 0 0 0 0 1 1 0 0];
elseif mvx==15
    CD=[0 0 0 0 0 0 0 0 0 1 0 0];
else
    CD=[]; % For 'I' frames
end

CD=logical(CD);