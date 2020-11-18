function [sys,x0,str,ts] = Plant_standardSfunction(t,x,u,flag)
switch flag
  case 0 %��ʼ��
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1 %����״̬����
    sys=mdlDerivatives(t,x,u);
  case {2,4,9} %��ɢ״̬���㣬��һ������ʱ�̣���ֹ�����趨
    sys=[];
  case 3 %����źż���
    sys=mdlOutputs(t,x,u);
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end
function [sys,x0,str,ts]=mdlInitializeSizes   %ϵͳ�ĳ�ʼ��
sizes = simsizes;
sizes.NumContStates  = 4;   %����ϵͳ����״̬�ı���
sizes.NumDiscStates  = 0;   %����ϵͳ��ɢ״̬�ı���
sizes.NumOutputs     = 4;   %����ϵͳ����ı���
sizes.NumInputs      = 4;   %����ϵͳ����ı���
sizes.DirFeedthrough = 0;   %���������������Ժ��������u����Ӧ�ý�����������Ϊ1
sizes.NumSampleTimes = 0;   % ģ��������ڵĸ���
                            % ��Ҫ������ʱ�䣬һ��Ϊ1.
                            % �²�Ϊ���Ϊn������һʱ�̵�״̬��Ҫ֪��ǰn��״̬��ϵͳ״̬
sys = simsizes(sizes);
x0  = [0.5  -0.5 0 0];            % ϵͳ��ʼ״̬����
str = [];                   % ��������������Ϊ��
ts  = [];                   % ����ʱ��[t1 t2] t1Ϊ�������ڣ����ȡt1=-1�򽫼̳������źŵĲ������ڣ�����t2Ϊƫ������һ��ȡΪ0


function sys=mdlDerivatives(t,x,u)  %�ú�����������ϵͳ�б����ã����ڲ�������ϵͳ״̬�ĵ���
Uu = u(1);
Uv = u(2);
Uw = u(3);
TL = u(4);
iu=x(1);
iv=x(2);
iw=x(3);
dtheta=x(4);
%ϵͳ�����Ķ���
R = 5.6;
L = 11.57;
faif = 0.125;
Pn = 4;
J1 = 0.384*10e-4;
Tn = 1.47;
N = 4000;
Je = 1.25*10e-6;
J = J1+Je;
B1 = 0;
Be = 0.001;
B = B1+Be;
M = 1; %����
xite = (L-M)*(L+2*M);
global theta;
theta = theta + dtheta * 0.0001;
a = faif * sin(theta);
b = faif * sin(theta-2*pi/3);
c = faif * sin(theta+2*pi/3);
T =[(-L*R-M*R)/xite  M*R/xite  M*R/xite (L*a+M*a-M*b-M*c)/xite;
    M*R/xite (-L*R-M*R)/xite M*R/xite (-M*a+L*b+M*b-M*c)/xite;
    M*R/xite M*R/xite (-L*R-M*R)/xite (-M*a-M*b+L*c+M*c)/xite;
    -a/J -b/J -c/J -B/J];  %4*4

amp = [(L*Uu+M*Uu-M*Uv-M*Uw)/xite; (-M*Uu+L*Uv+M*Uv-M*Uw)/xite; (-M*Uu-M*Uv+L*Uw+M*Uw)/xite; -TL/J];  %4*1
th = [iu; iv; iw; dtheta];  %4*1  iu iv iw dtheta

%�˶�����
dth=T*th+amp;

sys(1)=dth(1);   
sys(2)=dth(2);   
sys(3)=dth(3);   
sys(4)=dth(4);  

function sys=mdlOutputs(t,x,u)   %���������ݣ�ϵͳ���
sys(1)=x(1);   %iu
sys(2)=x(2);   %iv
sys(3)=x(3);   %iw
sys(4)=x(4);   %dtheta



