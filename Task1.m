%% 1a
clc
lambda = [400; 800; 1200; 1600; 2000];
C = 10;
f = 1e6;
P = 10000;
N = 50;
results = zeros(5,4);
errors = zeros(5,4);
for x = 1:length(lambda)
    [sim,erro] = runSimulator1(lambda(x),C,f,P,N);
    results(x,:) = sim;
    errors(x,:) = erro;
end
bar(lambda,results(:,2))
title('average packet delay')
xlabel('lambda')
ylabel('ms')
hold on
er = errorbar(lambda,results(:,2),errors(:,2),errors(:,2));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

%% 1b 
clc
lambda = 1800;
C = 10;
f = [1e5; 2e4; 1e4; 2e3];
P = 10000;
N = 50;
results = zeros(4,4);
errors = zeros(4,4);
for x = 1:length(f)
    [sim,erro] = runSimulator1(lambda,C,f(x),P,N);
    results(x,:) = sim;
    errors(x,:) = erro;
end
tiledlayout(1,2)
ax1 = nexttile;
bar(ax1,f,results(:,2))
title('average packet delay')
xlabel('queue size (Bytes)')
ylabel('milliseconds')
hold on
er = errorbar(f,results(:,2),errors(:,2),errors(:,2));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax2 = nexttile;
bar(ax2,f,results(:,1))
title('average packet loss')
xlabel('queue size (Bytes)')
ylabel('%')
hold on
er = errorbar(f,results(:,1),errors(:,1),errors(:,1));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

%% 1c
clc
lambda = 1800;
C = [10; 20; 30; 40];
f = 1e6;
P = 10000;
N = 50;
results = zeros(4,4);
errors = zeros(4,4);
for x = 1:length(C)
    [sim,erro] = runSimulator1(lambda,C(x),f,P,N);
    results(x,:) = sim;
    errors(x,:) = erro;
end
bar(C,results(:,2))
title('average packet delay')
xlabel('link bandwidth (Mbps)')
ylabel('ms')
hold on
er = errorbar(C,results(:,2),errors(:,2),errors(:,2));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

%% 1d
clc
lambda = 1800;
C = [10; 20; 30; 40];
list = 64:1518;
prob(list) =  (1-(0.19+0.23+0.17)) / (1518-64-3);
prob(64) = 0.19;
prob(110) = 0.23;
prob(1518) = 0.17;

for x = 1:length(C)
    S = (list.*8) ./ (C(x)*1e6);
    S2 = S.^2;
    ES = sum(prob(list).*S);
    ES2 = sum(prob(list).*S2);
    W = (((lambda*ES2) / (2 * (1- (lambda*ES)))) + ES)*1000;
    fprintf('C -> %d  APD = %d \n',C(x),W);
end

%% 1e
clc
clc
lambda = 1800;
C = [10; 20; 30; 40];
f = 1e6;
P = 10000;
N = 50;
results = zeros(4,7);
errors = zeros(4,7);
for x = 1:length(C)
    [sim,erro] = runSimulator1e(lambda,C(x),f,P,N);
    results(x,:) = sim;
    errors(x,:) = erro;
end
data = [results(:,2) results(:,5)  results(:,6)  results(:,7)];
erro = [errors(:,2) errors(:,5) errors(:,6) errors(:,7)];
b = bar(C,data);
title('average packet delay')
xlabel('link bandwidth (Mbps)')
ylabel('ms')
legend({'Delay','Delay64','Delay110', 'Delay1518'})
hold on
[ngroups,nbars] = size(data);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
er = errorbar(x',data,erro,'k','linestyle','none','HandleVisibility','off');
hold off
%% functions

% run Simulator1
function [media,erro] = runSimulator1(lambda,C,f,P,N)
    m = zeros(10,4);
    for i = 1:N
    [PL , APD , MPD , TT] = Simulator1(lambda,C,f,P);
    m(i,:) = [PL,APD,MPD,TT];
    end
    for k = 1:4
        erro(k) = error(m(:,k),N);
    end
    media = mean(m);
end

% run Simulator1e
function [media,erro] = runSimulator1e(lambda,C,f,P,N)
    m = zeros(10,7);
    for i = 1:N
    [PL , APD , MPD , TT, APD64, APD110, APD1518] = Simulator1e(lambda,C,f,P);
    m(i,:) = [PL,APD,MPD,TT,APD64,APD110,APD1518];
    end
    for k = 1:7
        erro(k) = error(m(:,k),N);
    end
    media = mean(m);
end

% error
function term =error(per1,N)
    alfa = 0.1;
    term = norminv(1-alfa/2)*sqrt(var(per1)/N);
end