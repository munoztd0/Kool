function  output = MBMF_low_effort_arm_sim(x,rews)

% parameters
b = x(1);           % softmax inverse temperature
lr = x(2);          % learning rate
lambda = x(3);      % eligibility trace decay
w = x(4);           % mixing weight

% initialization
Qmf = zeros(2,3);
Q2 = zeros(3,1);                      % Q(s,a): state-action value function for Q-learning
Tm = cell(2,1);
Tm{1} = [1 0 0; 0 1 0; 0 0 1];        % transition matrix
Tm{2} = [1 0 0; 0 1 0; 0 0 1];        % transition matrix
N = size(rews,1);
output.A = zeros(N,2);
output.R = zeros(N,1);
output.S = zeros(N,2);

% loop through trials
for t = 1:N
    
    s1 = ceil(rand*2);
    
    Qmb = Tm{s1}*Q2;                              % compute model-based value function
    
    Q = w*Qmb + (1-w)*Qmf(s1,:)';                 % mix TD and model value
    
    ps = exp(b*Q)/sum(exp(b*Q));                  % compute choice probabilities for each action
    a = find(rand<cumsum(ps),1);                  % choose
    
    s2 = a;
    
    dtQ(2) = Q2(s3) - Qmf(s3,a);                  % backup with actual choice (i.e., sarsa)
    Qmf(s3,a) = Qmf(s3,a) + lr*dtQ(3);            % update TD value function
    
    dtQ(3) = rews(t,s3) - Q2(s3);                 % prediction error (2nd choice)
    
    Q2(s3) = Q2(s3) + lr*dtQ(3);                  % update TD value function
    Qmf(s2,a) = Qmf(s2,a) + lambda*lr*dtQ(3);     % eligibility trace
    
    % store stuff
    output.A(t,1) = a;
    output.R(t,1) = rews(t,s2);
    output.S(t,:) = [s1 s2];
    
end

end
