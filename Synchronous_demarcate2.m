%�˳���Ϊ��ʶ���������ת������
function [sys,x0,str,ts] = Synchronous_demarcate2(t,x,u,flag)
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
sizes.NumOutputs     = 1;   %����ϵͳ����ı���
sizes.NumInputs      = 4;   %����ϵͳ����ı���
sizes.DirFeedthrough = 1;   %���������������Ժ��������u����Ӧ�ý�����������Ϊ1,���벻ֱ�Ӵ��������
sizes.NumSampleTimes = 1;   % ģ��������ڵĸ���
                            % ��Ҫ������ʱ�䣬һ��Ϊ1.
                            % �²�Ϊ���Ϊn������һʱ�̵�״̬��Ҫ֪��ǰn��״̬��ϵͳ״̬
sys = simsizes(sizes);
x0  = [];            % ϵͳ��ʼ״̬����
str = [];                   % ��������������Ϊ��
ts  = [0 0];                   % ����ʱ��[t1 t2] t1Ϊ�������ڣ����ȡt1=-1�򽫼̳������źŵĲ������ڣ�����t2Ϊƫ������һ��ȡΪ0

global  P_past theta_past
P_past = 1e4 * eye(1,1);
theta_past = 0;

function sys=mdlOutputs(t,x,u)   %���������ݣ�ϵͳ���
%��ֵ��ȷ��
lambda = 1;
B = 0;%0.001;
global   P_past theta_past
Te = u(1);
TL = u(2);
dw = u(3);
wr = u(4);
xt = dw;
y = Te - TL -wr*B;
P_new = 1/lambda*(P_past-(P_past*(xt'*xt)*P_past)/(lambda+xt*P_past*xt'));
L = P_past*xt'/(lambda+xt*P_past*xt');
theta_new = theta_past + L*(y-xt*theta_past);
a = theta_new(1);
J = a;
P_past = P_new ;
theta_past = theta_new;
sys(1) = J;






