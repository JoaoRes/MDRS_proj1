%% 1a
clc
lambda = [400; 800; 1200; 1600; 2000];
C = 10;
f = 1e6;
P = 10000;
N = 50;
avg = zeros(5,2);
for x = 1:length(lambda)
    sim = runSimulator1(lambda(x),C,f,P,N);
    avg(x) = sim(2);
end
bar(lambda,avg(:,1))
hold on
er = errorbar(lambda,avg,avg(:,2),avg(:,2));
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

%% functions

% run Simulator1
function media = runSimulator1(lambda,C,f,P,N)
    m = zeros(10,4);
    erro = zeros(1,4);
    for i = 1:N
    [PL , APD , MPD , TT] = Simulator1(lambda,C,f,P);
    m(i,:) = [PL,APD,MPD,TT];
    end
    for k = 1:4
        erro(k) = error(m(:,4),N);
    end
    mean(m)
    media = [mean(m),erro]
end

% error
function term =error(per1,N)
    alfa = 0.1;
    term = norminv(1-alfa/2)*sqrt(var(per1)/N);
end