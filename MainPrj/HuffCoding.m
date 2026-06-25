function [ DCTBits ] =  HuffCoding(RunSymbols)%%,Mode
% global Mode

persistent LRL VLC
if isempty(LRL) || isempty(VLC)
    LRL=lrl_table();
    VLC=vlc_table();
end



% % % Intra: Mode=1  ;  Inter: Mode=0  ;
% % if Mode==1
% %     % INTRADC :
% %     k = 2;
% %     DC = RunSymbols(1,3);
% %     if DC==0
% %         DC = 1;
% %     end
% %     DCTBits = decimal2binary( DC,8 );
% %     if all(DCTBits == [1 0 0 0 0 0 0 0])
% %         DCTBits = [1 1 1 1 1 1 1 1];
% %     end
% % else
% %     k = 1;
% %     DCTBits = [];
% % end



s=0;%
k = 2;%
DC = RunSymbols(1,3);%
% if DC==0%
%     DC = 1;%
% end%
if DC<0%
    s = 1;%
    DC = -DC;
end%
DCTBits = decimal2binary( DC,8 );%
if all(DCTBits == [1 0 0 0 0 0 0 0])%
    DCTBits = [1 1 1 1 1 1 1 1];%
end%
DCTBits = [DCTBits s];%
if RunSymbols(1,1)==1% all AC==0!!!
%     FLC_LAST  = [ 1 ];%
%     FLC_RUN   = [ 1 1 1 1 1 1 ]; % Fix lenghth code for RUN%
%     FLC_LEVEL = [ 0 0 0 0 0 0 0 0 ]; % Fix lenghth code for LEVEL%

  % DCTBits=[DCTBits    ESCAPE_CODE   LAST    FLC_RUN         FLC_LEVEL ]%
    DCTBits=[DCTBits   0 0 0 0 0 1 1   1   1 1 1 1 1 1    0 0 0 0 0 0 0 0];%
end%

if all(RunSymbols(1,:) == [1 0 0])
    DCTBits = 1; % DC =0 and AC(:)=0
    k = inf;
else
    DCTBits = [0 DCTBits];
end


% TCOEF :
        for k=k:size(RunSymbols,1)
            
            valid_huffman = false;
            word = RunSymbols(k,:);
            if word(1,3)<0
                s=1;
                word(1,3) = -word(1,3);
            else
                s=0;
            end

            if word(1,1)==0 % LAST = 0
                if     word(1,3)==1 && word(1,2)<27
                    DCTBits = [ DCTBits VLC{word(1,2)+1} s ];
                    valid_huffman = true;
                elseif word(1,3)==2 && word(1,2)<11
                    DCTBits = [ DCTBits VLC{word(1,2)+28} s ];
                    valid_huffman = true;
                elseif word(1,3)==3 && word(1,2)<7
                    DCTBits = [ DCTBits VLC{word(1,2)+39} s ];
                    valid_huffman = true;
                elseif word(1,2)<3
                    for i=46:58
                        if word==LRL(i,:)
                            DCTBits = [ DCTBits VLC{i} s ];
                            valid_huffman = true;
                            break;
                        end
                    end
                end
            else        % LAST = 1
                if word(1,3)==1 && word(1,2)<41
                    DCTBits = [ DCTBits VLC{word(1,2)+59} s ];
                    valid_huffman = true;
                elseif all(word==[1 0 2])
                    DCTBits = [ DCTBits VLC{100} s ];
                    valid_huffman = true;
                elseif all(word==[1 1 2])
                    DCTBits = [ DCTBits VLC{101} s ];
                    valid_huffman = true;
                elseif all(word==[1 0 3])
                    DCTBits = [ DCTBits VLC{102} s ];
                    valid_huffman = true;
                end
            end
            
            

            if ~valid_huffman
                FLC_RUN = decimal2binary( word(1,2),6 ); % Fix lenghth code for RUN
                if s==0
                    FLC_LEVEL = decimal2binary( word(1,3),8 ); % Fix lenghth code for LEVEL
                else
                    FLC_LEVEL = ~decimal2binary( word(1,3)-1,8 ); % Fix lenghth code for LEVEL
                end
                
                % DCTBits = [ DCTBits ESCAPE_CODE LAST FLC_RUN FLC_LEVEL ]
                DCTBits=[DCTBits 0 0 0 0 0 1 1 word(1,1) FLC_RUN FLC_LEVEL];
            end
            
        end
    
DCTBits = logical(DCTBits);