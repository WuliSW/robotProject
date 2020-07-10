%�����ǹ������˶�ѧ��Ⲣ�ԽǶ��������ĳ���
function[] = IKSolver_lineanalyse(delta)
tic
%mΪ�ڼ����ؽڽ�1-6   deltaΪ�ӵĽǶ����ֵ 0.1 or 0.2
qd = [0.5;0.5;0.5;0.5;0.5;0.5];    %ֻ��������λ����
q0 = [0;0;0;0;0;0]; %��ʼλ��ȥ�ƽ�

%������ʽ��ʼ --------------
Td = FKSolver(qd);     %����һ����ʼλ��Td
m = 1:1:28;
distance = -0.03;
qd_delta1 = q0; 
qd1= zeros(6,28);
q_delta = zeros(6,28);   %Ԥ�����ڴ�

for  n = 1:1:28     %������Ϊֱ��  �ֱ��ڸ����ϵĵ�һ�����������ģ��壬�����ؽڽ��ϼ������0.1��
    disp(n)
    Td(13) = Td(13)+distance;   %�õ�ƫ��λ��Td'
    Td(14) = Td(14)+distance;
    Td(15) = Td(15)+distance;
    qd1(:,n) = IKSolver(qd_delta,Td);   %���ʼ�ĵ������ؽڽ� ��Ϊ��һ��  --- ��һ��������
    qdd= qd1(:,n); 
    qdd(1) = qdd(1)+delta;   %��ĳһ���ؽڽ��ϼ������ delta 
%     qdd(2) = qdd(2)+0.2;   %��ĳһ���ؽڽ��ϼ������ delta    
%     qdd(3) = qdd(3)+0.2;   %��ĳһ���ؽڽ��ϼ������ delta    
    
    Tdd = FKSolver(qdd);   %�����λ����̬
    qd_delta = IKSolver(qd_delta, Tdd);  %����ϽǶ�����ĵ�Ĺؽڽ�  --  �ڶ���������
    q_delta(:,n) = qd_delta - qd1(:,n);      %���ʼ��Ĺؽڽ����
    
    Td(13) = Td(13)-distance;   %�ص���ʼ��
    Td(14) = Td(14)-distance;
    Td(15) = Td(15)-distance;
    
    distance = -0.03+n*0.002;
    qd_delta1 = qd_delta;
end

 h = figure(1);
set(h,'NumberTitle','off','name','�ڵ�n���ؽڽ��ϼ���0.1rad����ؽڵ����ֵ')

subplot(2,3,1)
plot(m, q_delta(1,:),'r*');
xlabel('����');
ylabel('���ֵ');
axis square
grid on;
title('��1�ؽڽ��������','FontName','����','FontSize',12)

subplot(2,3,2)
plot(m, q_delta(2,:),'r*');
xlabel('����');
ylabel('���ֵ');
axis square
grid on;
title('��2�ؽڽ��������','FontName','����','FontSize',12)

subplot(2,3,3)
plot(m, q_delta(3,:),'r*');
xlabel('����');
ylabel('���ֵ');
axis square
grid on;
title('��3�ؽڽ��������','FontName','����','FontSize',12)

subplot(2,3,4)
plot(m, q_delta(4,:),'r*');
xlabel('����');
ylabel('���ֵ');
axis square
grid on;
title('��4�ؽڽ��������','FontName','����','FontSize',12)

subplot(2,3,5)
plot(m, q_delta(5,:),'r*');
xlabel('����');
ylabel('���ֵ');
axis square
grid on;
title('��5�ؽڽ��������','FontName','����','FontSize',12)

subplot(2,3,6)
plot(m, q_delta(6,:),'r*');
xlabel('����');
ylabel('���ֵ');
axis square
grid on;
title('��6�ؽڽ��������','FontName','����','FontSize',12)
toc
end



