% Approximate with best fit
pitch = -30:1:30;
roll  = -30:1:30;

% Recall   1 -> -90 deg
%         61 -> -30 deg
%         91 ->   0 deg
%        121 ->  30 deg
%        181 ->  90 deg
data = map1(61:121,61:121);
% Now      1 -> -30 deg
%         31 ->   0 deg
%         61 ->  30 deg

figure(3)
surf(pitch,roll,data);
daspect([1 1 1]);

% Find best plane fit.
[X,Y]=meshgrid(pitch,roll);
[A,B,C]=plane_fit(X(:),Y(:),data(:)); 

Z=(A*X)+(B*Y)+C;
plot3(X(:),Y(:),data(:),'r.'); hold on; grid on;
surf(X,Y,Z,'FaceColor','g'); alpha(0.5);
title(['A=',num2str(A),', B=',num2str(B),', C=',num2str(C)]);
daspect([1 1 1]);

errors = data - Z;
figure(5)
imagesc(abs(errors));
figure(6)
surf(pitch,roll,abs(errors));
title(['Max error: ',num2str(max(max(errors)))])
