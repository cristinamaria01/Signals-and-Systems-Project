clear all
close all
clc

G = getpltID(123);

%Cerinta_1_________________________________________________________________

faz_vec = 0:1:20;                   % vector de defazaje
%vec = zeros(1,21);
%{
hold on
for phi = 0:1:20
    a = exp(-1j*phi);
    H = a*G;
    H_loop = feedback(H,1);
    vec(phi+1) = isstable(H_loop);
    figure()
    bode(H)
    
end
hold off
%}

faz_lim = 1;
%Cerinta_2_________________________________________________________________

amp_vec = 1:0.05:2;                     % vector de amplificari
vec = zeros(1,21);
i=1;

hold on
for a = 1:0.05:2
    H = a*G;
    H_loop = feedback(H,1);
    vec(i) = isstable(H_loop);
    i=i+1;
    figure()
    bode(H)
end
hold off

amp_lim = 1.3;

%Cerinta_3_________________________________________________________________

filt = tf([1 0],[0.001 1]);
%{
H = G*filt;
bodemag(H)

%}
bstart = 0.381;
bend   = 39.8;
 
%Cerinta_4_________________________________________________________________

filt_cut = tf([1 20.05],[1/1.2 19.4/0.05]);
%{
H = filt_cut*G;

grid on
bode(H,{19,20})

%}
%Cerinta_5_________________________________________________________________

w0 = 5.83;
Q = 2.557;
filt_stop = tf( [1 0.1058 w0^2], [1 w0/Q w0^2]);
H = filt_stop * G;
 
bode(H)

 




