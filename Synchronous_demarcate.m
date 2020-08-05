%�˳���Ϊ��ʶ��������Ķ��ӵ���Rs, �������ͨfaif, dq����L
function [sys,x0,str,ts] = Synchronous_demarcate(t,x,u,flag)
switch flag,
  case 0, %��ʼ��
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 2 %��ɢ״̬���㣬��һ������ʱ�̣���ֹ�����趨
    sys=[];%mdlUpdates(t,x,u);
  case 3, %����źż���
    sys=mdlOutputs(t,x,u);
  case {1,4,9}, %����źż���
    sys=[];
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end

function [sys,x0,str,ts]=mdlInitializeSizes   %ϵͳ�ĳ�ʼ��
sizes = simsizes;
sizes.NumContStates  = 0;   %����ϵͳ����״̬�ı���
sizes.NumDiscStates  = 0;   %����ϵͳ��ɢ״̬�ı���
sizes.NumOutputs     = 3;   %����ϵͳ����ı���
sizes.NumInputs      = 5;   %����ϵͳ����ı���
sizes.DirFeedthrough = 1;   %���������������Ժ��������u����Ӧ�ý�����������Ϊ1,���벻ֱ�Ӵ��������
sizes.NumSampleTimes = 1;   % ģ��������ڵĸ���
                            % ��Ҫ������ʱ�䣬һ��Ϊ1.
                            % �²�Ϊ���Ϊn������һʱ�̵�״̬��Ҫ֪��ǰn��״̬��ϵͳ״̬
sys = simsizes(sizes);
x0  = [];            % ϵͳ��ʼ״̬����
str = [];                   % ��������������Ϊ��
ts  = [0 0];                   % ����ʱ��[t1 t2] t1Ϊ�������ڣ����ȡt1=-1�򽫼̳������źŵĲ������ڣ�����t2Ϊƫ������һ��ȡΪ0

global  P_past theta_past
P_past = 1e4 * eye(3,3);
theta_past = [0;0;10000];

function sys=mdlOutputs(t,x,u)   %���������ݣ�ϵͳ���
%��ֵ��ȷ��
lambda = 1;  %�������ӣ� ѡ������
global   P_past theta_past
id = u(1);
iq = u(2);
w = u(3);
diq = u(4);
uq = u(5);
xt = [-iq -w uq];
y = diq+w*id;
P_new = 1/lambda*(P_past-(P_past*(xt'*xt)*P_past)/(lambda+xt*P_past*xt'));
L = P_past*xt'/(lambda+xt*P_past*xt');
theta_new = theta_past + L*(y-xt*theta_past);
a = theta_new(1);
b = theta_new(2);
c = theta_new(3);
R = a/c;
Ke = b/c;
Ld = 1/c;
P_past = P_new ;
theta_past = theta_new;
sys(1) = R;
sys(2) = Ke;
sys(3) = Ld;






