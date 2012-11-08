function ret=matDif(x)
%#codegen
coder.inline('never')

ret=repmat(x,length(x),1);
ret=ret-ret.';