
nPoints=10;
nLinks=9;
plane=1024;

x=randi(plane,1,nPoints);
y=randi(plane,1,nPoints);
%x=[1 9 6 10 1];
%y=[6 3 9 2 5];

mx=matDif(x);
my=matDif(y);

[lixo , indexDist] = sort((mx.^2)+(my.^2), 2);

points=indexDist(:,2:nLinks+1);

%cria os pontos das cordenadas na figura, em camadas(3D)
figure(1);
scatter3(x,y,(1:nPoints));
axis([0 plane+1 0 plane+1]);

% traça as linha entre os pontos mais mais proximos
for cp = 1:nPoints
    px=[x(cp) 0 ];
    py=[y(cp) 0];
    color=rand(1,3);
    for cl=1:nLinks
        px(2)=x(points(cp,cl));
        py(2)=y(points(cp,cl));
        line(px,py,[cp points(cp,cl)],'Color',color);
    end
end

% Calcula os angulos relativos a cada pontos em relação aos outros
% e força angulos positivos;

angles = atan2(my,mx)+2*pi;
angles = rem(angles,2*pi);

ax=repmat(2*pi,nPoints,nPoints);
for c=1:nPoints
    ax(c,points(c,:))=angles(c,points(c,:));
end

[lixo, angleDist] = sort(ax, 2);

points2=angleDist(:,1:nLinks);

for cp = 1:nPoints
    figure(cp+1);
    scatter3(x,y,(1:nPoints));
    axis([0 plane+1 0 plane+1]);
    px=[x(cp) 0 ];
    py=[y(cp) 0];
    color=rand(1,3);
    for cl=1:nLinks
        px(2)=x(points2(cp,cl));
        py(2)=y(points2(cp,cl));
        line(px,py,[cp points2(cp,cl)],'color',color);
        text(px(2), py(2),num2str(cl));
    end
end

%print(mx,my);

