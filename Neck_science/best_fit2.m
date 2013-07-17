close all
% Approximate with best fit
pitch = -30:1:30;
roll  = -30:1:30;

% Recall   1 -> -90 deg
%         61 -> -30 deg
%         91 ->   0 deg
%        121 ->  30 deg
%        181 ->  90 deg
data1 = map1(61:121,61:121);
data2 = map2(61:121,61:121);
% Now      1 -> -30 deg
%         31 ->   0 deg
%         61 ->  30 deg

x = data1(:);
y = data2(:);
figure(1)
[Zp,Zr]=meshgrid(pitch,roll);
[Ap,Bp,Cp]=plane_fit(x,y,Zp(:)); 
plot3(x,y,Zp(:),'r.'); hold on; grid on;
z=(Ap*x)+(Bp*y)+Cp;
plot3(x,y,z,'g.');
daspect([1 1 1])
pbaspect([1 1 1])
title('Pitch')
xlabel('NK1'); ylabel('NK2')
figure(2)
errors = Zp(:) - z;
plot3(x,y,abs(errors),'.');
title(['Max pitch error: ',num2str(max(errors)), ' deg'])
xlabel('NK1'); ylabel('NK2')

figure(3)
[Ar,Br,Cr]=plane_fit(x,y,Zr(:));
plot3(x,y,Zr(:),'r.'); hold on; grid on;
z=(Ar*x)+(Br*y)+Cr;
plot3(x,y,z,'g.');
daspect([1 1 1])
pbaspect([1 1 1])
title('Roll')
xlabel('NK1'); ylabel('NK2')
figure(4)
errors = Zr(:) - z;
plot3(x,y,abs(errors),'.');
title(['Max roll error: ',num2str(max(errors)), ' deg'])
xlabel('NK1'); ylabel('NK2')