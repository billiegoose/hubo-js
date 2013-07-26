clear; clc; close all;

load('map1.mat')
load('map2.mat')
load('pitch_range.mat')
load('roll_range.mat')

% Note: the stroke is 19.3mm
% The range is ~ 85-105mm so that's what we'll consider
map1(map1(:)<85) = 0;
map2(map2(:)<85) = 0;
map1(map1(:)>105) = 0;
map2(map2(:)>105) = 0;

% It only makes sense to consider pitch,roll tuples that are achievable by
% both linear actuators.
mask = map1 & map2;
map1(~mask) = 0;
map2(~mask) = 0;
imagesc(map1);
% Well, look at that! It's nearly a square diamond.

% Let's crop it.
T = logical(map1);
STATS = regionprops(T, 'BoundingBox');
minP = ceil(STATS.BoundingBox(1));
minR = ceil(STATS.BoundingBox(2));
maxP = minP + floor(STATS.BoundingBox(3))-1;
maxR = minR + floor(STATS.BoundingBox(4))-1;
data1 = map1(minR:maxR, minP:maxP);
data2 = map2(minR:maxR, minP:maxP);
line([minP-0.5 maxP+0.5 maxP+0.5 minP-0.5 minP-0.5],[minR-0.5 minR-0.5 maxR+0.5 maxR+0.5 minR-0.5],'Color','k');
imagesc(data1);
pitch_range = pitch_range(minP:maxP);
roll_range = roll_range(minR:maxR);

% T = logical(map2);
% STATS = regionprops(T, 'BoundingBox');
% minP = ceil(STATS.BoundingBox(1));
% minR = ceil(STATS.BoundingBox(2));
% maxP = minP + floor(STATS.BoundingBox(3))-1;
% maxR = minR + floor(STATS.BoundingBox(4))-1;
% data2 = map2(minR:maxR, minP:maxP);
% pitch_range2 = pitch_range(minP:maxP);
% roll_range2 = roll_range(minR:maxR);
% line([minP-0.5 maxP+0.5 maxP+0.5 minP-0.5 minP-0.5],[minR-0.5 minR-0.5 maxR+0.5 maxR+0.5 minR-0.5],'Color','k');
% imagesc(data2);
% The range of pitch and roll should be the same because they are
% symmetrical.
% assert(all(pitch_range1==pitch_range2));
% assert(all(roll_range1==roll_range2));
% pitch_range = pitch_range1;
% roll_range = roll_range1;
% clear pitch_range1 pitch_range2 roll_range1 roll_range2 
% Collect points to plot
NK1 = data1(:);
NK2 = data2(:);
[Zp,Zr]=meshgrid(pitch_range,roll_range);
Zp = Zp(:);
Zr = Zr(:);
% Get rid of invalid points
mask = NK1 > 0;
NK1 = NK1(mask);
NK2 = NK2(mask);
Zp = Zp(mask);
Zr = Zr(mask);

% Plot in 3D
figure(2)
plot3(NK1,NK2,Zp(:),'r.'); hold on; grid on;
daspect([1 1 1])
pbaspect([1 1 1])
title('Pitch')
xlabel('NK1'); ylabel('NK2')

figure(3)
plot3(NK1,NK2,Zr(:),'r.'); hold on; grid on;
daspect([1 1 1])
pbaspect([1 1 1])
title('Roll')
xlabel('NK1'); ylabel('NK2')

% Now cheat and use cftool
[fitresult, gof] = createFit(NK1, NK2, Zp);
pP = coeffvalues(fitresult)
[fitresult, gof] = createFit(NK1, NK2, Zr);
pR = coeffvalues(fitresult)

% Evaluate planes
[nk1 nk2] = meshgrid(85:105, 85:105);
ZpA = pP(1) + pP(2).*nk1 + pP(3).*nk2;
ZrA = pR(1) + pR(2).*nk1 + pR(3).*nk2;

% Plot planes
figure(2)
surf(nk1,nk2,ZpA)
figure(3)
surf(nk1,nk2,ZrA)

% Calculate residuals
ZpB = pP(1) + pP(2).*NK1 + pP(3).*NK2;
ZrB = pR(1) + pR(2).*NK1 + pR(3).*NK2;
Ep = abs(ZpB - Zp);
Er = abs(ZrB - Zr);
fprintf('\nPlane Approximation for Pitch:\n');
fprintf('Pitch (deg) = %f + %f*NK1 + %f*NK2\n',pP(1),pP(2),pP(3));
fprintf('Max pitch err: %f degrees\n\n',max(Ep));
fprintf('Plane Approximation for Roll:\n');
fprintf('Roll (deg) = %f + %f*NK1 + %f*NK2\n',pR(1),pR(2),pR(3));
fprintf('Max  roll err: %f degrees\n',max(Er));

% Should Output:
% Plane Approximation for Pitch:
% Pitch (deg) = -0.000000 + -1.334032*NK1 + 1.334032*NK2
% Max pitch err: 1.092178 degrees
% 
% Plane Approximation for Roll:
% Roll (deg) = -292.813104 + 1.541683*NK1 + 1.541683*NK2
% Max  roll err: 2.376910 degrees