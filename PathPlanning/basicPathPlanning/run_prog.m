% Shomik Verma
% NA final project
% run_prog.m

clear;
addpath util
%% import data

global m % mass
m = 25+50;

N = 50;
tf = 210;

track = importTrack(N, tf);
% initialize path to centerline
% t = linspace(0, tf, N)'; % initialize to constant velocity
path_t = .5*ones(N,1); % t is the parameter defining how far left/right

path = pathToCart(track, path_t);
totalD = sum(sqrt(sum(gradient(path')'.^2, 2)));
v = totalD/tf.*ones(N,1); % initial condition
t = cumsum(sqrt(sum(gradient(path')'.^2, 2))./v);

%% plot initial configuration
plotSols(t,path_t,track);
drawnow();

%% run optimization
tAll = [t];
pathAll = [path_t];
errv = 1e10;
errr = 1e10;
tic;
for i = 1:50
    [t, path_t] = pathopt(t, path_t, track);
    
    path = pathToCart(track, path_t);
    tAll = [tAll,t];
    pathAll = [pathAll,path_t];
end
toc;
beep
plotSols(t, path_t, track);
%% figure export
figsPrepend = input('save file name: ','s');
figure(1);
print(['plots/',figsPrepend,'_velocityPath'],'-dpng');
figure(2);
print(['plots/',figsPrepend,'_velocityProf'],'-dpng');
figure(3);
print(['plots/',figsPrepend,'_optimalPath'],'-dpng');
figure(4);
print(['plots/',figsPrepend,'_lossBreakdown'],'-dpng');
save(['saveData/',figsPrepend])