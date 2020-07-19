%�����ǹ������˶�ѧ��Ⲣ�ԽǶ��������ĳ���
function[] = IKSolver_large_scale(delta)
tic
%�����õ���mΪ�ڼ����ؽڽ�1-6   deltaΪ�ӵĽǶ����ֵ 0.1 or 0.2
qd = [0.5;0.5;0.5;0.5;0.5;0.5];    %��ʼλ��
q0 = [0;0;0;0;0;0];             %��ʼλ��ȥ�ƽ�
qd2 = [1;2;3;4;5;6];          %ĩ��λ�õ�

Td = FKSolver(qd);     %����һ����ʼλ��Td
Td2 = FKSolver(qd2);   %����һ��ĩ��λ��Td2
point = 30;     %����
m = 1:1:point;  
%��Ҫ�����Ŀ���      ����λ�õ�֮��ľ���
xdistance = Td2(13)-Td(13);
ydistance = Td2(14)-Td(14);
zdistance = Td2(15)-Td(15);
qd_delta1 = q0; 
qd1= zeros(6,point);
q_delta = zeros(6,point);   %Ԥ�����ڴ�
xevery_point = xdistance/point;
yevery_point = ydistance/point;
zevery_point = zdistance/point;

for  n = 1:1:point     %ֱ�ߵ�����  
    disp(n)
    qd1(:,n) = IKSolver(qd_delta1,Td);   %�Գ�ʼ�ĵ������ؽڽ� ��Ϊ��һ��  --- ��һ��������  qd_delta1 = q0
    if(qd1(:,n)==-1)
        q_delta(:,n)=[-0.1;-0.1;-0.1;-0.1;-0.1;-0.1];  %�������ⲻ�������߲��ڹ����ռ䷶Χ������������Щ���ʾ-0.1
        continue
    end
    qdd= qd1(:,n); 
    qdd(1) = qdd(1)+delta;   %�ڵ�һ���ؽڽ��ϼ������ delta 
    qdd(2) = qdd(2)+delta;   %�ڵڶ����ؽڽ��ϼ������ delta    
    qdd(3) = qdd(3)+delta;   %�ڵ������ؽڽ��ϼ������ delta    
    qdd(4) = qdd(4)+delta;   %�ڵ��ĸ��ؽڽ��ϼ������ delta 
    qdd(5) = qdd(5)+delta;   %�ڵ�����ؽڽ��ϼ������ delta    
%     qdd(6) = qdd(6)+delta;   %��ĳ�����ؽڽ��ϼ������ delta 
    
    Tdd = FKSolver(qdd);   %�����λ����̬
    qd_delta = IKSolver(qd1(:,n), Tdd);  %����ϽǶ�����ĵ�Ĺؽڽ�  --  �ڶ���������  qd1(:,n) = q0
    if(qd_delta==-1)
        q_delta(:,n)=[-0.1;-0.1;-0.1;-0.1;-0.1;-0.1];  %�������ⲻ�������߲��ڹ����ռ䷶Χ������������Щ���ʾ-0.1
        continue
    end
    q_delta(:,n) = qd_delta - qd1(:,n);      %���ʼ��Ĺؽڽ����
    qd_delta1 = qd_delta;
    Td(13) = Td(13)+xevery_point;   %ÿ�����xyzƫ�����
    Td(14) = Td(14)+yevery_point;
    Td(15) = Td(15)+zevery_point;
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



