function alphamax_A = FUN_FWaway_alphamax_nuke2( uA, vA, alphaG , delta, uk, dk, vk , option_search )

%% find alphamax_A which is smaller than alphaG i.e. the line-search optimum AND
%% sum(svd((1+ alphavec(kk))*uk*diag(dk)*vk' - alphavec(kk)*uAvA')) <= delta



%% use bisection if (1<0) , o/w do line search


if ( sum(dk) > delta)
alphamax_A = 0; return;
end



if (option_search == (1<0))
alpha_locL = 0;

alpha_locR = alphaG;

alpha_loc = alphaG;

% test alpha_loc = alphaG

d_G = (1+alpha_loc)*dk;
u_add = -alpha_loc*uA;

[uk_G, dk_G, vk_G]=svd_rank_one_update1(uk, diag(d_G), vk, u_add, vA);


if( sum(sum(dk_G)) <=delta )
alphamax_A = alpha_loc; 
return;
end

alpha_loc = (alpha_locR + alpha_locL)/2;

d_mid = (1+alpha_loc)*dk;
u_mid = -alpha_loc*uA;
[uk_mid, dk_mid, vk_mid]=svd_rank_one_update1(uk, diag(d_mid), vk, u_mid, vA);


d_L = (1+alpha_locL)*dk;
u_L = -alpha_locL*uA;
[uk_L, dk_L, vk_L]=svd_rank_one_update1(uk, diag(d_L), vk, u_L, vA);

d_R = (1+alpha_locR)*dk;
u_R = -alpha_locR*uA;
[uk_R, dk_R, vk_R]=svd_rank_one_update1(uk, diag(d_R), vk, u_R, vA);

objval_mid = sum(sum(dk_mid));
objval_L = sum(sum(dk_L));
objval_R = sum(sum(dk_R));

err = objval_mid - delta;

loop_size = 0; 

%while ( (err < -1e-7) || (err > 1e-10 ) )
while ( abs(err) > 1e-7 )


loop_size = loop_size + 1;

if (loop_size > 100)
    disp('binary search > 100 iterations');
    alpha_loc = alpha_locL;
break;
end


if ( (objval_mid - delta)*(objval_L - delta) < 0 )

alpha_locR = alpha_loc;

objval_R = objval_mid;

else

alpha_locL = alpha_loc;

objval_L = objval_mid;

end

alpha_loc = (alpha_locR + alpha_locL)/2;

d_mid = (1+alpha_loc)*dk;
u_mid = -alpha_loc*uA;
[uk_mid, dk_mid, vk_mid]=svd_rank_one_update1(uk, diag(d_mid), vk, u_mid, vA);

objval_mid = sum(sum(dk_mid));

err = objval_mid - delta;

end



alphamax_A = alpha_loc;





else

disp('NOT IMPLEMENTED');
pause;
    
alphavec= linspace(0,alphaG,1000);

nucnormvals=alphavec;

for kk = 1: length(alphavec); 
nucnormvals(kk)=sum(svd((1+ alphavec(kk))*Dcur - alphavec(kk)*MM));
end

alphamax_A = max(alphavec((nucnormvals <= delta)))
if (isempty(alphamax_A))
alphamax_A=0;
end




end
