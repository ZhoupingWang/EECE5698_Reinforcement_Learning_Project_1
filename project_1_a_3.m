
% alpha=1/(1+log(k+1))
epsilon=[0,0.1,0.2,0.5];
Q=zeros(4,100,1001,2);
R=zeros(4,100,1001);
for n=1:4
    for i=1:100
        for k=1:1000
            alpha = 1/(1+log(k+1));
            if rand(1)<epsilon(n)
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

save('project_1_a_3_R.mat','R');
save('project_1_a_3_Q.mat','Q');

figure(1),plot(1:1001,squeeze(R_acc(1,1,:)),'-b')
hold on
figure(1),plot(1:1001,squeeze(R_acc(2,1,:)),'-m')
hold on
figure(1),plot(1:1001,squeeze(R_acc(3,1,:)),'-g')
hold on
figure(1),plot(1:1001,squeeze(R_acc(4,1,:)),'-r')
hold on
figure(1),axis([-20,1001,5.5,6.7])
% figure(1),axis([-20,1001,-0.2,7])
grid on

legend({'epsilon=0','epsilon=0.1','epsilon=0.2','epsilon=0.5'},'Location','southeast')

title('alpha=1/(1+log(k+1))')
xlabel('Time(t)')
ylabel('Average Accumulated Reward')
