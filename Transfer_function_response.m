clear all
close all  
clc

R =  0.5216307637;
L =  0.4969359313;  
Km = 0.5209801623;
Kf = 0.1024766158; 
Kb = 1.000380684;
J = 0.01980725733;
K = 2.046281494;
T = 0.09592587727;

poli_1 = [L R];
poli_2 = [J Kf];
poli_3 = [T 1];

produs_1 = Km * Kb;
numarator = Km * K;

inmult = conv(poli_1, poli_2);
[m1,m2] = size(inmult);           %memorez numarul de linii si coloane al vectorului inmult

suma_1 = inmult(m2) + produs_1;
numitor = conv(suma_1, poli_3);

G = tf(numarator, numitor);


%Tema_2____________________________________________________________________

%Cerinta_1
t = 0:1e-3:5;       % marimea lui t --> [1 5001]

g  = impulse(G,t);
a = size(g);        % marimea lui g --> [5001 1]

st = step(G,t);
b = size(st);       % marimea lui b --> [5001  1]

%Cerinta_2
u=heaviside(t);
dt=1e-3;
cv=conv(u,g)*dt;
cv = cv(1:length(t));
cv = cv';
energ=norm(st-cv).^2;



%Cerinta_3
ta = 0:1e-3:7;              %orizontul de timp -->[1 7001]
w = logspace(0, 3, 1000)';  %esantionul de pulsatii -->[1000 1]

   q = conv(ta,w,'same');
        ua = sin(q);
    
        
   y = lsim(G,ua,ta);
    figure()
    plot(ta,ua)
    
    figure()
    plot(ta,y)
    
    figure()
    stem(ta,y)
    
    max_arm = max(y);
    
%Cerinta_4
ts = 0:1e-3:10;                 %orizontul de timp
sw = [ones(1, 2.5e3 +1) zeros(1, 5e3 - (2.5e3 +1)) ones(1, 2.5e3 +1) zeros(1, 2.5e3)]';
sw_resp = lsim(G,sw,ts);
    figure(4)
    plot(ts,sw_resp)
    
    figure()
    plot(t,st)
    
%Cerinta_5
%hold on
dir_apr = zeros(1, length(t));
for n = 1:2:20
    for i =1:length(t)
        dir_apr(i) = n * bell(n*t(i));
    end
end
%hold off
lsim(G,dir_apr,t)
figure(6)
plot(t, dir_apr)

%energ_2 = norm(dir_apr - g).^2; 


