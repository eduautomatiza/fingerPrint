function ret=matDifxy(x)
npontos=length(x);
xl=ones(npontos);
xc=xl;
for i = 1:npontos
    xl(i,:)=x;
    xc(:,i)=x';
end
ret=xl-xc;

