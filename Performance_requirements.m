clear all
close all
clc

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

%k=1.27;
%C=k;
%tau=0.0085;

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

%Tema_4____________________________________________________________________

%Cerinta_1


K = evalfr(G,0);          % amplificarea statica--> K=G(0)
z = 0.480237;             % factorul de amortizare
w = 0.1420;

%{
figure(1)
step(G)
grid on
%}
%stepinfo(G)             % din stepinfo retin suprareglajul 
                        % in variabila overshoot
                       
overshoot = 17.9060;


suprareglaj = exp( -(z*pi)/(sqrt(1 - z^2)) ) *100;

G_0 = evalfr(G,0);
y_st = step(G);            % raspunsul la treapta unitara
y_max = max(y_st);         % valoarea de varf

supraregl = (y_max - G_0)/G_0 *100;


Tt = 1.1827;            % timpul tranzitoriu luat din stepinfo
tt = 4/z*w;             % timpul tranzitoriu calculat

%Cerinta_2

tsim = 0:1e-3:7;        %orizontul de timp
uarm = sin(2*pi*tsim);  %intrare sinusoidala, armonica


%{
figure(2)
subplot(2,1,1)
plot(tsim,uarm)
title('Intrare armonica')

subplot(2,1,2)
lsim(G, uarm, tsim);     % raspunsunul sistemului 
                         % la intrarea de tip armonic
title('Raspunsul sistemului la intrarea armonica')
%}
yarm = lsim(G, uarm, tsim);

uarm_max = max(uarm);   % maximul intrarii armonice --> 1
yarm_max = max(yarm);   

difa = yarm_max - uarm_max;
laga = 6.51 - 6.25;

%Cerinta_3

treapta = double(tsim >=0);
rampa   = tsim .* treapta;

%{
figure(3)
subplot(2,1,1)
plot(tsim, treapta)

subplot(2,1,2)
plot(tsim,rampa)
%}

H = G/G_0;

%{
figure(3)
lsim(H, rampa, tsim)
title('Raspuns sistem H la rampa')
%}

difr = abs(5.8 - 6);             % diferenta de amplitudine dintre
                                 % iesire si intrare

lagr = abs(6 - 5.8);             % defazajul temporal


%Cerinta_4

%a = 289;
%b = 0.080245510101;

s = tf('s');                   
C = 1/(5* s + 1);                % compensator
Tc = 1.6297;


T = feedback(G*C,1,-1);
%{
figure(4)
lsim(T, treapta, tsim)
title('Raspunsul sistemului T la treapta');
%}




timp_tranzitoriu = 6.5188;          % timpul tranzitoriu din stepinfo
timp_tranz = 4*Tc;

Kc = evalfr(T,0);

%Cerinta_5

a= 289;
b= 0.080245514;

C1 = a/(b*s^2 + s);
T1 = feedback(G*C1,1,-1);

lsim(T1, treapta, tsim);
title('Raspunsul lui T1 la treapta');

q = lsim(T1, treapta, tsim);
r = stepinfo(q)

