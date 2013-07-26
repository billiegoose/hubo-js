% God what am I getting myself into
% COORDINATE SYSTEM
% +X is robot's forward
% +Y is robot's left
% +Z is robot's up

% Units in mm
adjleg = 29.72;
opleg = 45;
height = 93.05;

a = adjleg;
b = adjleg;
c = opleg;

lambda = acos((a^2+b^2-c^2)./(2*a*b));
h = cos(lambda/2)*adjleg;
e = sin(lambda/2)*adjleg;

% Sanity check
assert(abs((h^2+e^2)/(adjleg^2) - 1) < 0.00001)

% Coordinates of interest
universal_point = [0; 0; 0];
neck1tip_point = universal_point + [-h; -e; 0];
neck2tip_point = universal_point + [-h; +e; 0];
neck1base_point = universal_point + [0; -e; -height];
neck2base_point = universal_point + [0; e; -height];
