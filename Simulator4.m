function [PL , APD , MPD , TT, PLV , APDV , MPDV] = Simulator4(lambda,C,f,P,n)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
% OUTPUT PARAMETERS:
%  PL   - packet loss (%)
%  APD  - average packet delay (milliseconds)
%  MPD  - maximum packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet
DATA=3;
VOIP=2;

%State variables:
STATE = 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETS= 0;       % No. of packets arrived to the system
LOSTPACKETS= 0;        % No. of packets dropped due to buffer overflow
TRANSMITTEDPACKETS= 0; % No. of transmitted packets
TRANSMITTEDBYTES= 0;   % Sum of the Bytes of transmitted packets
DELAYS= 0;             % Sum of the delays of transmitted packets
MAXDELAY= 0;           % Maximum delay among all transmitted packets

TOTALPACKETSVOIP= 0;        % No. of packets arrived to the system
LOSTPACKETSVOIP = 0;        % No. of voip packets dropped due to buffer overflow
TRANSMITTEDPACKETSVOIP= 0;  % No. of transmitted packets
DELAYSVOIP= 0;              % Sum of the delays of transmitted packets
MAXDELAYVOIP= 0;            % Maximum delay among all transmitted packets

% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
EventList = [ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];

for i = 1:n
    tmp = rand()*0.02;
    EventList = [EventList; ARRIVAL, tmp, GeneratePacketSizeVoip(), tmp, VOIP];
end


%Similation loop:
while (TRANSMITTEDPACKETS+TRANSMITTEDPACKETSVOIP)<P               % Stopping criterium
    EventList= sortrows(EventList,2);    % Order EventList by time
    Event= EventList(1,1);               % Get first event and 
    Clock= EventList(1,2);               %   and
    PacketSize= EventList(1,3);          %   associated
    ArrivalInstant= EventList(1,4);      %   parameters.

    PacketType= EventList(1,5);
    
    EventList(1,:)= [];                  % Eliminate first event
    switch Event
        case ARRIVAL                     % If first event is an ARRIVAL
            switch PacketType
                case DATA
                    TOTALPACKETS= TOTALPACKETS+1;
                    tmp= Clock + exprnd(1/lambda);
                    EventList = [EventList; ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];
                    if STATE==0
                        STATE= 1;
                        EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock, DATA];
                    else
                        if QUEUEOCCUPATION + PacketSize <= f
                            QUEUE= [QUEUE;PacketSize , Clock,DATA];
                            QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                        else
                            LOSTPACKETS= LOSTPACKETS + 1;
                        end
                    end
                case VOIP
                    TOTALPACKETSVOIP= TOTALPACKETSVOIP+1;
                    tmp= Clock + GeneratePacketTimeVoip();
                    EventList = [EventList; ARRIVAL, tmp, GeneratePacketSizeVoip(), tmp, VOIP];
                    if STATE==0
                        STATE= 1;
                        EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock, VOIP];
                    else
                        if QUEUEOCCUPATION + PacketSize <= f
                            QUEUE= [QUEUE;PacketSize , Clock,VOIP];
                            QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                        else
                            LOSTPACKETSVOIP= LOSTPACKETSVOIP + 1;
                        end
                    end
            end
        case DEPARTURE                     % If first event is a DEPARTURE
            switch PacketType
                case DATA
                    TRANSMITTEDBYTES= TRANSMITTEDBYTES + PacketSize;
                    DELAYS= DELAYS + (Clock - ArrivalInstant);
                    if Clock - ArrivalInstant > MAXDELAY
                        MAXDELAY= Clock - ArrivalInstant;
                    end
                    TRANSMITTEDPACKETS= TRANSMITTEDPACKETS + 1;
                    if QUEUEOCCUPATION > 0
                        QUEUE = sortrows(QUEUE,3);
                        tipo = QUEUE(1,3);
                        EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2), tipo];
                        QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                        QUEUE(1,:)= [];
                    else
                        STATE= 0;
                    end
                case VOIP
                    TRANSMITTEDBYTES= TRANSMITTEDBYTES + PacketSize;
                    DELAYSVOIP= DELAYSVOIP + (Clock - ArrivalInstant);
                    if Clock - ArrivalInstant > MAXDELAYVOIP
                        MAXDELAYVOIP= Clock - ArrivalInstant;
                    end
                    TRANSMITTEDPACKETSVOIP= TRANSMITTEDPACKETSVOIP + 1;
                    if QUEUEOCCUPATION > 0
                        QUEUE = sortrows(QUEUE,3);
                        tipo = QUEUE(1,3);
                        EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2), tipo];
                        QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                        QUEUE(1,:)= [];
                    else
                        STATE= 0;
                    end
            end
    end
end

%Performance parameters determination:
PL= 100*LOSTPACKETS/TOTALPACKETS;      % in %
APD= 1000*DELAYS/TRANSMITTEDPACKETS;   % in milliseconds
MPD= 1000*MAXDELAY;                    % in milliseconds
TT= 10^(-6)*TRANSMITTEDBYTES*8/Clock;  % in Mbps

PLV= 100*LOSTPACKETSVOIP/TOTALPACKETSVOIP;      % in %
APDV= 1000*DELAYSVOIP/TRANSMITTEDPACKETSVOIP;   % in milliseconds
MPDV= 1000*MAXDELAYVOIP;                        % in milliseconds

end

function out= GeneratePacketSize()
    aux= rand();
    aux2= [65:109 111:1517];
    if aux <= 0.19
        out= 64;
    elseif aux <= 0.19 + 0.23
        out= 110;
    elseif aux <= 0.19 + 0.23 + 0.17
        out= 1518;
    else
        out = aux2(randi(length(aux2)));
    end
end

function out= GeneratePacketSizeVoip()
    aux= (110:130);
    out = aux(randi(length(aux)));
end

function out= GeneratePacketTimeVoip()
    out = (16 + rand()*8)/1000;
end