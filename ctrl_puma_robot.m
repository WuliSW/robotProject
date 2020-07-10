function [sys,x0,str,ts] = ctrl_puma_robot(t,x,u,flag)
switch flag,
      case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
      case {1,2,4,9},
    sys=[];
      case 3,
    sys=mdlOutputs(t,x,u);
      otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 12;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;  
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];

function sys=mdlOutputs(t,x,u)
%ע��DH������ת������������CRP��˾�ṩ���������Լ���adams�в�õ���ֵ
%���˳���
a1 = [-0.1573; 0.0653; 0];  %3*1����
a2= [ -0.0165; 0.0464; 0.6136];
a3 = [-0.2975; -0.0519; 0.1671];
a4 = [-0.3545; 0.0440; -0.0437];
a5 = [0.0820; -0.0145; -0.5149];
a6 = [0; 0; 0];

%���˳����ظ��������ϵķ���
Tx = [0, -0.1573, -0.0165, -0.2975, -0.3545, 0.0820];%Tx = [0, 0.1949, 1.0938e-04, 0.2000, 0, -4.7162e-04];
Ty = [0, 0.0653, 0.0464, -0.0519, 0.0440, -0.0145];%Ty = [0, -0.0951, -0.6137, 0.2750, 0.0320, 0.0981];
Tz = [0, 0, 0.6136, 0.1671, -0.0437, -0.5149];%Tz = [0, 0, 0.0030, 0.1105, 0.3650, 0.0540];

%����ƫ��
d1=0; d2=0; d3=-0.0004; d4=0.64; d5=0 ;d6=0.1;
d=[d1; d2; d3; d4; d5; d6];

%����Ťת
alpha= [0, -pi/2, 0, -pi/2, pi/2, -pi/2];

%��������
m1=60.88;m2=21.7;m3=29.67;m4=9.45;m5=3.38;m6=0;  
m=[m1;m2;m3;m4;m5;m6];

%�������˵�ת������
J1=[1.392 0 0;
    0 1.823 0;
    0 0 1.195];   
J2=[0.07328 0 0;
    0 1.143 0;
    0 0 1.184];
J3=[0.4015 0 0;
    0 0.5946 0;
    0 0 0.4854];
J4=[0.2212 0 0;
    0 0.05516 0;
    0 0 0.1994];
J5=[0.009553 0 0;
    0 0.008458 0;
    0 0 0.008701];
J6=[0.0002627 0 0;
    0 0.0002627 0;
    0 0 0.0004718];

%�������˵����ǰһ���ؽ�����ϵ�����ļ�����
r1=[-0.1122; -0.1571; 0.00307];   %3*1����
r2=[-0.3446; -0.01614; 0.1188];
r3=[-0.1007; -0.00328; 0.08473];
r4=[-0.03473; -0.1672; 0.00825];
r5=[-1.11e-16; -0.00329; 0.05699];
r6=[0; 0; 0];

%�ؽڽǶ�q�͹ؽڽ��ٶ�dq
q=[u(1)-pi/2;u(2);u(3);u(4)-pi/2;u(5);u(6)];  %6*1����
dq=[u(7);u(8);u(9);u(10);u(11);u(12)];  %6*1����

%�任����A�Ķ���
A01=[cos(u(1)) -sin(u(1)) 0;
    sin(u(1))  cos(u(1)) 0;
    0 0 1];
A12=[cos(u(2)) -sin(u(2)) 0;
    0 0 -1;
    sin(u(2)) cos(u(2)) 0];
A23=[cos(u(3)) -sin(u(3)) 0;
    sin(u(3)) cos(u(3)) 0;
    0 0 1];
A34=[cos(u(4)) -sin(u(4)) 0;
    0 0 -1;
    sin(u(4)) cos(u(4)) 0];
A45=[cos(u(5)) -sin(u(5)) 0;
    0 0 -1;
   sin(u(5)) cos(u(5)) 0];
A56=[cos(u(6)) -sin(u(6)) 0;
    0 0 1;
    -sin(u(6)) -cos(u(6)) 0];
A1=A01;
A2=A12*A01;
A3=A23*A12*A01;
A4=A34*A23*A12*A01;
A5=A45*A34*A23*A12*A01;
A6=A56*A45*A34*A23*A12*A01;

%����VT�еĲ�˾���
xA1r1=A1*r1;
chachengxA1r1=[0 -xA1r1(3) xA1r1(2);xA1r1(3) 0 -xA1r1(1);-xA1r1(2) xA1r1(1) 0];
xA2r2=A2*r2;
chachengxA2r2=[0 -xA2r2(3) xA2r2(2);xA2r2(3) 0 -xA2r2(1);-xA2r2(2) xA2r2(1) 0];
xA3r3=A3*r3;
chachengxA3r3=[0 -xA3r3(3) xA3r3(2);xA3r3(3) 0 -xA3r3(1);-xA3r3(2) xA3r3(1) 0];
xA4r4=A4*r4;
chachengxA4r4=[0 -xA4r4(3) xA4r4(2);xA4r4(3) 0 -xA4r4(1);-xA4r4(2) xA4r4(1) 0];
xA5r5=A5*r5;
chachengxA5r5=[0 -xA5r5(3) xA5r5(2);xA5r5(3) 0 -xA5r5(1);-xA5r5(2) xA5r5(1) 0];
xA6r6=A6*r6;
chachengxA6r6=[0 -xA6r6(3) xA6r6(2);xA6r6(3) 0 -xA6r6(1);-xA6r6(2) xA6r6(1) 0];

%�����˾���A1*qx
xA1a2=A1*a2;  %3*1
chachengxA1a2=[0 -xA1a2(3) xA1a2(2);xA1a2(3) 0 -xA1a2(1);-xA1a2(2) xA1a2(1) 0];  %3*3����
xA2a3=A2*a3;
chachengxA2a3=[0 -xA2a3(3) xA2a3(2);xA2a3(3) 0 -xA2a3(1);-xA2a3(2) xA2a3(1) 0];
xA3a4=A3*a4;
chachengxA3a4=[0 -xA3a4(3) xA3a4(2);xA3a4(3) 0 -xA3a4(1);-xA3a4(2) xA3a4(1) 0];
xA4a5=A4*a5;
chachengxA4a5=[0 -xA4a5(3) xA4a5(2);xA4a5(3) 0 -xA4a5(1);-xA4a5(2) xA4a5(1) 0];
xA5a6=A5*a6;
chachengxA5a6=[0 -xA5a6(3) xA5a6(2);xA5a6(3) 0 -xA5a6(1);-xA5a6(2) xA5a6(1) 0];

%����VkT  3*18����
V1T=-[chachengxA1r1 [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] ];
V2T=-[chachengxA1a2 chachengxA2r2 [0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0]];
V3T=-[chachengxA1a2 chachengxA2a3 chachengxA3r3 [0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0]];
V4T=-[chachengxA1a2 chachengxA2a3 chachengxA3a4 chachengxA4r4 [0 0 0 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0]];
V5T=-[chachengxA1a2 chachengxA2a3 chachengxA3a4 chachengxA4a5 chachengxA5r5 [0 0 0;0 0 0;0 0 0]];
V6T=-[chachengxA1a2 chachengxA2a3 chachengxA3a4 chachengxA4a5 chachengxA5a6 chachengxA6r6];
V1=V1T';  %18*3����
V2=V2T';
V3=V3T';
V4=V4T';
V5=V5T';
V6=V6T';

%����W��WT
e3=[0;0;1];
W1=[e3'*A1';0 0 0;0 0 0;0 0 0;0 0 0;0 0 0];   %6*3����
W2=[e3'*A1';e3'*A2';0 0 0;0 0 0;0 0 0;0 0 0];
W3=[e3'*A1';e3'*A2';e3'*A3';0 0 0;0 0 0;0 0 0];
W4=[e3'*A1';e3'*A2';e3'*A3';e3'*A4';0 0 0;0 0 0];
W5=[e3'*A1';e3'*A2';e3'*A3';e3'*A4';e3'*A5';0 0 0];
W6=[e3'*A1';e3'*A2';e3'*A3';e3'*A4';e3'*A5';e3'*A6'];
W1T=W1';    %3*6����
W2T=W2';
W3T=W3';
W4T=W4';
W5T=W5';
W6T=W6';

%����W
W=[W1 W2 W3 W4 W5 W6];          %6*18����
WT=[W1T;W2T;W3T;W4T;W5T;W6T];   %18*6����

%������ٶ�
w1=A1*e3*dq(1);                   %3*1 ����
w2=A1*e3*dq(1)+A2*e3*dq(2);
w3=A1*e3*dq(1)+A2*e3*dq(2)+A3*e3*dq(3);
w4=A1*e3*dq(1)+A2*e3*dq(2)+A3*e3*dq(3)+A4*e3*dq(4);
w5=A1*e3*dq(1)+A2*e3*dq(2)+A3*e3*dq(3)+A4*e3*dq(4)+A5*e3*dq(5);
w6=A1*e3*dq(1)+A2*e3*dq(2)+A3*e3*dq(3)+A4*e3*dq(4)+A5*e3*dq(5)+A6*e3*dq(6);

%������ٶȵĲ�˾���
xw1=[0 -w1(3) w1(2);w1(3) 0 -w1(1);-w1(2) w1(1) 0];   %3*3����
xw2=[0 -w2(3) w2(2);w2(3) 0 -w2(1);-w2(2) w2(1) 0];
xw3=[0 -w3(3) w3(2);w3(3) 0 -w3(1);-w3(2) w3(1) 0];
xw4=[0 -w4(3) w4(2);w4(3) 0 -w4(1);-w4(2) w4(1) 0];
xw5=[0 -w5(3) w5(2);w5(3) 0 -w5(1);-w5(2) w5(1) 0];
xw6=[0 -w6(3) w6(2);w6(3) 0 -w6(1);-w6(2) w6(1) 0];

%����dVkT�еĲ�˾���
xxw1A1r1=xw1*A1*r1;   %3*1����
chachengxxw1A1r1=[0 -xxw1A1r1(3) xxw1A1r1(2);xxw1A1r1(3) 0 -xxw1A1r1(1);-xxw1A1r1(2) xxw1A1r1(1) 0];
xxw1A1a2=xw1*A1*a2;
chachengxxw1A1a2=[0 -xxw1A1a2(3) xxw1A1a2(2);xxw1A1a2(3) 0 -xxw1A1a2(1);-xxw1A1a2(2) xxw1A1a2(1) 0];
xxw2A2r2=xw2*A2*r2;
chachengxxw2A2r2=[0 -xxw2A2r2(3) xxw2A2r2(2);xxw2A2r2(3) 0 -xxw2A2r2(1);-xxw2A2r2(2) xxw2A2r2(1) 0];
xxw2A2a3=xw2*A2*a3;
chachengxxw2A2a3=[0 -xxw2A2a3(3) xxw2A2a3(2);xxw2A2a3(3) 0 -xxw2A2a3(1);-xxw2A2a3(2) xxw2A2a3(1) 0];
xxw3A3r3=xw3*A3*r3;
chachengxxw3A3r3=[0 -xxw3A3r3(3) xxw3A3r3(2);xxw3A3r3(3) 0 -xxw3A3r3(1);-xxw3A3r3(2) xxw3A3r3(1) 0];
xxw3A3a4=xw3*A3*a4;
chachengxxw3A3a4=[0 -xxw3A3a4(3) xxw3A3a4(2);xxw3A3a4(3) 0 -xxw3A3a4(1);-xxw3A3a4(2) xxw3A3a4(1) 0];
xxw4A4r4=xw4*A4*r4;
chachengxxw4A4r4=[0 -xxw4A4r4(3) xxw4A4r4(2);xxw4A4r4(3) 0 -xxw4A4r4(1);-xxw4A4r4(2) xxw4A4r4(1) 0];
xxw4A4a5=xw4*A4*a5;
chachengxxw4A4a5=[0 -xxw4A4a5(3) xxw4A4a5(2);xxw4A4a5(3) 0 -xxw4A4a5(1);-xxw4A4a5(2) xxw4A4a5(1) 0];
xxw5A5r5=xw5*A5*r5;
chachengxxw5A5r5=[0 -xxw5A5r5(3) xxw5A5r5(2);xxw5A5r5(3) 0 -xxw5A5r5(1);-xxw5A5r5(2) xxw5A5r5(1) 0];
xxw5A5a6=xw5*A5*a6;
chachengxxw5A5a6=[0 -xxw5A5a6(3) xxw5A5a6(2);xxw5A5a6(3) 0 -xxw5A5a6(1);-xxw5A5a6(2) xxw5A5a6(1) 0];
xxw6A6r6=xw6*A6*r6;
chachengxxw6A6r6=[0 -xxw6A6r6(3) xxw6A6r6(2);xxw6A6r6(3) 0 -xxw6A6r6(1);-xxw6A6r6(2) xxw6A6r6(1) 0];

%����dVkT ------------------------3*18����
dV1T=-[chachengxxw1A1r1 [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]];
dV2T=-[chachengxxw1A1a2 chachengxxw2A2r2 [0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0]];
dV3T=-[chachengxxw1A1a2 chachengxxw2A2a3 chachengxxw3A3r3 [0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0]];
dV4T=-[chachengxxw1A1a2 chachengxxw2A2a3 chachengxxw3A3a4 chachengxxw4A4r4 [0 0 0 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0]];
dV5T=-[chachengxxw1A1a2 chachengxxw2A2a3 chachengxxw3A3a4 chachengxxw4A4a5 chachengxxw5A5r5 [0 0 0;0 0 0;0 0 0]];
dV6T=-[chachengxxw1A1a2 chachengxxw2A2a3 chachengxxw3A3a4 chachengxxw4A4a5 chachengxxw5A5a6 chachengxxw6A6r6];
dV1=dV1T';     %18*3����
dV2=dV2T';
dV3=dV3T';
dV4=dV4T';
dV5=dV5T';
dV6=dV6T';

%����A1e3�Ĳ�˾���
xA1e3=A1*e3;
chachengxA1e3=[0 -xA1e3(3) xA1e3(2);xA1e3(3) 0 -xA1e3(1);-xA1e3(2) xA1e3(1) 0];
xA2e3=A2*e3;
chachengxA2e3=[0 -xA2e3(3) xA2e3(2);xA2e3(3) 0 -xA2e3(1);-xA2e3(2) xA2e3(1) 0];
xA3e3=A3*e3;
chachengxA3e3=[0 -xA3e3(3) xA3e3(2);xA3e3(3) 0 -xA3e3(1);-xA3e3(2) xA3e3(1) 0];
xA4e3=A4*e3;
chachengxA4e3=[0 -xA4e3(3) xA4e3(2);xA4e3(3) 0 -xA4e3(1);-xA4e3(2) xA4e3(1) 0];
xA5e3=A5*e3;
chachengxA5e3=[0 -xA5e3(3) xA5e3(2);xA5e3(3) 0 -xA5e3(1);-xA5e3(2) xA5e3(1) 0];
xA6e3=A6*e3;
chachengxA6e3=[0 -xA6e3(3) xA6e3(2);xA6e3(3) 0 -xA6e3(1);-xA6e3(2) xA6e3(1) 0];

%����dW��dWT
dW1=[dq'*W1*chachengxA1e3;[0 0 0;0 0 0;0 0 0;0 0 0;0 0 0]];  %6*3����
dW2=[dq'*W1*chachengxA1e3;dq'*W2*chachengxA2e3;[0 0 0;0 0 0;0 0 0;0 0 0]];
dW3=[dq'*W1*chachengxA1e3;dq'*W2*chachengxA2e3;dq'*W3*chachengxA3e3;[0 0 0;0 0 0;0 0 0]];
dW4=[dq'*W1*chachengxA1e3;dq'*W2*chachengxA2e3;dq'*W3*chachengxA3e3;dq'*W4*chachengxA4e3;[0 0 0;0 0 0]];
dW5=[dq'*W1*chachengxA1e3;dq'*W2*chachengxA2e3;dq'*W3*chachengxA3e3;dq'*W4*chachengxA4e3;dq'*W5*chachengxA5e3;[0 0 0]];
dW6=[dq'*W1*chachengxA1e3;dq'*W2*chachengxA2e3;dq'*W3*chachengxA3e3;dq'*W4*chachengxA4e3;dq'*W5*chachengxA5e3;dq'*W6*chachengxA6e3];
dW=[dW1 dW2 dW3 dW4 dW5 dW6];  %6*18����
dW1T=dW1';  %3*6����
dW2T=dW2';
dW3T=dW3';
dW4T=dW4';
dW5T=dW5';
dW6T=dW6';
dWT=[dW1T;dW2T;dW3T;dW4T;dW5T;dW6T];          %18*6����

%����M����
M1=m1*W*V1*V1T*WT+W1*J1*W1T;   %6*6����
M2=m2*W*V2*V2T*WT+W2*J2*W2T;
M3=m3*W*V3*V3T*WT+W3*J3*W3T;
M4=m4*W*V4*V4T*WT+W4*J4*W4T;
M5=m5*W*V5*V5T*WT+W5*J5*W5T;
M6=m6*W*V6*V6T*WT+W6*J6*W6T;
M=M1+M2+M3+M4+M5+M6;   %6*6����
MT=M';

%����WkT��dq�Ĳ�˾���
xW1Tdq=W1T*dq;
chachengxW1Tdq=[0 -xW1Tdq(3) xW1Tdq(2);xW1Tdq(3) 0 -xW1Tdq(1);-xW1Tdq(2) xW1Tdq(1) 0];
xW2Tdq=W2T*dq;
chachengxW2Tdq=[0 -xW2Tdq(3) xW2Tdq(2);xW2Tdq(3) 0 -xW2Tdq(1);-xW2Tdq(2) xW2Tdq(1) 0];
xW3Tdq=W3T*dq;
chachengxW3Tdq=[0 -xW3Tdq(3) xW3Tdq(2);xW3Tdq(3) 0 -xW3Tdq(1);-xW3Tdq(2) xW3Tdq(1) 0];
xW4Tdq=W4T*dq;
chachengxW4Tdq=[0 -xW4Tdq(3) xW4Tdq(2);xW4Tdq(3) 0 -xW4Tdq(1);-xW4Tdq(2) xW4Tdq(1) 0];
xW5Tdq=W5T*dq;
chachengxW5Tdq=[0 -xW5Tdq(3) xW5Tdq(2);xW5Tdq(3) 0 -xW5Tdq(1);-xW5Tdq(2) xW5Tdq(1) 0];
xW6Tdq=W6T*dq;
chachengxW6Tdq=[0 -xW6Tdq(3) xW6Tdq(2);xW6Tdq(3) 0 -xW6Tdq(1);-xW6Tdq(2) xW6Tdq(1) 0];

%����N����
N1=(m1*W*V1*(dV1T*WT+V1T*dWT)+W1*J1*dW1T+W1*chachengxW1Tdq*J1*W1T);  %6*6����
N2=(m2*W*V2*(dV2T*WT+V2T*dWT)+W2*J2*dW2T+W2*chachengxW2Tdq*J2*W2T);
N3=(m3*W*V3*(dV3T*WT+V3T*dWT)+W3*J3*dW3T+W3*chachengxW3Tdq*J3*W3T);
N4=(m4*W*V4*(dV4T*WT+V4T*dWT)+W4*J4*dW4T+W4*chachengxW4Tdq*J4*W4T);
N5=(m5*W*V5*(dV5T*WT+V5T*dWT)+W5*J5*dW5T+W5*chachengxW5Tdq*J5*W5T);
N6=(m6*W*V6*(dV6T*WT+V6T*dWT)+W6*J6*dW6T+W6*chachengxW6Tdq*J6*W6T);
N=N1+N2+N3+N4+N5+N6;   %6*6����

q1=u(1);
q2=u(2);
q3=u(3);
q4=u(4);
q5=u(5);
q6=u(6);
q=[q1;q2;q3;q4;q5;q6];   %6*1����

dq1=u(7);
dq2=u(8);
dq3=u(9);
dq4=u(10);
dq5=u(11);
dq6=u(12);
dq=[dq1;dq2;dq3;dq4;dq5;dq6];   %6*1����

f=-inv(M)*N*dq;  %6*1����
b=inv(M);   %6*6����

%�����ǿ���������� ---------------------------------------
x1d=[cos(pi*t);sin(pi*t/2);sin(pi*t);sin(pi*t);cos(pi*t);cos(pi*t/2)];  %�����ĸ��ؽڽ��˶��켣   cos������
x1d0=[1;0;0;0;1;1];
dx1d=[-pi*sin(pi*t);pi/2*cos(pi*t/2);pi*cos(pi*t);pi*cos(pi*t);-pi*sin(pi*t);-pi/2*sin(pi*t/2)];   %�����ĸ��ؽڵĽ��ٶȹ켣
dx1d0=[0;pi/2;pi;pi;0;0];
ddx1d=[-pi*pi*cos(pi*t);-pi*pi/4*sin(pi*t/2);-pi*pi*sin(pi*t);-pi*pi*sin(pi*t);-pi*pi*cos(pi*t);-1/4*pi*pi*cos(pi*t/2)];%�ؽڼ��ٶȹ켣
ddx1d0=[-pi*pi;0;0;0;-pi*pi;-1/4*pi*pi];

Xd=[x1d;dx1d];   %�������˶��켣
X=[q;dq];  %12*1����
E=X-Xd;    %12*1����
e=q-x1d;   %6*1����
de=dq-dx1d;

q0=[1;0.5;0.5;1;1;1];   %��ʼ�ؽڽǶ�
dq0=[1;1;1;1;1;1];  %��ʼ�ؽڽ��ٶ�
ddq0=[0;0;0;0;0;0]; %�����ʼ�ؽڽǼ��ٶ�
e0=q0-x1d0;   
de0=dq0-dx1d0;
dde0=ddq0-ddx1d0;
hei1=[2 2 3 4 2 1];
C1=diag(hei1);  %6*6����
hei2=[2 2 1 1 2 1];
C2=diag(hei2);
C=[C1 C2];  %6*12     ��ƾ���
TTT=1.5;

p1=(e0(1)+de0(1)*t+1/2*dde0(1)*t^2+(-10/(TTT^3)*e0(1)-6/(TTT^2)*de0(1)-3/(2*TTT)*dde0(1))*t^3+(15/(TTT^4)*e0(1)+8/(TTT^3)*de0(1)+3/(2*TTT^2)*dde0(1))*t^4+(-6/(TTT^5)*e0(1)-3/(TTT^4)*de0(1)-1/(2*TTT^3)*dde0(1))*t^5);
p2=(e0(2)+de0(2)*t+1/2*dde0(2)*t^2+(-10/(TTT^3)*e0(2)-6/(TTT^2)*de0(2)-3/(2*TTT)*dde0(2))*t^3+(15/(TTT^4)*e0(2)+8/(TTT^3)*de0(2)+3/(2*TTT^2)*dde0(2))*t^4+(-6/(TTT^5)*e0(2)-3/(TTT^4)*de0(2)-1/(2*TTT^3)*dde0(1))*t^5);
p3=(e0(3)+de0(3)*t+1/2*dde0(3)*t^2+(-10/(TTT^3)*e0(3)-6/(TTT^2)*de0(3)-3/(2*TTT)*dde0(3))*t^3+(15/(TTT^4)*e0(3)+8/(TTT^3)*de0(3)+3/(2*TTT^2)*dde0(3))*t^4+(-6/(TTT^5)*e0(3)-3/(TTT^4)*de0(3)-1/(2*TTT^3)*dde0(1))*t^5);
p4=(e0(4)+de0(4)*t+1/2*dde0(4)*t^2+(-10/(TTT^3)*e0(4)-6/(TTT^2)*de0(4)-3/(2*TTT)*dde0(4))*t^3+(15/(TTT^4)*e0(4)+8/(TTT^3)*de0(4)+3/(2*TTT^2)*dde0(4))*t^4+(-6/(TTT^5)*e0(4)-3/(TTT^4)*de0(4)-1/(2*TTT^3)*dde0(1))*t^5);
p5=(e0(5)+de0(5)*t+1/2*dde0(5)*t^2+(-10/(TTT^3)*e0(5)-6/(TTT^2)*de0(5)-3/(2*TTT)*dde0(5))*t^3+(15/(TTT^4)*e0(5)+8/(TTT^3)*de0(5)+3/(2*TTT^2)*dde0(5))*t^4+(-6/(TTT^5)*e0(5)-3/(TTT^4)*de0(5)-1/(2*TTT^3)*dde0(1))*t^5);
p6=(e0(6)+de0(6)*t+1/2*dde0(6)*t^2+(-10/(TTT^3)*e0(6)-6/(TTT^2)*de0(6)-3/(2*TTT)*dde0(6))*t^3+(15/(TTT^4)*e0(6)+8/(TTT^3)*de0(6)+3/(2*TTT^2)*dde0(6))*t^4+(-6/(TTT^5)*e0(6)-3/(TTT^4)*de0(6)-1/(2*TTT^3)*dde0(1))*t^5);

dp1=de0(1)+dde0(1)*t+3*t^2*(-10/(TTT^3)*e0(1)-6/(TTT^2)*de0(1)-3/(2*TTT)*dde0(1))+4*t^3*(15/(TTT^4)*e0(1)+8/(TTT^3)*de0(1)+3/(2*TTT^2)*dde0(1))+5*t^4*(-6/(TTT^5)*e0(1)-3/(TTT^4)*de0(1)-1/(2*TTT^3)*dde0(1));
dp2=de0(2)+dde0(2)*t+3*t^2*(-10/(TTT^3)*e0(2)-6/(TTT^2)*de0(2)-3/(2*TTT)*dde0(2))+4*t^3*(15/(TTT^4)*e0(2)+8/(TTT^3)*de0(2)+3/(2*TTT^2)*dde0(2))+5*t^4*(-6/(TTT^5)*e0(2)-3/(TTT^4)*de0(2)-1/(2*TTT^3)*dde0(2));
dp3=de0(3)+dde0(3)*t+3*t^2*(-10/(TTT^3)*e0(3)-6/(TTT^2)*de0(3)-3/(2*TTT)*dde0(3))+4*t^3*(15/(TTT^4)*e0(3)+8/(TTT^3)*de0(3)+3/(2*TTT^2)*dde0(3))+5*t^4*(-6/(TTT^5)*e0(3)-3/(TTT^4)*de0(3)-1/(2*TTT^3)*dde0(3));
dp4=de0(4)+dde0(4)*t+3*t^2*(-10/(TTT^3)*e0(4)-6/(TTT^2)*de0(4)-3/(2*TTT)*dde0(4))+4*t^3*(15/(TTT^4)*e0(4)+8/(TTT^3)*de0(4)+3/(2*TTT^2)*dde0(4))+5*t^4*(-6/(TTT^5)*e0(4)-3/(TTT^4)*de0(4)-1/(2*TTT^3)*dde0(4));
dp5=de0(5)+dde0(5)*t+3*t^2*(-10/(TTT^3)*e0(5)-6/(TTT^2)*de0(5)-3/(2*TTT)*dde0(5))+4*t^3*(15/(TTT^4)*e0(5)+8/(TTT^3)*de0(5)+3/(2*TTT^2)*dde0(5))+5*t^4*(-6/(TTT^5)*e0(5)-3/(TTT^4)*de0(5)-1/(2*TTT^3)*dde0(5));
dp6=de0(6)+dde0(6)*t+3*t^2*(-10/(TTT^3)*e0(6)-6/(TTT^2)*de0(6)-3/(2*TTT)*dde0(6))+4*t^3*(15/(TTT^4)*e0(6)+8/(TTT^3)*de0(6)+3/(2*TTT^2)*dde0(6))+5*t^4*(-6/(TTT^5)*e0(6)-3/(TTT^4)*de0(6)-1/(2*TTT^3)*dde0(6));

ddp1=dde0(1)+6*t*(-10/(TTT^3)*e0(1)-6/(TTT^2)*de0(1)-3/(2*TTT)*dde0(1))+12*t^2*(15/(TTT^4)*e0(1)+8/(TTT^3)*de0(1)+3/(2*TTT^2)*dde0(1))+20*t^3*(-6/(TTT^5)*e0(1)-3/(TTT^4)*de0(1)-1/(2*TTT^3)*dde0(1));
ddp2=dde0(2)+6*t*(-10/(TTT^3)*e0(2)-6/(TTT^2)*de0(2)-3/(2*TTT)*dde0(2))+12*t^2*(15/(TTT^4)*e0(2)+8/(TTT^3)*de0(2)+3/(2*TTT^2)*dde0(2))+20*t^3*(-6/(TTT^5)*e0(2)-3/(TTT^4)*de0(2)-1/(2*TTT^3)*dde0(2));
ddp3=dde0(3)+6*t*(-10/(TTT^3)*e0(3)-6/(TTT^2)*de0(3)-3/(2*TTT)*dde0(3))+12*t^2*(15/(TTT^4)*e0(3)+8/(TTT^3)*de0(3)+3/(2*TTT^2)*dde0(3))+20*t^3*(-6/(TTT^5)*e0(3)-3/(TTT^4)*de0(3)-1/(2*TTT^3)*dde0(3));
ddp4=dde0(4)+6*t*(-10/(TTT^3)*e0(4)-6/(TTT^2)*de0(4)-3/(2*TTT)*dde0(4))+12*t^2*(15/(TTT^4)*e0(4)+8/(TTT^3)*de0(4)+3/(2*TTT^2)*dde0(4))+20*t^3*(-6/(TTT^5)*e0(4)-3/(TTT^4)*de0(4)-1/(2*TTT^3)*dde0(4));
ddp5=dde0(5)+6*t*(-10/(TTT^3)*e0(5)-6/(TTT^2)*de0(5)-3/(2*TTT)*dde0(5))+12*t^2*(15/(TTT^4)*e0(5)+8/(TTT^3)*de0(5)+3/(2*TTT^2)*dde0(5))+20*t^3*(-6/(TTT^5)*e0(5)-3/(TTT^4)*de0(5)-1/(2*TTT^3)*dde0(5));
ddp6=dde0(6)+6*t*(-10/(TTT^3)*e0(6)-6/(TTT^2)*de0(6)-3/(2*TTT)*dde0(6))+12*t^2*(15/(TTT^4)*e0(6)+8/(TTT^3)*de0(6)+3/(2*TTT^2)*dde0(6))+20*t^3*(-6/(TTT^5)*e0(6)-3/(TTT^4)*de0(6)-1/(2*TTT^3)*dde0(6));
if (t<1.5)
    p=[p1;p2;p3;p4;p5;p6];          %6*1����
    dp=[dp1;dp2;dp3;dp4;dp5;dp6];   %6*1����
    P=[p;dp];    %12*1����
    Wt=C*P;      %6*1����
    lin=C*E-Wt;  %6*1����
    ddp=[ddp1;ddp2;ddp3;ddp4;ddp5;ddp6];   %6*1����
    K=1;
    C2lin=C2'*lin;  %6*1����
    bbb=(norm(C2lin,2))+0.03+2*norm(e,2);
    ss=C2lin/(bbb);
    ut=-inv(b)*(f-ddx1d-ddp+inv(C2)*C1*(de-dp))-inv(b)*ss*K;
else
    p=[0;0;0;0;0;0];          %6*1����
    dp=[0;0;0;0;0;0];   %6*1����
    P=[p;dp];    %12*1����
    Wt=C*P;      %6*1����
    lin=C*E-Wt;  %6*1����
    ddp=[0;0;0;0;0;0];   %6*1����
    K=10;
    C2lin=C2'*lin;  %6*1����
    bbb=(norm(C2lin,2))+1+20*norm(e,2);
    ss=C2lin/(bbb);
    ut=-inv(b)*(f-ddx1d-ddp+inv(C2)*C1*(de-dp))-inv(b)*ss*K;
end
ut1=ut(1,:);
ut2=ut(2,:);
ut3=ut(3,:);
ut4=ut(4,:);
ut5=ut(5,:);
ut6=ut(6,:);
sys(1)=ut1;
sys(2)=ut2;
sys(3)=ut3;
sys(4)=ut4;
sys(5)=ut5;
sys(6)=ut6;

