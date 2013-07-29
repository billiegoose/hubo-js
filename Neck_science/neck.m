clear; clc; close all;
% COORDINATE SYSTEM
% +X is robot's forward
% +Y is robot's left
% +Z is robot's up
reset_neck_coordinates

% Set up view
view(7, 14);
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

pitch_range = -45:1:45; %-90:1:90;
roll_range = -45:1:45;

pitch_offset = find(pitch_range==0);
roll_offset = find(roll_range==0);

rindex = 0;
pindex = 0;
for pindex = 1:length(pitch_range)
    % Create pitch matrix
    p = pitch_range(pindex)*pi/180;
    PT = makehgtform('yrotate',p);
    PT = PT(1:3, 1:3);
for rindex = 1:length(roll_range)
    % Create roll matrix
    r = roll_range(rindex)*pi/180;
    RT = makehgtform('xrotate',r);
    RT = RT(1:3, 1:3);

    % Apply pitch transform. Then roll transform. To the tips of the linear
    % actuators.
    neck1tip_point = RT*PT*neck1tip_point_orig;
    neck2tip_point = RT*PT*neck2tip_point_orig;
    
    % Store for plotting

    
    % Compute vector of linear actuator
    neck1(:,pindex,rindex) = neck1tip_point - neck1base_point;
    neck2(:,pindex,rindex) = neck2tip_point - neck2base_point;
    
    % Plot neck
    if mod(pindex,10)==0
        if mod(rindex,10)==0
            figure(1)
            cla
            draw_neck
            % Plot surface of reachable area
            i = i + 1;
            nk1(:,i) = neck1tip_point;
            nk2(:,i) = neck2tip_point;        
            line(nk1(1,:),nk1(2,:),nk1(3,:))
            line(nk2(1,:),nk2(2,:),nk2(3,:))
        %     pause(0.05)
        end
    end
end
    % Insert discontinuities in the plotted lines
    i = i + 1;
    nk1(:,i) = NaN;
    nk2(:,i) = NaN;
end

% Compute lengths of vectors
map1 = squeeze(sqrt(sum(neck1.^2)));
map2 = squeeze(sqrt(sum(neck2.^2)));

save('map1.mat','map1')
save('map2.mat','map2')
save('pitch_range.mat','pitch_range')
save('roll_range.mat','roll_range')




