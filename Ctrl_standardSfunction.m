function [sys,x0,str,ts] = Ctrl_standardSfunction(t,x,u,flag)
switch flag
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1
    sys=mdlDerivatives(t,x,u);
  case {2,4,9}
    sys=[];
  case 3
    sys=mdlOutputs(t,x,u);
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end
function [sys,x0,str,ts]=mdlInitializeSizes   %ϵͳ�ĳ�ʼ��
sizes = simsizes;
sizes.NumContStates  = 0;   %����ϵͳ����״̬�ı���
sizes.NumDiscStates  = 0;   %����ϵͳ��ɢ״̬�ı���
sizes.NumOutputs     = 4;   %����ϵͳ����ı���
sizes.NumInputs      = 4;   %����ϵͳ����ı���
sizes.DirFeedthrough = 1;   %���������������Ժ��������u����Ӧ�ý�����������Ϊ1
sizes.NumSampleTimes = 0;   % ģ��������ڵĸ���
                            % ��Ҫ������ʱ�䣬һ��Ϊ1.
                            % �²�Ϊ���Ϊn������һʱ�̵�״̬��Ҫ֪��ǰn��״̬��ϵͳ״̬
sys = simsizes(sizes);
x0  = [];                   % ϵͳ��ʼ״̬����
str = [];                   % ��������������Ϊ��
ts  = [];                   % ����ʱ��[t1 t2] t1Ϊ�������ڣ����ȡt1=-1�򽫼̳������źŵĲ������ڣ�����t2Ϊƫ������һ��ȡΪ0
 
    
function sys=mdlOutputs(t,x,u)   %���������ݣ�ϵͳ���
T1=-f/g;
T2=(a1*E5*th^(E5-1)*dth^2*k^2-E2*k^(1-q1/p1)*dth^(2-q1/p1))/(g*k);
 if dth^(q1/p1-1)<=tao;
    miu=sin(pi/2*dth^(q1/p1-1)/tao);
 else 
     miu=1;
 end
T3=-1/g*E2*k^(-q1/p1)*(a2*s^E3+belta2*s^E4)*dth^(1-q1/p1)*miu;
ut=T1+T2+T3;

sys(1)=ut;

