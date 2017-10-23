function obj = Initialize(obj,varargin)
%INITIALIZE エンコーダの初期化

switch obj.method
  case 'SingleLS'
    obj.P = SingleLS(varargin{:});
  case 'MultipleLS'
    obj.P = MultipleLS(varargin{:});
  case 'LogOdds'
    obj.P = LogOdds(varargin{:});
end

end


function P = SingleLS(sigmoidType, thrshold, lb, ub)
P.thr = thrshold(:);
P.lb   = lb;
P.ub   = ub;
switch sigmoidType
  case 'erf'        % Error function
    P.sigm = @(x)erf((sqrt(pi)/2)*x);
  case 'tanh'       % hyperbolic tangent function (logistic function)
    P.sigm = @(x)tanh(x);
  case 'gd'         % Gudermannian function
    P.sigm = @(x)(2/pi)*atan(sinh((pi/2)*x));
  case 'with_sqrt'  % with sqrt function
    P.sigm = @(x)x./sqrt(1+x.^2);
  case 'atan'       % arctangent function
    P.sigm = @(x)(2/pi)*atan((pi/2)*x);
  case 'with_abs'   % with abs function
    P.sigm = @(x)x./(1+abs(x));
  case 'linear'     % with piecewise linear function
    P.sigm = @(x)min(max(x,-1),1);
  otherwise
    error 'undefined function'
end
if P.lb ~= -Inf
  P.lowerSigmoid = @(x) (P.thr(1)-P.lb)*...
    P.sigm((x-P.thr(1))/(P.thr(1)-P.lb))+P.thr(1);
else
  P.lowerSigmoid = @(x) (P.thr(1)-P.lb)*...
    (x-P.thr(1))/(P.thr(1)-P.lb)+P.thr(1);
end
if P.ub ~= Inf
  P.upperSigmoid = @(x) (P.ub-P.thr(end))*...
    P.sigm((x-P.thr(end))/(P.ub-P.thr(end)))+P.thr(end);
else
  P.upperSigmoid = @(x) (P.ub-P.thr(end))*...
    (x-P.thr(end))/(P.ub-P.thr(end))+P.thr(end);
end
end


function P = MultipleLS(sigmoidType, slope, lb, ub)
% thrshold
P.slope = slope;
P.lb   = lb;
P.ub   = ub;
switch sigmoidType
  case 'erf'        % Error function
    P.sigm = @(x)erf((sqrt(pi)/2)*x);
  case 'tanh'       % hyperbolic tangent function (logistic function)
    P.sigm = @(x)tanh(x);
  case 'gd'         % Gudermannian function
    P.sigm = @(x)(2/pi)*atan(sinh((pi/2)*x));
  case 'with_sqrt'  % with sqrt function
    P.sigm = @(x)x./sqrt(1+x.^2);
  case 'atan'       % arctangent function
    P.sigm = @(x)(2/pi)*atan((pi/2)*x);
  case 'with_abs'   % with abs function
    P.sigm = @(x)x./(1+abs(x));
  case 'linear'     % with piecewise linear function
    P.sigm = @(x)min(max(x,-1),1);
  otherwise
    error 'undefined function'
end
if P.lb ~= -Inf
  P.lowerSigmoid = @(x) (-P.lb)*...
    P.sigm(x/(-P.lb*P.slope));
else
  P.lowerSigmoid = @(x) x*P.slope;
end
if P.ub ~= Inf
  P.upperSigmoid = @(x) (P.ub)*...
    P.sigm(x/(P.ub*P.slope));
else
  P.upperSigmoid = @(x) x*P.slope;
end
end

function P = LogOdds(sigmoidType,a,lb,ub)
% thrshold
P.a = a;
P.lb   = lb;
P.ub   = ub;
switch sigmoidType
  case 'erf'        % Error function
    P.sigm = @(x)erf((sqrt(pi)/2)*x);
  case 'tanh'       % hyperbolic tangent function (logistic function)
    P.sigm = @(x)tanh(x);
  case 'gd'         % Gudermannian function
    P.sigm = @(x)(2/pi)*atan(sinh((pi/2)*x));
  case 'with_sqrt'  % with sqrt function
    P.sigm = @(x)x./sqrt(1+x.^2);
  case 'atan'       % arctangent function
    P.sigm = @(x)(2/pi)*atan((pi/2)*x);
  case 'with_abs'   % with abs function
    P.sigm = @(x)x./(1+abs(x));
  case 'linear'     % with piecewise linear function
    P.sigm = @(x)min(max(x,-1),1);
  otherwise
    error 'undefined function'
end
if P.lb ~= -Inf
  P.lowerSigmoid = @(x) (-P.lb)*...
    P.sigm(x/(-P.lb*P.a));
else
  P.lowerSigmoid = @(x) x*P.a;
end
if P.ub ~= Inf
  P.upperSigmoid = @(x) (P.ub)*...
    P.sigm(x/(P.ub*P.a));
else
  P.upperSigmoid = @(x) x*P.a;
end
end
