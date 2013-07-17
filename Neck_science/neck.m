clear; clc; close all;
% God what am I getting myself into
% COORDINATE SYSTEM
% +X is robot's forward
% +Y is robot's left
% +Z is robot's up
reset_neck_coordinates

% Set up view
view(26, 42);
axis([-30 30 -30 30 -100 30])
daspect([1 1 1])
xlabel('X')
ylabel('Y')
zlabel('Z')

% Create rotations
i = 0;
nk1 = [0;0;0];
nk2 = [0;0;0];
for rd = -90:10:90
    r = rd*pi/180;
    RT = makehgtform('xrotate',r);
for pd = -90:90
    reset_neck_coordinates
    i = i + 1;
    p = pd*pi/180;
    PT = makehgtform('yrotate',p);
    T = PT*RT;
    T2 = RT*PT;
    assert('T==T2')
    T = T(1:3, 1:3);
    nk1(:,i) = T*neck1tip_point;
    nk2(:,i) = T*neck2tip_point;
    neck1tip_point = nk1(:,i);
    neck2tip_point = nk2(:,i);
    
    figure(1)
    cla
    draw_neck
    line(nk1(1,:),nk1(2,:),nk1(3,:))
    line(nk2(1,:),nk2(2,:),nk2(3,:))
%     pause(0.05)
end
    i = i + 1;
    nk1(:,i) = NaN;
    nk2(:,i) = NaN;
end
