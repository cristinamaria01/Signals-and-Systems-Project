clear all
close all
clc
 
G= getpltID(123);

R  = 0.5216307637;
L  = 0.4969359313;  
Km = 0.5209801623;
Kf = 0.1024766158; 
Kb = 1.000380684;
J  = 0.01980725733;
K  = 2.046281494;
T  = 0.09592587727;


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

%{
figure(1)
pzmap(G);
title('Grafic poli-zerouri');   % Sistemul este stabil in bucla deschisa

figure(2)
nyquist(G);
title('Grafic Nyquist');
%}

%Cerinta_1_________________________________________________________________
a = allmargin(G);
faz_neg = a.PhaseMargin;        % in grade: 84.51
                                % Marginea de faza --> MF indica cata faza negativa se poate adauga 
                                % lui L(j?) fara ca sistemul in bucla inchisa sa-si piarda stabilitatea,
                                % fiind deci o masura a marginii de stabilitate sau robustetii stabilitatii.

%Cerinta_2_________________________________________________________________
amp_sup = 1.2788;
G_1 = amp_sup * G;

%{
figure()
nyquist(G_1);
%}

%Cerinta_3_________________________________________________________________
amp_inf = 0;
G_2 = amp_inf * G;

H = feedback(G_2,1);
%{
figure()
subplot(2,1,1)
    nyquist(G_2);
    allmargin(G_2)
subplot(2,1,2)
    nyquist(H);
    allmargin(H)
%}
%Cerinta_4_________________________________________________________________

delvec = [0 0.005 0.01 0.015 0.02];

%{
for i=1:5
    G_3(i) = tf(numarator, numitor, 'InputDelay', delvec(i));
end


for i=1:5
    figure()
        nyquist(G_3(i));
end
%}

intarz = 0.015;

%Cerinta_5_________________________________________________________________
c = 0.3;
d = 4;

s = tf('s');
C = (s+c)/(s+d);
L = G*C;

%{
figure()
nyquist(L);
allmargin(L)

L_1 = feedback(L,1);
figure()
nyquist(L_1);
allmargin(L_1)
%}

%Cerinta_6_________________________________________________________________
Cx = tf([3.863e-05 0.0009974 0.01053 0.06433 0.2058 0.05388 0.1066],[1.053e-06 0.002107 1.055 1.117 0.5907 0.5264 0]);
Lx = G * Cx;
%{
figure()    
nyquist(Lx);            % stabil in bucla deschisa

figure()
nyquist(feedback(Lx,1));% stabil in bucla inchisa
%}

S = 1/(1+Lx);           % functie de sensibilitate
norma = norm(S,inf);
Mv = 1/norma;           % Mv < 0.5 ---> instabilitate

dst_x = Mv;             % distanta minima de la punctul critic
                        % la locul Nyquist

cl_rob = logical(false);
