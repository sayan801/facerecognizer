
function model = perform_kfa_PhD(X, ids, kernel_type, kernel_args,n);

%% Init 
model = [];

%% Check inputs

%check number of inputs
if nargin <2
    disp('Wrong number of input parameters! The function requires at least two input arguments.')
    return;
elseif nargin >5
    disp('Wrong number of input parameters! The function takes no more than five input arguments.')
    return;
elseif nargin==2
    [a,b]=size(unique(ids));
    n = max([a,b])-1;
    kernel_type = 'poly' 
    kernel_args = [0 2];   
elseif nargin==3
    [a,b]=size(unique(ids));
    n = max([a,b])-1;
    if strcmp(kernel_type,'poly')==1
        kernel_args = [0 2];
    elseif strcmp(kernel_type,'fpp')==1
        kernel_args = [0 .8];
    elseif strcmp(kernel_type,'tanh')==1
        kernel_args = 0;
    else
        disp('The entered kernel type was not recognized as a supported kernel type.')
        return;
    end
elseif nargin==4
    [a,b]=size(unique(ids));
    n = max([a,b])-1;
end

%check if ids is a vector
if isvector(ids)==0
    disp('The second parameter "ids" needs to be a vector.')
    return;
end

% check if n is not to big
[a,b]=size(unique(ids));
if n>max([a,b])-1;
    disp('The parameter "n" must not be larger than the number of classes minus one. Decreasing "n"!')
    n = max([a,b])-1;
end

%check that each image in X has a class label
[a,b]=size(X);
if b~=length(ids)
    disp('The label vector "ids" needs to be the same size as the number of samples in X.')
    return;
end

%we assume that the data is contained in the columns - print to prompt
disp(sprintf('The training data comprises %i samples (images) with %i variables (pixels).', b, a))
disp('If this should be the other way around, please transpose the training-data matrix.')


%% Compute the KFA subspace - main part

%compute the training data kernel matrix
K = compute_kernel_matrix_PhD(X,X,kernel_type,kernel_args);
model.K = K;

%center kernel
J = ones(b,b)/b;
Kc = K - J*K - K*J + J*K*J;
model.J = J;

%compute W using auxilary function
W=zeros(b,b);
W=return_W(W,ids);

%construct eigenproblem using Tickhonov regularization
epsi = 1e-10*min(min(Kc*Kc)); %some small regularization constant
Crit = (Kc*Kc+epsi*eye(b,b))\(Kc*W*Kc);
clear W

%solve eigenproblem
[U,V,L]=svd(Crit);
clear L Crit
Alpha = normc(U(:,1:n));
clear U

%normalize Alpha to be unit length in F
R=Alpha'*Kc*Alpha;
norms = real(diag(R));
for i=1:n
   Alpha(:,i)=Alpha(:,i)/sqrt(norms(i)); 
end


%construct some outputs
model.W = Alpha;
model.dim = n;
model.eigs = diag(V);
model.typ = kernel_type;
model.args = kernel_args;
model.X = X;

%% Construct training features
model.train = Alpha'*Kc;






%% This is the auxilary function used to produce W 
% for within-class scatter comutation
function W=return_W(W,ids)

id_unique = unique(ids);
[c,d]=size(id_unique);
num_of_class = max([c,d]); %this is the number of classes

for i=1:num_of_class
   [dummy,ind]=find(id_unique(i)==ids);
   [x,y] = meshgrid(ind,ind);
   elem_val = 1/sum(length(ind));
   W(x,y)=elem_val; 
end

    























