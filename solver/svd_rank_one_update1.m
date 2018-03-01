function [Unew, Dnew, Vnew]= svd_rank_one_update1(Uold,Dold,Vold, u_add, v_add)

%% obtain svd of   Uold*Dold*Vold' + u_add*v_add' = Unew*Dnew*Vnew';

%curr_rnk=size(Uold,2);

 
  m = Uold'*u_add;
  p = u_add - Uold*m;
  Ra = norm(p,2);
 
  if ( Ra < 1e-8 )
  
  [Up, Dnew, Vnew]=svd( Dold*Vold' + (Uold'*u_add)*v_add','econ');
 
  Unew = Uold*Up;

return;

  end;
  
  % needed to move this after if statement 
  P = (1/Ra)*p;
  
  n = Vold' * v_add;
  q = v_add - Vold*n;
  Rb = sqrt(q'*q);
  Q = (1/Rb)*q;

  if ( Rb < 1e-7 )

   [Unew, Dnew, Vp]=svd( Uold*Dold + u_add*(v_add'*Vold),'econ');
 
   Vnew = Vold*Vp;
   
return;

  end;
  
  
  z = zeros( size(m) );

  K = [ Dold z ; z' 0 ] + [ m; Ra ]*[ n; Rb ]';

  [tUp,tSp,tVp] = svd( K );


  Dnew = tSp;

  Unew = [ Uold P ] * tUp;
  Vnew = [ Vold Q ] * tVp;


