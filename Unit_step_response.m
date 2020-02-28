clear all
close all
clc

R  = 0.5216307637;
L  = 0.4969359313;  
Km = 0.5209801623;
Kf = 0.1024766158; 
Kb = 1.000380684;
J  = 0.01980725733;
K  = 2.046281494;
T  = 0.09592587727;

k=1.27;
C=k;
tau=0.0085;
%{
poli_1 = [L R] ;
poli_2 = [J Kf];
poli_3 = [T 1] ;

produs    = Km * Kb;
numarator = Km * K ;

inmult = conv(poli_1, poli_2);
m1 = length(inmult);

suma = zeros(1,m1);

for i=1:m1
    suma(i) = inmult(i);
end

suma(m1) = (inmult(m1) + produs) + 0.0001;


numitor = conv(poli_3, suma);

G = tf(numarator, numitor);
%}

G = getpltID(123);

%Tema_3____________________________________________________________________

%Cerinta_1
%{
tt = 0:1e-3:2.5;                            %orizontul de timp
y0_t = [0.1 0.2 0.3];                       %conditii initiale
treapta = double( tt >= 0);

figure(1)
subplot(3,1,1)
yf = lsim(G, treapta, tt);                  %raspunsul fortat
plot(tt,treapta,tt,yf)
title('Raspunsul fortat')

subplot(3,1,2)
yl = initial( ss(G), y0_t, tt);             %raspunsul liber
plot(tt,treapta,tt,yl)
title('Raspunsul liber')

subplot(3,1,3)
yt_1 = lsim( ss(G), treapta, tt, y0_t);      %raspunsul total
plot(tt,treapta,tt,yt_1)
title('Raspunsul total')

yt_2 = yf + yl;

figure(2)
plot(tt,treapta,tt,yl,tt,yf,tt,yt_1)
title('Raspunsul total, liber si fortat')
legend('y = 1t','y = yl','y = yf','y = yt')


%Cerinta_2

enr = norm(yt_1 - yt_2).^2;

%Cerinta_3
tt = 0:1e-3:2.5; 
treapta = double( tt >= 0);
rp = evalfr(G,0) * treapta';         % regim permanent --> H(0)*1(t)

figure(3)
subplot(2,1,1)
plot(tt,rp)
title('Regim permanent')
subplot(2,1,2)
plot(tt,treapta)
title('Treapta')


%Cerinta_4

rt = yt_1 - rp;                     % regim tranzitoriu

subplot(2,1,2)
plot(tt,rt)
title('Regim tranzitoriu')

%}
%Cerinta_5

figure(4)
subplot(2,1,1)
pzmap(G)

T1 = feedback(G*C,1,-1);



%Cerinta_6

s = tf('s');
C2 = (1 - tau*s)/(1 + tau*s);

T2 = feedback(G*C2,1,-1);

figure(5)
subplot(2,1,1)
pzmap(T1);

subplot(2,1,2)
pzmap(T2)





