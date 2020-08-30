function [T] = Forward_kinematics_POE(q)
%以下程序是根据指数积公式POE建立的正运动学
%输入六个关节角为实际转动的关节角，CRP的零位关节角为[0;pi/2;0;0;pi/2;0]
%初始位形时，末端位姿M相对于基坐标系
M = [1 0 0 -0.0261;
     0 1 0 -1.1863;  
     0 0 1 -0.6540; 
     0 0 0 1];
%相对基坐标系的螺旋轴
w1 = [0;0;1]; %沿关节轴正向的单位向量 相对于基坐标系
w2 = [0;-1;0];
w3 = [0;-1;0];
w4 = [-1;0;0];
w5 = [0;1;0];
w6 = [0;0;1];

q1 = [0;0;0]; %qn是关节轴上任一点 坐标值在基坐标系中进行度量
q2 = [-0.1573;0.0653;0] ;
q3 = [-0.2037;-0.5483;-0.0165] ;
q4 = [-0.1518;-0.7154;-0.3140] ;
q5 = [-0.1081;-0.6714;-0.6685] ;
q6 = [-0.0261;-1.1863;-0.6540] ;

v1 = -cross(w1,q1); %线速度
v2 = -cross(w2,q2);
v3 = -cross(w3,q3);
v4 = -cross(w4,q4);
v5 = -cross(w5,q5);
v6 = -cross(w6,q6);

R1 = [0 -w1(3) w1(2);w1(3) 0 -w1(1);-w1(2) w1(1) 0]; %转轴的反对称矩阵
R2 = [0 -w2(3) w2(2);w2(3) 0 -w2(1);-w2(2) w2(1) 0];
R3 = [0 -w3(3) w3(2);w3(3) 0 -w3(1);-w3(2) w3(1) 0];
R4 = [0 -w4(3) w4(2);w4(3) 0 -w4(1);-w4(2) w4(1) 0];
R5 = [0 -w5(3) w5(2);w5(3) 0 -w5(1);-w5(2) w5(1) 0];
R6 = [0 -w6(3) w6(2);w6(3) 0 -w6(1);-w6(2) w6(1) 0];

G1 = eye(3)*q(1) + (1-cos(q(1)))*R1 + (q(1)-sin(q(1)))*R1^2;  
G2 = eye(3)*q(2) + (1-cos(q(2)))*R2 + (q(2)-sin(q(2)))*R2^2;
G3 = eye(3)*q(3) + (1-cos(q(3)))*R3 + (q(3)-sin(q(3)))*R3^2;
G4 = eye(3)*q(4) + (1-cos(q(4)))*R4 + (q(4)-sin(q(4)))*R4^2;
G5 = eye(3)*q(5) + (1-cos(q(5)))*R5 + (q(5)-sin(q(5)))*R5^2;
G6 = eye(3)*q(6) + (1-cos(q(6)))*R6 + (q(6)-sin(q(6)))*R6^2;

Rot1 = eye(3) + sin(q(1))*R1 + (1-cos(q(1)))*R1^2;  %刚体转动的矩阵指数
Rot2 = eye(3) + sin(q(2))*R2 + (1-cos(q(2)))*R2^2; 
Rot3 = eye(3) + sin(q(3))*R3 + (1-cos(q(3)))*R3^2;
Rot4 = eye(3) + sin(q(4))*R4 + (1-cos(q(4)))*R4^2; 
Rot5 = eye(3) + sin(q(5))*R5 + (1-cos(q(5)))*R5^2;
Rot6 = eye(3) + sin(q(6))*R6 + (1-cos(q(6)))*R6^2; 

eS1 = [Rot1 G1*v1 ;0 0 0 1];%刚体运动的矩阵指数
eS2 = [Rot2 G2*v2 ;0 0 0 1];
eS3 = [Rot3 G3*v3 ;0 0 0 1];
eS4 = [Rot4 G4*v4 ;0 0 0 1];
eS5 = [Rot5 G5*v5 ;0 0 0 1];
eS6 = [Rot6 G6*v6 ;0 0 0 1];


T = eS1*eS2*eS3*eS4*eS5*eS6*M;


end