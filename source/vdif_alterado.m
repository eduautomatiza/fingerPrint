debug=1;

if debug == 1
    nPoints= 5;
    nLinks = 4;
    plane  = 10;
    x=[1 9 6 10 1];
    y=[6 3 9 2 5];
else
    nPoints= 30;
    nLinks = 5;
    plane  = 1024;
    x=randi(plane,1,nPoints);
    y=randi(plane,1,nPoints);
end
mx=matDif(x);
my=matDif(y);

% Calcula os angulos relativos a cada pontos em relação aos outros
% e as distancias de cada ponto com os outros pontos
[angles,distAbs] = cart2pol(mx,my);
angles = rem(angles+2*pi,2*pi); % e força angulos positivos;

%distAbs = sqrt((mx.*mx)+(my.*my));
[~ , indexDist] = sort(distAbs, 2);
points=indexDist(:,2:nLinks+1);

%angles = atan2(my,mx)+2*pi;
%angles = rem(angles,2*pi);
ax=repmat(2*pi,nPoints,nPoints);
for c=1:nPoints
    ax(c,points(c,:))=angles(c,points(c,:));
end
[~ , angleDist] = sort(ax, 2);
points2=angleDist(:,1:nLinks);


%cria os pontos das cordenadas na figura, em camadas(3D)
figure(1);
scatter3(x,y,(1:nPoints));
axis([0 plane+1 0 plane+1]);

% traça as linha entre os pontos mais mais proximos
for cp = 1:nPoints
    px=[x(cp) 0 ];
    py=[y(cp) 0];
    text(px(1), py(1),cp,num2str(cp));
    color=rand(1,3);
    for cl=1:nLinks
        px(2)=x(points(cp,cl));
        py(2)=y(points(cp,cl));
        line(px,py,[cp points(cp,cl)],'Color',color);
    end
end


for cp = 1:1%nPoints
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
        text(px(2), py(2),points2(cp,cl),num2str(cl));
    end
end

%print(mx,my);

% Alterado

% criado points3 para não mexer em points2, mas se funcionar será retirado
points3 = zeros(nPoints, nLinks, 5);
points3(:,:,1) = points2;

for i = 1:nPoints
    %separado só para melhor entender os testes
    for j = 1:nLinks
        k = j + 1;
        % necessário para calcular a distância entre o último ponto e o
        % primeiro
        if k > nLinks
           k = 1; 
        end
        point1 = points3(i,j,1);
        point2 = points3(i,k,1);
        % Pega o ângulo próximo ponto e diminui do atual
        % ex: segundo menor ângulo menos o menor ângulo 
        angulo1 = rem(...
            abs(angles(i,point2) - angles(i,point1))...
                ,pi);
        % Pega o ângulo do ponto analisado em relação ao primeiro ponto, e
        % subtrai do ângulo do segundo ponto também em relação ao primeiro
        % ponto.
        angulo2 = rem(...
            abs(angles(point1,i) - angles(point1, point2))...
                ,pi);
        % Guarda na dimensão Z os valores para cada ângulo e a distância do
        % vetor entre o ponto analisado e o primeiro ponto
        points3(i,j,2:end) = [angulo1 angulo2 distAbs(i,point1) distAbs(point1,point2)];
    end
    
end


% Figura com triangulação completa entre os pontos mais próximos
% "Identica" a anterior, separada apenas para manter a integridade do código
% original
for cp = 1:nPoints
    figure(cp+2+nPoints);
    scatter3(x,y,(1:nPoints));
    axis([0 plane+1 0 plane+1]);
    color=rand(1,3);
    color2=abs([1 1 1]-color);
    for cl=1:nLinks
        pFim=points2(cp,cl);
        line([x(cp) x(pFim)],[y(cp) y(pFim)],[cp pFim],'color',color);
        text( x(pFim), y(pFim),pFim,num2str(cl));
        if cl == nLinks 
            pInicio = points2(cp,1);
        else
            pInicio =points2(cp,cl+1);        
        end
            % Identifica as coordenadas atualmente ligadas
        line([x(pInicio) x(pFim)],[y(pInicio) y(pFim)],[pInicio pFim],'color',color2);
    end
end