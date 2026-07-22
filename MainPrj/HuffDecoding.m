function [ RunSymbols length ] =  HuffDecoding(DCTBits)%%,Mode


persistent LRLB
if isempty(LRLB)
    LRLB = lrl_table_dec;
end


% % ind = 1; % indicator
% % RunSymbols = [];%RunSymbols



% % % Intra: Mode=1  ;  Inter: Mode=0  ;
% % if Mode==1
% %     % INTRADC :
% %     LEVEL = binary2decimal( DCTBits(1:8) );
% %     RunSymbols = [ 0 0 LEVEL];
% %     ind = 9;
% % end

if DCTBits(1)==1
    RunSymbols = [1 0 0];
    LAST = 1;
    RUN = 0;
    ind = 2;
else
    LAST = 0;
    
    ind = 2;
    % DC :
    LEVEL = binary2decimal( DCTBits(ind:ind+7) );
    if DCTBits(ind+8)==1
        LEVEL = -LEVEL;
    end
    if LEVEL==255
        LEVEL = 128;
    end%
    RunSymbols = [ 0 0 LEVEL];
    ind = ind+9;
end




% AC :
% LAST = 0;

while LAST==0
    
index = 0; % FOR ERROR REPORTING!!!
    if DCTBits(ind)==0  %[0xxx xxxx xxxx]
        if DCTBits(ind+1)==0  %[00xx xxxx xxxx]
            if DCTBits(ind+2)==0  %[000x xxxx xxxx]
                if DCTBits(ind+3)==0  %[0000 xxxx xxxx]
                    if DCTBits(ind+4)==0  %[0000 0xxx xxxx]
                        if DCTBits(ind+5)==0  %[0000 00xx xxxx]
                            if DCTBits(ind+6)==0  %[0000 000x xxxx]
                                if DCTBits(ind+7)==0  %[0000 0000 xxxx]
                                    if DCTBits(ind+8)==1
                                        index = 1+2*DCTBits(ind+9) +DCTBits(ind+10);
                                    end
                                else  %[0000 0001 xxxx]
                                    index = 5+2*DCTBits(ind+8) +DCTBits(ind+9);
                                end
                            else  %[0000 001x xxxx]
                                if DCTBits(ind+7)==0%[0000 0010 xxxx]
                                    index = 9+2*DCTBits(ind+8) +DCTBits(ind+9);
                                else%[0000 0011 xxxx]
                                    index = 13+2*DCTBits(ind+8) +DCTBits(ind+9);
                                end
                            end
                        else  %[0000 01xx xxxx]
                            if DCTBits(ind+6)==0%[0000 010x xxxx]
                                if DCTBits(ind+7)==0%[0000 0100 xxxx]
                                    if DCTBits(ind+8)==0%[0000 0100 0xxx]
                                        index = 17+2*DCTBits(ind+9) +DCTBits(ind+10);
                                    else%[0000 0100 1xxx]
                                        index = 21+2*DCTBits(ind+9) +DCTBits(ind+10);
                                    end
                                else%[0000 0101 ??xx]
                                    index = 25 + 8*DCTBits(ind+8) + 4*DCTBits(ind+9)+2*DCTBits(ind+10) +DCTBits(ind+11);
                                end
                            else%[0000 011x xxxx]
                                index = 41; %ESCAPE CODE!
                            end
                        end
                    else  %[0000 1xxx xxxx]
                       if DCTBits(ind+5)==0%[0000 10xx xxxx]
                           if DCTBits(ind+6)==0%[0000 100x xxxx]
                               if DCTBits(ind+7)==0%[0000 1000 xxxx]
                                   if DCTBits(ind+8)==0%[0000 1000 0?xx]
                                       index = 42 + DCTBits(ind+9);
                                   else%[0000 1000 1xxx]
                                       index = 44;
                                   end
                               else%[0000 1001 ?xxx]
                                   index = 45 + DCTBits(ind+8);
                               end
                           else%[0000 101x xxxx]
                               index = 47+2*DCTBits(ind+7) +DCTBits(ind+8);
                           end
                       else%[0000 11?x xxxx]
                           index = 51 + 4* DCTBits(ind+6)+2*DCTBits(ind+7) +DCTBits(ind+8);
                       end
                    end
                else  %[0001 xxxx xxxx]
                   if DCTBits(ind+4)==0%[0001 0xxx xxxx]
                       if DCTBits(ind+5)==0%[0001 00xx xxxx]
                           if DCTBits(ind+6)==0%[0001 000x xxxx]
                               index = 59+2*DCTBits(ind+7) +DCTBits(ind+8);
                           else%[0001 001x xxxx]
                               if DCTBits(ind+7)==0%[0001 0010 ?xxx]
                                   index = 63 + DCTBits(ind+8);
                               else%[0001 0011 xxxx]
                                   index = 65;
                               end
                           end
                       else%[0001 01xx xxxx]
                           index = 66+2*DCTBits(ind+6) +DCTBits(ind+7);
                       end
                   else%[0001 1?xx xxxx]
                       index = 70 + 4*DCTBits(ind+5)+2*DCTBits(ind+6) +DCTBits(ind+7);
                   end
                end
            else  %[001x xxxx xxxx]
                if DCTBits(ind+3)==0%[0010 ?xxx xxxx]
                    index = 78 + 4*DCTBits(ind+4)+2*DCTBits(ind+5) +DCTBits(ind+6);                    
                else%[0011 xxxx xxxx]
                    index = 86+2*DCTBits(ind+4) +DCTBits(ind+5);
                end
            end
        else  %[01xx xxxx xxxx]
            if DCTBits(ind+2)==0%[010x xxxx xxxx]
                if DCTBits(ind+3)==0%[0100 xxxx xxxx]
                    index = 90+2*DCTBits(ind+4) +DCTBits(ind+5);
                else%[0101 xxxx xxxx]
                    if DCTBits(ind+4)==0%[0101 0?xx xxxx]
                        index = 94 + DCTBits(ind+5);
                    else%[0101 1xxx xxxx]
                        index = 96;
                    end
                end
            else%[011x xxxx xxxx]
                if DCTBits(ind+3)==0%[0110 ?xxx xxxx]
                    index = 97 + DCTBits(ind+4);
                else%[0111 xxxx xxxx]
                    index = 99;
                end
            end
        end
    else  %[1xxx xxxx xxxx]
        if DCTBits(ind+1)==0%[10xx xxxx xxxx]
            index = 100;
        else%[11xx xxxx xxxx]
            if DCTBits(ind+2)==0%[110x xxxx xxxx]
                index = 101;
            else%[111? xxxx xxxx]
                index = 102 + DCTBits(ind+3);
            end
        end
    end
    

    
    if index==41%ESCAPE CODE!
% %         ind = ind + 7;
% %         LAST = DCTBits(ind);
% %         ind = ind + 1;
% %         RUN = DCTBits(ind:ind+5);
% %         ind = ind + 6;
% %         LEVEL = DCTBits(ind:ind+8);
% %         ind = ind + 8;
        LAST  = DCTBits(ind+7);
        RUN   = binary2decimal(DCTBits(ind+8:ind+13));
        if DCTBits(ind+14)==1
            LEVEL = -binary2decimal(~DCTBits(ind+14:ind+21))-1;
        else
            LEVEL = binary2decimal(DCTBits(ind+14:ind+21));
        end
        
        ind = ind + 22;
        
    else
        ind = ind + LRLB(index,4); % ind = ind + bitlenght-of-VLC

        LAST = LRLB(index,1);
        RUN = LRLB(index,2);
        LEVEL = LRLB(index,3);
        if DCTBits(ind-1)==1 % s==1
            LEVEL = -LEVEL;
        end
    end
    

    
    RunSymbols = [ RunSymbols; LAST RUN LEVEL; ];
    
end

if LAST && RUN==63
    RunSymbols = [ 1 0 RunSymbols(1,3) ] ;
end


length = ind-1;



























% % % % % % function [ RunSymbols length ] =  HuffmanDecodingDCT(DCTBits)%%,Mode
% % % % % % 
% % % % % % 
% % % % % % persistent LRLB
% % % % % % if isempty(LRLB)
% % % % % %     LRLB = lrl_table_dec;
% % % % % % end
% % % % % % 
% % % % % % 
% % % % % % RunSymbols = zeros(64,3);
% % % % % % RS_counter = 0;% RunSymbols Counter!
% % % % % % 
% % % % % % % % ind = 1; % indicator
% % % % % % % % RunSymbols = [];%RunSymbols
% % % % % % 
% % % % % % 
% % % % % % 
% % % % % % % % % Intra: Mode=1  ;  Inter: Mode=0  ;
% % % % % % % % if Mode==1
% % % % % % % %     % INTRADC :
% % % % % % % %     LEVEL = binary2decimal( DCTBits(1:8) );
% % % % % % % %     RunSymbols = [ 0 0 LEVEL];
% % % % % % % %     ind = 9;
% % % % % % % % end
% % % % % % 
% % % % % % 
% % % % % % % DC :
% % % % % % LEVEL = binary2decimal( DCTBits(1:8) );
% % % % % % if DCTBits(9)==1
% % % % % %     LEVEL = -LEVEL;
% % % % % % end
% % % % % % if LEVEL==255
% % % % % %     LEVEL = 128;
% % % % % % end%
% % % % % % RS_counter = RS_counter+1;
% % % % % % RunSymbols(RS_counter,:) = [ 0 0 LEVEL];
% % % % % % ind = 10;
% % % % % % 
% % % % % % 
% % % % % % % AC :
% % % % % % LAST = 0;
% % % % % % 
% % % % % % while LAST==0
% % % % % %     
% % % % % % index = 0; % FOR ERROR REPORTING!!!
% % % % % %     if DCTBits(ind)==0  %[0xxx xxxx xxxx]
% % % % % %         if DCTBits(ind+1)==0  %[00xx xxxx xxxx]
% % % % % %             if DCTBits(ind+2)==0  %[000x xxxx xxxx]
% % % % % %                 if DCTBits(ind+3)==0  %[0000 xxxx xxxx]
% % % % % %                     if DCTBits(ind+4)==0  %[0000 0xxx xxxx]
% % % % % %                         if DCTBits(ind+5)==0  %[0000 00xx xxxx]
% % % % % %                             if DCTBits(ind+6)==0  %[0000 000x xxxx]
% % % % % %                                 if DCTBits(ind+7)==0  %[0000 0000 xxxx]
% % % % % %                                     if DCTBits(ind+8)==1
% % % % % %                                         index = 1+2*DCTBits(ind+9) +DCTBits(ind+10);
% % % % % %                                     end
% % % % % %                                 else  %[0000 0001 xxxx]
% % % % % %                                     index = 5+2*DCTBits(ind+8) +DCTBits(ind+9);
% % % % % %                                 end
% % % % % %                             else  %[0000 001x xxxx]
% % % % % %                                 if DCTBits(ind+7)==0%[0000 0010 xxxx]
% % % % % %                                     index = 9+2*DCTBits(ind+8) +DCTBits(ind+9);
% % % % % %                                 else%[0000 0011 xxxx]
% % % % % %                                     index = 13+2*DCTBits(ind+8) +DCTBits(ind+9);
% % % % % %                                 end
% % % % % %                             end
% % % % % %                         else  %[0000 01xx xxxx]
% % % % % %                             if DCTBits(ind+6)==0%[0000 010x xxxx]
% % % % % %                                 if DCTBits(ind+7)==0%[0000 0100 xxxx]
% % % % % %                                     if DCTBits(ind+8)==0%[0000 0100 0xxx]
% % % % % %                                         index = 17+2*DCTBits(ind+9) +DCTBits(ind+10);
% % % % % %                                     else%[0000 0100 1xxx]
% % % % % %                                         index = 21+2*DCTBits(ind+9) +DCTBits(ind+10);
% % % % % %                                     end
% % % % % %                                 else%[0000 0101 ??xx]
% % % % % %                                     index = 25 + 8*DCTBits(ind+8) + 4*DCTBits(ind+9)+2*DCTBits(ind+10) +DCTBits(ind+11);
% % % % % %                                 end
% % % % % %                             else%[0000 011x xxxx]
% % % % % %                                 index = 41; %ESCAPE CODE!
% % % % % %                             end
% % % % % %                         end
% % % % % %                     else  %[0000 1xxx xxxx]
% % % % % %                        if DCTBits(ind+5)==0%[0000 10xx xxxx]
% % % % % %                            if DCTBits(ind+6)==0%[0000 100x xxxx]
% % % % % %                                if DCTBits(ind+7)==0%[0000 1000 xxxx]
% % % % % %                                    if DCTBits(ind+8)==0%[0000 1000 0?xx]
% % % % % %                                        index = 42 + DCTBits(ind+9);
% % % % % %                                    else%[0000 1000 1xxx]
% % % % % %                                        index = 44;
% % % % % %                                    end
% % % % % %                                else%[0000 1001 ?xxx]
% % % % % %                                    index = 45 + DCTBits(ind+8);
% % % % % %                                end
% % % % % %                            else%[0000 101x xxxx]
% % % % % %                                index = 47+2*DCTBits(ind+7) +DCTBits(ind+8);
% % % % % %                            end
% % % % % %                        else%[0000 11?x xxxx]
% % % % % %                            index = 51 + 4* DCTBits(ind+6)+2*DCTBits(ind+7) +DCTBits(ind+8);
% % % % % %                        end
% % % % % %                     end
% % % % % %                 else  %[0001 xxxx xxxx]
% % % % % %                    if DCTBits(ind+4)==0%[0001 0xxx xxxx]
% % % % % %                        if DCTBits(ind+5)==0%[0001 00xx xxxx]
% % % % % %                            if DCTBits(ind+6)==0%[0001 000x xxxx]
% % % % % %                                index = 59+2*DCTBits(ind+7) +DCTBits(ind+8);
% % % % % %                            else%[0001 001x xxxx]
% % % % % %                                if DCTBits(ind+7)==0%[0001 0010 ?xxx]
% % % % % %                                    index = 63 + DCTBits(ind+8);
% % % % % %                                else%[0001 0011 xxxx]
% % % % % %                                    index = 65;
% % % % % %                                end
% % % % % %                            end
% % % % % %                        else%[0001 01xx xxxx]
% % % % % %                            index = 66+2*DCTBits(ind+6) +DCTBits(ind+7);
% % % % % %                        end
% % % % % %                    else%[0001 1?xx xxxx]
% % % % % %                        index = 70 + 4*DCTBits(ind+5)+2*DCTBits(ind+6) +DCTBits(ind+7);
% % % % % %                    end
% % % % % %                 end
% % % % % %             else  %[001x xxxx xxxx]
% % % % % %                 if DCTBits(ind+3)==0%[0010 ?xxx xxxx]
% % % % % %                     index = 78 + 4*DCTBits(ind+4)+2*DCTBits(ind+5) +DCTBits(ind+6);                    
% % % % % %                 else%[0011 xxxx xxxx]
% % % % % %                     index = 86+2*DCTBits(ind+4) +DCTBits(ind+5);
% % % % % %                 end
% % % % % %             end
% % % % % %         else  %[01xx xxxx xxxx]
% % % % % %             if DCTBits(ind+2)==0%[010x xxxx xxxx]
% % % % % %                 if DCTBits(ind+3)==0%[0100 xxxx xxxx]
% % % % % %                     index = 90+2*DCTBits(ind+4) +DCTBits(ind+5);
% % % % % %                 else%[0101 xxxx xxxx]
% % % % % %                     if DCTBits(ind+4)==0%[0101 0?xx xxxx]
% % % % % %                         index = 94 + DCTBits(ind+5);
% % % % % %                     else%[0101 1xxx xxxx]
% % % % % %                         index = 96;
% % % % % %                     end
% % % % % %                 end
% % % % % %             else%[011x xxxx xxxx]
% % % % % %                 if DCTBits(ind+3)==0%[0110 ?xxx xxxx]
% % % % % %                     index = 97 + DCTBits(ind+4);
% % % % % %                 else%[0111 xxxx xxxx]
% % % % % %                     index = 99;
% % % % % %                 end
% % % % % %             end
% % % % % %         end
% % % % % %     else  %[1xxx xxxx xxxx]
% % % % % %         if DCTBits(ind+1)==0%[10xx xxxx xxxx]
% % % % % %             index = 100;
% % % % % %         else%[11xx xxxx xxxx]
% % % % % %             if DCTBits(ind+2)==0%[110x xxxx xxxx]
% % % % % %                 index = 101;
% % % % % %             else%[111? xxxx xxxx]
% % % % % %                 index = 102 + DCTBits(ind+3);
% % % % % %             end
% % % % % %         end
% % % % % %     end
% % % % % %     
% % % % % % 
% % % % % %     
% % % % % %     if index==41%ESCAPE CODE!
% % % % % % % %         ind = ind + 7;
% % % % % % % %         LAST = DCTBits(ind);
% % % % % % % %         ind = ind + 1;
% % % % % % % %         RUN = DCTBits(ind:ind+5);
% % % % % % % %         ind = ind + 6;
% % % % % % % %         LEVEL = DCTBits(ind:ind+8);
% % % % % % % %         ind = ind + 8;
% % % % % %         LAST  = DCTBits(ind+7);
% % % % % %         RUN   = binary2decimal(DCTBits(ind+8:ind+13));
% % % % % %         if DCTBits(ind+14)==1
% % % % % %             LEVEL = -binary2decimal(~DCTBits(ind+14:ind+21))-1;
% % % % % %         else
% % % % % %             LEVEL = binary2decimal(DCTBits(ind+14:ind+21));
% % % % % %         end
% % % % % %         
% % % % % %         ind = ind + 22;
% % % % % %         
% % % % % %     else
% % % % % %         ind = ind + LRLB(index,4); % ind = ind + bitlenght-of-VLC
% % % % % % 
% % % % % %         LAST = LRLB(index,1);
% % % % % %         RUN = LRLB(index,2);
% % % % % %         LEVEL = LRLB(index,3);
% % % % % %         if DCTBits(ind-1)==1 % s==1
% % % % % %             LEVEL = -LEVEL;
% % % % % %         end
% % % % % %     end
% % % % % %     
% % % % % % 
% % % % % %     RS_counter = RS_counter+1;
% % % % % %     RunSymbols(RS_counter,:) = [ LAST RUN LEVEL ];
% % % % % %     
% % % % % % end
% % % % % % 
% % % % % % RunSymbols =  RunSymbols(1:RS_counter,:);
% % % % % % if LAST && LEVEL==0
% % % % % %     RunSymbols = [ 1 0 RunSymbols(1,3) ] ;
% % % % % % end
% % % % % % 
% % % % % % 
% % % % % % length = ind-1;