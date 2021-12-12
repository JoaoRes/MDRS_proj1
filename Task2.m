%% 2a
clc
lambda = 1500;
C = 10;
f = 1e6;
P = 10000;
N = 50;
n = [10; 20; 30; 40];
results = zeros(4,7);
errors = zeros(4,7);
for x = 1:length(n)
    [sim,erro] = runSimulator3(lambda,C,f,P,N,n(x));
    results(x,:) = sim;
    errors(x,:) = erro;
end
tiledlayout(1,2)
ax1 = nexttile;
bar(ax1,n,results(:,2))
title('average data packet delay')
xlabel('n voip packets')
ylabel('ms')
hold on
er = errorbar(n,results(:,2),errors(:,2),errors(:,2));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax2 = nexttile;
bar(ax2,n,results(:,6))
title('average Voip packet delay')
xlabel('n voip packets')
ylabel('ms')
hold on
er = errorbar(n,results(:,6),errors(:,6),errors(:,6));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

%% 2b
clc
lambda = 1500;
C = 10;
f = 1e6;
P = 10000;
N = 50;
n = [10; 20; 30; 40];
results = zeros(4,7);
errors = zeros(4,7);
for x = 1:length(n)
    [sim,erro] = runSimulator4(lambda,C,f,P,N,n(x));
    results(x,:) = sim;
    errors(x,:) = erro;
end
tiledlayout(1,2)
ax1 = nexttile;
bar(ax1,n,results(:,2))
title('average data packet delay')
xlabel('n voip packets')
ylabel('ms')
hold on
er = errorbar(n,results(:,2),errors(:,2),errors(:,2));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax2 = nexttile;
bar(ax2,n,results(:,6))
title('average Voip packet delay')
xlabel('n voip packets')
ylabel('ms')
hold on
er = errorbar(n,results(:,6),errors(:,6),errors(:,6));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

%% 2c
clc
lambda = 1500;
C = 10 * 1e6;
n = [10; 20; 30; 40];

packetSize = 64:1518;
prob = zeros(1,1518);
prob(packetSize) = (1-0.19-0.23-0.17)/(length(packetSize)-3);
prob(64) = 0.19;
prob(110) = 0.23;
prob(1518) = 0.17;
avgPacketSize = sum(prob(packetSize).*packetSize);

packetSizeVoip = 110:130;
probVoip = zeros(1,130);
probVoip(packetSizeVoip) = 1/length(packetSizeVoip);
avgPacketSizeVoip = sum(probVoip(packetSizeVoip).*packetSizeVoip);

uData = C/(avgPacketSize*8);
uVoip = C/(avgPacketSizeVoip*8);

eData = 1/uData;
eVoip = 1/uVoip;
e2Data = 2/(uData^2);
e2Voip = 2/(uVoip^2);
lambdaVoip = 50.*n;
rData = lambda*eData;
rVoip = eVoip.*lambdaVoip;
wVoip = ((((e2Voip.*lambdaVoip)+(e2Data*lambda)) ./ (2.*(1-rVoip))) +eVoip).*1e3;
wData = ((((e2Voip.*lambdaVoip)+(e2Data*lambda)) ./ (2.*(1-rVoip).*(1-rVoip-rData))) +eData).*1e3;
fprintf("n \t\t 10 \t\t\t 20 \t\t\t 30 \t\t\t 40 \n");
fprintf("wVoip \t %d \t %d \t %d \t %d \n",wVoip);
fprintf("wData \t %d \t %d \t %d \t %d \n",wData);

%% 2d
clc
lambda = 1500;
C = 10;
f = 1e4;
P = 10000;
N = 50;
n = [10; 20; 30; 40];
results = zeros(4,7);
errors = zeros(4,7);
for x = 1:length(n)
    [sim,erro] = runSimulator3(lambda,C,f,P,N,n(x));
    results(x,:) = sim;
    errors(x,:) = erro;
end
tiledlayout(2,2)
ax1 = nexttile;
bar(ax1,n,results(:,2))
title('average data packet delay')
xlabel('queue size (Bytes)')
ylabel('milliseconds')
hold on
er = errorbar(n,results(:,2),errors(:,2),errors(:,2));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax2 = nexttile;
bar(ax2,n,results(:,1))
title('data packet loss')
xlabel('queue size (Bytes)')
ylabel('%')
hold on
er = errorbar(n,results(:,1),errors(:,1),errors(:,1));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax3 = nexttile;
bar(ax3,n,results(:,6))
title('average Voip packet delay')
xlabel('queue size (Bytes)')
ylabel('milliseconds')
hold on
er = errorbar(n,results(:,6),errors(:,6),errors(:,6));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax3 = nexttile;
bar(ax3,n,results(:,5))
title('Voip packet loss')
xlabel('queue size (Bytes)')
ylabel('%')
hold on
er = errorbar(n,results(:,5),errors(:,5),errors(:,5));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

%% 2e
clc
lambda = 1500;
C = 10;
f = 1e4;
P = 10000;
N = 50;
n = [10; 20; 30; 40];
results = zeros(4,7);
errors = zeros(4,7);
for x = 1:length(n)
    [sim,erro] = runSimulator4(lambda,C,f,P,N,n(x));
    results(x,:) = sim;
    errors(x,:) = erro;
end
tiledlayout(2,2)
ax1 = nexttile;
bar(ax1,n,results(:,2))
title('average data packet delay')
xlabel('queue size (Bytes)')
ylabel('milliseconds')
hold on
er = errorbar(n,results(:,2),errors(:,2),errors(:,2));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax2 = nexttile;
bar(ax2,n,results(:,1))
title('data packet loss')
xlabel('queue size (Bytes)')
ylabel('%')
hold on
er = errorbar(n,results(:,1),errors(:,1),errors(:,1));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax3 = nexttile;
bar(ax3,n,results(:,6))
title('average Voip packet delay')
xlabel('queue size (Bytes)')
ylabel('milliseconds')
hold on
er = errorbar(n,results(:,6),errors(:,6),errors(:,6));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ax3 = nexttile;
bar(ax3,n,results(:,5))
title('Voip packet loss')
xlabel('queue size (Bytes)')
ylabel('%')
hold on
er = errorbar(n,results(:,5),errors(:,5),errors(:,5));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off
%% functions

% run Simulator3
function [media,erro] = runSimulator3(lambda,C,f,P,N,n)
    m = zeros(10,7);
    for i = 1:N
    [PL , APD , MPD , TT, PLV , APDV , MPDV] = Simulator3(lambda,C,f,P,n);
    m(i,:) = [PL,APD,MPD,TT,PLV,APDV,MPDV];
    end
    for k = 1:7
        erro(k) = error(m(:,k),N);
    end
    media = mean(m);
end

% run Simulator4
function [media,erro] = runSimulator4(lambda,C,f,P,N,n)
    m = zeros(10,7);
    for i = 1:N
    [PL , APD , MPD , TT, PLV , APDV , MPDV] = Simulator4(lambda,C,f,P,n);
    m(i,:) = [PL,APD,MPD,TT,PLV,APDV,MPDV];
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