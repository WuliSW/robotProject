function [ q ] = IKSolver(q_begin, T_d)
%���˶�ѧ
%�����ʼ�Ƕȡ�Ŀ��λ�˱任����  
%���������ֵ������ʵ������ֵ�е㲻һ������Ϊ���˶�ѧ���
%�����ʼ�Ƕ�q_begin�������ǶȱȽϽӽ������Ϊ�����Ƕ�
%������ĽǶ����ʼ�Ƕ��й�
%����ΪĿ��λ�������0����ϵ����α任����
Tx = [0, -0.1573, -0.0165, -0.2975, -0.3545, 0.0820];%Tx = [0, 0.1949, 1.0938e-04, 0.2000, 0, -4.7162e-04];
Ty = [0, 0.0653, 0.0464, -0.0519, 0.0440, -0.0145];%Ty = [0, -0.0951, -0.6137, 0.2750, 0.0320, 0.0981];
Tz = [0, 0, 0.6136, 0.1671, -0.0437, -0.5149];%Tz = [0, 0, 0.0030, 0.1105, 0.3650, 0.0540];
alpha = [0, -pi/2, 0, -pi/2, pi/2, -pi/2];
q = q_begin;  %��ʼ�Ƕ�
error = zeros(500,1);
error1 = zeros(500,1);
error2 = zeros(500,1);
error3 = zeros(500,1);
error4 = zeros(500,1);
    
for i = 1:1:1000  %ѭ������1000��
    %����λ�����
    %����ͨ�����˶�ѧ�������ǰλ��
    %ÿ���ؽ������ǰһ�ؽ�����ϵ�ı任����
%     T{1} = transl(Tx(1), Ty(1), Tz(1))*trotx(alpha(1))*troty(0)*trotz(q(1));
%     T{2} = transl(Tx(2), Ty(2), Tz(2))*trotx(alpha(2))*troty(0)*trotz(q(2));
%     T{3} = transl(Tx(3), Ty(3), Tz(3))*trotx(alpha(3))*troty(0)*trotz(q(3)-pi/2);
%     T{4} = transl(Tx(4), Ty(4), Tz(4))*trotx(alpha(4))*troty(0)*trotz(q(4));
%     T{5} = transl(Tx(5), Ty(5), Tz(5))*trotx(alpha(5))*troty(0)*trotz(q(5));
%     T{6} = transl(Tx(6), Ty(6), Tz(6))*trotx(alpha(6))*troty(0)*trotz(q(6));
%     
%     %ĩ�˹ؽ�����ڹ���ϵ0�ı任����
%     T06c = T{1}*T{2}*T{3}*T{4}*T{5}*T{6};   %��õ�ǰ�Ƕȵ���α任����
    T06c = FKSolver(q);
    f1 = T06c(1, 4) - T_d(1, 4);
    f2 = T06c(2, 4) - T_d(2, 4);
    f3 = T06c(3, 4) - T_d(3, 4);
    f4 = T06c(2, 3) - T_d(2, 3);
    f5 = T06c(3, 3) - T_d(3, 3);
    f6 = T06c(3, 2) - T_d(3, 2);
    f7 = T06c(1, 1) - T_d(1, 1);
    f8 = T06c(1, 2) - T_d(1, 2);
    f9 = T06c(1, 3) - T_d(1, 3);
    f10 = T06c(2, 1) - T_d(2, 1);
    f11 = T06c(2, 2) - T_d(2, 2);
    f12 = T06c(3, 1) - T_d(3, 1);
    F = [f1; f2; f3; f4; f5; f6; f7; f8; f9; f10; f11; f12];
    FF = [f1;f2;f3];
    FFF = [f4;f5;f6];
    FFFF = [f7;f8;f9];
    FFFFF = [f10;f11;f12];
    
    J = Jacob(q, T_d);
    q = q - inv(J'*J)*J'*F;
    q = mod(q, 2*pi);   % 6*1����
    for j = 1:6
        if abs(q(j)) > pi
            q(j) = q(j) - 2*pi;
        end
    end
    disp(i)
    error(i) = norm(F);
    error1(i) = norm(FF);
    error2(i) = norm(FFF);
    error3(i) = norm(FFFF);
    error4(i) = norm(FFFFF);
    errorr = norm(F)
    
    if i>500
        q = -1;
        break
    end
    if i>4
        a = double(vpa(error(i),4));
        b = double(vpa(error(i-1),4));
        c = double(vpa(error(i-2),4));
        if a == b&&b == c %�����������ѭ���� ����������������ѭ��
            q = -1;
            break
        end
    end
    if error(i) < 0.001&&error1(i) < 0.001&&error2(i) < 0.001&&error3(i) < 0.001&&error4(i) < 0.001
            disp('������')
        break
    end
    
end
    

end

