clear; clc; close all;
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
neck1 = zeros(3,1,1);
neck2 = zeros(3,1,1);

pitch_range = -90:1:90;
roll_range = -90:1:90;

for rd = roll_range %-90:1:90
    ridx = rd + 91;
    r = rd*pi/180;
    RT = makehgtform('xrotate',r);
for pd = pitch_range %-90:1:90
    pidx = pd + 91;
    reset_neck_coordinates
    i = i + 1;
    p = pd*pi/180;
    PT = makehgtform('yrotate',p);
    T = PT*RT;
    T2 = RT*PT;
    % assert(T==T2) Well, shucks.
    T = T(1:3, 1:3);
    nk1(:,i) = T*neck1tip_point;
    nk2(:,i) = T*neck2tip_point;
    neck1tip_point = nk1(:,i);
    neck2tip_point = nk2(:,i);
    
    neck1(:,pidx,ridx) = neck1tip_point - neck1base_point;
    neck2(:,pidx,ridx) = neck2tip_point - neck2base_point;
    
%     figure(1)
%     cla
%     draw_neck
%     line(nk1(1,:),nk1(2,:),nk1(3,:))
%     line(nk2(1,:),nk2(2,:),nk2(3,:))
%     pause(0.05)
end
    i = i + 1;
    nk1(:,i) = NaN;
    nk2(:,i) = NaN;
end

% Compute lengths of vectors
map1 = squeeze(sqrt(neck1(1,:,:).^2 + neck1(2,:,:).^2 + neck1(3,:,:).^2));
map2 = squeeze(sqrt(neck2(1,:,:).^2 + neck2(2,:,:).^2 + neck2(3,:,:).^2));

save('map1.mat','map1')
save('map2.mat','map2')
save('pitch_range.mat','pitch_range')
save('roll_range.mat','roll_range')




