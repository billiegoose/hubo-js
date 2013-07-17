% [x,y]=meshgrid(pitch,roll);
% z=data(:);
% x=x(:); y=y(:); z=z(:);
% [A,B,C]=plane_fit(x,y,z); 
% [X,Y]=meshgrid(linspace(min(x),max(x),20),linspace(min(y),max(y),20));
% Z=(A*X)+(B*Y)+C;
% plot3(x,y,z,'r.'); hold on; grid on;
% surf(X,Y,Z,'FaceColor','g'); alpha(0.5);
% title(['a=',num2str(a), ', A=',num2str(A),', b=',num2str(b),', B=',num2str(B),', c=',num2str(c),', C=',num2str(C)]);

[X,Y]=meshgrid(pitch,roll);
[A,B,C]=plane_fit(X(:),Y(:),data(:)); 

Z=(A*X)+(B*Y)+C;
plot3(X(:),Y(:),data(:),'r.'); hold on; grid on;
surf(X,Y,Z,'FaceColor','g'); alpha(0.5);
title(['A=',num2str(A),', B=',num2str(B),', C=',num2str(C)]);