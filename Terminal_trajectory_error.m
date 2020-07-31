%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�˳�����YHXCRP14_Trajectory.slx��SevenTrajectory.m��������֮��������
%�����ڵõ��켣�滮ĩ�˹켣��xyz�����ϵ����
k = 100;  %�Ƚϵĵ���
errorx = zeros(1,k);
errory = zeros(1,k);
errorz = zeros(1,k);
Tx = zeros(1,k);
Ty = zeros(1,k);
Tz = zeros(1,k);
%ĩ�˹켣

for i=1:1:100
    disp(i)
    Fq1 = q1.Data(1+10*(i-1));
    Fq2 = q2.Data(1+10*(i-1));
    Fq3 = q3.Data(1+10*(i-1));
    Fq4 = q4.Data(1+10*(i-1));
    Fq5 = q5.Data(1+10*(i-1));
    Fq6 = q6.Data(1+10*(i-1));
    Tout= YHXFKSolver([Fq1;Fq2;Fq3;Fq4;Fq5;Fq6]);
    Tx(:,i) = Tout(13);
    Ty(:,i) = Tout(14);
    Tz(:,i) = Tout(15);
    
    errorx(:,i) = Tx(:,i) - lx(:,i);  %ʵ��λ�� - ����λ��
    errory(:,i) = Ty(:,i) - ly(:,i);
    errorz(:,i) = Tz(:,i) - lz(:,i);
 
end
m = 1:1:k;
h = figure(1);
set(h,'NumberTitle','off','name','xyz�����ϵ�ʵ��·����·��λ�����')

%ʵ�ʵõ�xyz�����ϵ��������
subplot(2,3,1)
plot(m, Tx,'LineWidth',1.5,'color','b');
xlabel('ʵ��λ��','FontName','����','FontSize',12);
ylabel('���ֵ','FontName','����','FontSize',12);
set(gca,'YLim',[min(Tx)-(max(Tx)-min(Tx))/10 max(Tx)+(max(Tx)-min(Tx))/10]);
axis square
grid on;
title('x�����Ϲ켣����','FontName','����','FontSize',12)
hold on

subplot(2,3,2)
plot(m, Ty,'LineWidth',1.5,'color','b');
xlabel('ʵ��λ��','FontName','����','FontSize',12);
ylabel('���ֵ','FontName','����','FontSize',12);
set(gca,'YLim',[min(Ty)-(max(Ty)-min(Ty))/10 max(Ty)+(max(Ty)-min(Ty))/10]);
axis square
grid on;
title('y�����Ϲ켣����','FontName','����','FontSize',12)
hold on

subplot(2,3,3)
plot(m, Tz,'LineWidth',1.5,'color','b');
xlabel('ʵ��λ��','FontName','����','FontSize',12);
ylabel('���ֵ','FontName','����','FontSize',12);
set(gca,'YLim',[min(Tz)-(max(Tz)-min(Tz))/10 max(Tz)+(max(Tz)-min(Tz))/10]);
axis square
grid on;
title('z�����Ϲ켣����','FontName','����','FontSize',12)
hold on

%ʵ��xyz������xyz�Ĺ켣�������
subplot(2,3,4)
plot(m, errorx,'LineWidth',1.5,'color','b');
xlabel('λ�����','FontName','����','FontSize',12);
ylabel('���ֵ','FontName','����','FontSize',12);
set(gca,'YLim',[min(errorx)-(max(errorx)-min(errorx))/10 max(errorx)+(max(errorx)-min(errorx))/10]);
axis square
grid on;
title('x�������������','FontName','����','FontSize',12)
hold on

subplot(2,3,5)
plot(m, errory,'LineWidth',1.5,'color','b');
xlabel('λ�����','FontName','����','FontSize',12);
ylabel('���ֵ','FontName','����','FontSize',12);
set(gca,'YLim',[min(errory)-(max(errory)-min(errory))/10 max(errory)+(max(errory)-min(errory))/10]);
axis square
grid on;
title('y�������������','FontName','����','FontSize',12)
hold on

subplot(2,3,6)
plot(m, errorz,'LineWidth',1.5,'color','b');
xlabel('λ�����','FontName','����','FontSize',12);
ylabel('���ֵ','FontName','����','FontSize',12);
set(gca,'YLim',[min(errorz)-(max(errorz)-min(errorz))/10 max(errorz)+(max(errorz)-min(errorz))/10]);
axis square
grid on;
title('z�������������','FontName','����','FontSize',12)


    