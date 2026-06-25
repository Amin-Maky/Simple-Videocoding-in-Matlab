function WriteFrame(Frame,outfile)

% addframe(outfile,Frame);
% Y :
fwrite(outfile,Frame','uint8');

% Cr & Cb :
CrCb = repmat(128,size(Frame)/2);
fwrite(outfile,CrCb','uint8');
fwrite(outfile,CrCb','uint8');