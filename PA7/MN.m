G1 = 1;
C = 0.25;
G2 = 1/2;
L = 0.2;
G3 = 1/10;
a = 100;
G4 = 1/0.1;
Go = 1/1000;
Vin = 0;

S = [];
Vo = [];
V3 = [];
V1 = [];
%Variable vector S = I_in, V1, V2, I_L, I3, I, V4, Vo
G = [1,G1,-G1,0,0,0,0,0;
    0,-G1,G1+G2,1,0,0,0,0;
    0,0,0,-1,1,0,0,0;
    0,0,0,0,0,-1,G4,-G4;
    0,0,0,0,0,0,-G4,G4+Go;
    0,1,0,0,0,0,0,0;
    0,0,0,0,-a,0,1,0;
    0,0,1,0,-1/G3,0,0,0];

CM = [0,C,-C,0,0,0,0,0;
      0,-C,C,0,0,0,0,0;
      0,0,0,0,0,0,0,0;
      0,0,0,0,0,0,0,0;
      0,0,0,0,0,0,0,0;
      0,0,0,0,0,0,0,0;
      0,0,0,0,0,0,0,0;
      0,0,0,-L,0,0,0,0];

F = [0,0,0,0,0,Vin,0,0];

%DC sweep
count =1;
for i = -10:10
    F(6) = i;
    S = G\(F');
    Vo(count) = S(8);
    V3(count) = S(5)*(1/G3);
    count = count+1;
end

x = linspace(-10,10,21);
figure()
subplot(2,3,1)
hold on
plot(x,V3)
plot(x,Vo)
xlabel('V_{in}')
ylabel('Node Voltage')
legend('V_{3}','V_{o}')
ylim([-100,100])
hold off

%AC sweep:
%Vin now set at 1
F = [0,0,0,0,0,1,0,0];
count =1;
%i=freq
for i = 0:100
    w = 2*pi*i;
    S = (G + (1i*w*CM))\(F');
    Vo(count) = real(S(8));
    V3(count) = real(S(5))*(1/G3);
    V1(count) = real(S(2));
    count = count+1;
end

f = linspace(0,100,101);

subplot(2,3,2)
hold on
grid on
plot(f,V3)
plot(f,Vo)
ylabel('|V|')
xlabel('\omega')
legend('V_{3}','V_{o}')
hold off

subplot(2,3,3)
hold on
grid on
plot(f,20*log(Vo./V1));
ylabel('Gain (dB)')
xlabel('\omega')
hold off

w = 3*pi;
RPC = zeros(1,100);	
cg = zeros(1,100);
std = 0.05;
for i = 1:3000

    C = std*randn + 0.25;
    RPC(i) = C;
    
    %update CM
    CM(1,2) = C;
    CM(1,3) = -C;
    CM(2,2) = -C;
    CM(2,3) = C;

    S = (G + (1i*w*CM))\(F');
    cg(i) = 20*log(abs(S(8))./real(S(2)));

end


subplot(2,3,4)
histogram(RPC);
xlabel('C')
ylabel('Number')

subplot(2,3,5)
histogram(cg)
ylabel('Number')
xlabel('V_{o}/V_{i}')










