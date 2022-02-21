
%% Gradient-Bandit policy
alpha = 0.1;
H=zeros(1,100,1001,2);
PI=zeros(1,100,1000,2);
R_H=zeros(1,100,1001);
for n=1
    for i=1:100
        for k=1:1000
            PI(n,i,k,1)=exp(H(n,i,k,1))/(exp(H(n,i,k,1))+exp(H(n,i,k,2)));
            PI(n,i,k,2)=exp(H(n,i,k,2))/(exp(H(n,i,k,1))+exp(H(n,i,k,2)));
            if rand(1)<PI(n,i,k,1)
                reward = sqrt(10).*randn(1) + 5;
                R_H(n,i,k+1)=reward/k+R_H(n,i,k)*((k-1)/k);
                H(n,i,k+1,1)=H(n,i,k,1)+alpha*(reward-R_H(n,i,k+1))*(1-PI(n,i,k,1));
                H(n,i,k+1,2)=H(n,i,k,2)-alpha*(reward-R_H(n,i,k+1))*PI(n,i,k,2);
            else
                if rand(1)>0.5
                    reward = sqrt(15).*randn(1) + 10;
                else
                    reward = sqrt(10).*randn(1) + 4;
                end
                R_H(n,i,k+1)=reward/k+R_H(n,i,k)*((k-1)/k);
                H(n,i,k+1,2)=H(n,i,k,2)+alpha*(reward-R_H(n,i,k+1))*(1-PI(n,i,k,2));
                H(n,i,k+1,1)=H(n,i,k,1)-alpha*(reward-R_H(n,i,k+1))*PI(n,i,k,1);
            end
        end
    end
end

R_H_acc=R_H;
R_H_acc=sum(R_H_acc,2)./100;
H=sum(H,2)./100;
save('project_1_c_R_H.mat','R_H');
save('project_1_c_H.mat','H');

figure(1),plot(1:1001,squeeze(R_H_acc(1,1,:)),'-b')
hold on

%% 𝜖-greedy
alpha = 0.1;
epsilon=0.1;
Q=zeros(1,100,1001,2);
R=zeros(1,100,1001);
for n=1:1
    for i=1:100
        for k=1:1000
            if rand(1)<epsilon
                if rand(1)<0.5
                    action=1;
                else
                    action=2;
                end
            else
                if Q(n,i,k,1)>Q(n,i,k,2)
                    action=1;
                elseif Q(n,i,k,1)<Q(n,i,k,2)
                    action=2;
                else
                    if rand(1)<0.5
                        action=1;
                    else
                        action=2;
                    end
                end
            end
            if action==1
                reward = sqrt(10).*randn(1) + 5;
                Q(n,i,k+1,1) = Q(n,i,k,1) + alpha * (reward - Q(n,i,k,1));
                Q(n,i,k+1,2) = Q(n,i,k,2);
            else
                if rand(1)>0.5
                    reward = sqrt(15).*randn(1) + 10;
                else
                    reward = sqrt(10).*randn(1) + 4;
                end
                Q(n,i,k+1,1) = Q(n,i,k,1);
                Q(n,i,k+1,2) = Q(n,i,k,2) + alpha * (reward - Q(n,i,k,2));
            end
            R(n,i,k+1)=reward;
        end
    end
end
R_acc=R;
for k=1:1001
    R_acc(:,:,k)=sum(R(:,:,1:k),3)./k;
end
R_acc=sum(R_acc,2)./100;

Q=sum(Q,2)./100;

save('project_1_c_R.mat','R');
save('project_1_c_Q.mat','Q');

figure(1),plot(1:1001,squeeze(R_acc(1,1,:)),'-r')
hold on
figure(1),axis([-20,1001,-0.2,8])
% figure(1),axis([-20,1001,-0.2,7])
grid on
legend({'Gradient-Bandit policy','𝜖-greedy'},'Location','southeast')
title('Gradient-Bandit policy (alpha=0.1) and 𝜖-greedy policy (alpha=0.1,epsilon=0.1)')
xlabel('Time(t)')
ylabel('Average Accumulated Reward')
