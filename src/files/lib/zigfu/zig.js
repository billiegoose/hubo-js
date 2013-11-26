// script: zig.js
// ZDK for Javascript

if ('undefined' == typeof zig) {

// Minified version of sylvester, used internally
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('9 17={3i:\'0.1.3\',16:1e-6};l v(){}v.23={e:l(i){8(i<1||i>7.4.q)?w:7.4[i-1]},2R:l(){8 7.4.q},1u:l(){8 F.1x(7.2u(7))},24:l(a){9 n=7.4.q;9 V=a.4||a;o(n!=V.q){8 1L}J{o(F.13(7.4[n-1]-V[n-1])>17.16){8 1L}}H(--n);8 2x},1q:l(){8 v.u(7.4)},1b:l(a){9 b=[];7.28(l(x,i){b.19(a(x,i))});8 v.u(b)},28:l(a){9 n=7.4.q,k=n,i;J{i=k-n;a(7.4[i],i+1)}H(--n)},2q:l(){9 r=7.1u();o(r===0){8 7.1q()}8 7.1b(l(x){8 x/r})},1C:l(a){9 V=a.4||a;9 n=7.4.q,k=n,i;o(n!=V.q){8 w}9 b=0,1D=0,1F=0;7.28(l(x,i){b+=x*V[i-1];1D+=x*x;1F+=V[i-1]*V[i-1]});1D=F.1x(1D);1F=F.1x(1F);o(1D*1F===0){8 w}9 c=b/(1D*1F);o(c<-1){c=-1}o(c>1){c=1}8 F.37(c)},1m:l(a){9 b=7.1C(a);8(b===w)?w:(b<=17.16)},34:l(a){9 b=7.1C(a);8(b===w)?w:(F.13(b-F.1A)<=17.16)},2k:l(a){9 b=7.2u(a);8(b===w)?w:(F.13(b)<=17.16)},2j:l(a){9 V=a.4||a;o(7.4.q!=V.q){8 w}8 7.1b(l(x,i){8 x+V[i-1]})},2C:l(a){9 V=a.4||a;o(7.4.q!=V.q){8 w}8 7.1b(l(x,i){8 x-V[i-1]})},22:l(k){8 7.1b(l(x){8 x*k})},x:l(k){8 7.22(k)},2u:l(a){9 V=a.4||a;9 i,2g=0,n=7.4.q;o(n!=V.q){8 w}J{2g+=7.4[n-1]*V[n-1]}H(--n);8 2g},2f:l(a){9 B=a.4||a;o(7.4.q!=3||B.q!=3){8 w}9 A=7.4;8 v.u([(A[1]*B[2])-(A[2]*B[1]),(A[2]*B[0])-(A[0]*B[2]),(A[0]*B[1])-(A[1]*B[0])])},2A:l(){9 m=0,n=7.4.q,k=n,i;J{i=k-n;o(F.13(7.4[i])>F.13(m)){m=7.4[i]}}H(--n);8 m},2Z:l(x){9 a=w,n=7.4.q,k=n,i;J{i=k-n;o(a===w&&7.4[i]==x){a=i+1}}H(--n);8 a},3g:l(){8 S.2X(7.4)},2d:l(){8 7.1b(l(x){8 F.2d(x)})},2V:l(x){8 7.1b(l(y){8(F.13(y-x)<=17.16)?x:y})},1o:l(a){o(a.K){8 a.1o(7)}9 V=a.4||a;o(V.q!=7.4.q){8 w}9 b=0,2b;7.28(l(x,i){2b=x-V[i-1];b+=2b*2b});8 F.1x(b)},3a:l(a){8 a.1h(7)},2T:l(a){8 a.1h(7)},1V:l(t,a){9 V,R,x,y,z;2S(7.4.q){27 2:V=a.4||a;o(V.q!=2){8 w}R=S.1R(t).4;x=7.4[0]-V[0];y=7.4[1]-V[1];8 v.u([V[0]+R[0][0]*x+R[0][1]*y,V[1]+R[1][0]*x+R[1][1]*y]);1I;27 3:o(!a.U){8 w}9 C=a.1r(7).4;R=S.1R(t,a.U).4;x=7.4[0]-C[0];y=7.4[1]-C[1];z=7.4[2]-C[2];8 v.u([C[0]+R[0][0]*x+R[0][1]*y+R[0][2]*z,C[1]+R[1][0]*x+R[1][1]*y+R[1][2]*z,C[2]+R[2][0]*x+R[2][1]*y+R[2][2]*z]);1I;2P:8 w}},1t:l(a){o(a.K){9 P=7.4.2O();9 C=a.1r(P).4;8 v.u([C[0]+(C[0]-P[0]),C[1]+(C[1]-P[1]),C[2]+(C[2]-(P[2]||0))])}1d{9 Q=a.4||a;o(7.4.q!=Q.q){8 w}8 7.1b(l(x,i){8 Q[i-1]+(Q[i-1]-x)})}},1N:l(){9 V=7.1q();2S(V.4.q){27 3:1I;27 2:V.4.19(0);1I;2P:8 w}8 V},2n:l(){8\'[\'+7.4.2K(\', \')+\']\'},26:l(a){7.4=(a.4||a).2O();8 7}};v.u=l(a){9 V=25 v();8 V.26(a)};v.i=v.u([1,0,0]);v.j=v.u([0,1,0]);v.k=v.u([0,0,1]);v.2J=l(n){9 a=[];J{a.19(F.2F())}H(--n);8 v.u(a)};v.1j=l(n){9 a=[];J{a.19(0)}H(--n);8 v.u(a)};l S(){}S.23={e:l(i,j){o(i<1||i>7.4.q||j<1||j>7.4[0].q){8 w}8 7.4[i-1][j-1]},33:l(i){o(i>7.4.q){8 w}8 v.u(7.4[i-1])},2E:l(j){o(j>7.4[0].q){8 w}9 a=[],n=7.4.q,k=n,i;J{i=k-n;a.19(7.4[i][j-1])}H(--n);8 v.u(a)},2R:l(){8{2D:7.4.q,1p:7.4[0].q}},2D:l(){8 7.4.q},1p:l(){8 7.4[0].q},24:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}o(7.4.q!=M.q||7.4[0].q!=M[0].q){8 1L}9 b=7.4.q,15=b,i,G,10=7.4[0].q,j;J{i=15-b;G=10;J{j=10-G;o(F.13(7.4[i][j]-M[i][j])>17.16){8 1L}}H(--G)}H(--b);8 2x},1q:l(){8 S.u(7.4)},1b:l(a){9 b=[],12=7.4.q,15=12,i,G,10=7.4[0].q,j;J{i=15-12;G=10;b[i]=[];J{j=10-G;b[i][j]=a(7.4[i][j],i+1,j+1)}H(--G)}H(--12);8 S.u(b)},2i:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}8(7.4.q==M.q&&7.4[0].q==M[0].q)},2j:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}o(!7.2i(M)){8 w}8 7.1b(l(x,i,j){8 x+M[i-1][j-1]})},2C:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}o(!7.2i(M)){8 w}8 7.1b(l(x,i,j){8 x-M[i-1][j-1]})},2B:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}8(7.4[0].q==M.q)},22:l(a){o(!a.4){8 7.1b(l(x){8 x*a})}9 b=a.1u?2x:1L;9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}o(!7.2B(M)){8 w}9 d=7.4.q,15=d,i,G,10=M[0].q,j;9 e=7.4[0].q,4=[],21,20,c;J{i=15-d;4[i]=[];G=10;J{j=10-G;21=0;20=e;J{c=e-20;21+=7.4[i][c]*M[c][j]}H(--20);4[i][j]=21}H(--G)}H(--d);9 M=S.u(4);8 b?M.2E(1):M},x:l(a){8 7.22(a)},32:l(a,b,c,d){9 e=[],12=c,i,G,j;9 f=7.4.q,1p=7.4[0].q;J{i=c-12;e[i]=[];G=d;J{j=d-G;e[i][j]=7.4[(a+i-1)%f][(b+j-1)%1p]}H(--G)}H(--12);8 S.u(e)},31:l(){9 a=7.4.q,1p=7.4[0].q;9 b=[],12=1p,i,G,j;J{i=1p-12;b[i]=[];G=a;J{j=a-G;b[i][j]=7.4[j][i]}H(--G)}H(--12);8 S.u(b)},1y:l(){8(7.4.q==7.4[0].q)},2A:l(){9 m=0,12=7.4.q,15=12,i,G,10=7.4[0].q,j;J{i=15-12;G=10;J{j=10-G;o(F.13(7.4[i][j])>F.13(m)){m=7.4[i][j]}}H(--G)}H(--12);8 m},2Z:l(x){9 a=w,12=7.4.q,15=12,i,G,10=7.4[0].q,j;J{i=15-12;G=10;J{j=10-G;o(7.4[i][j]==x){8{i:i+1,j:j+1}}}H(--G)}H(--12);8 w},30:l(){o(!7.1y){8 w}9 a=[],n=7.4.q,k=n,i;J{i=k-n;a.19(7.4[i][i])}H(--n);8 v.u(a)},1K:l(){9 M=7.1q(),1c;9 n=7.4.q,k=n,i,1s,1n=7.4[0].q,p;J{i=k-n;o(M.4[i][i]==0){2e(j=i+1;j<k;j++){o(M.4[j][i]!=0){1c=[];1s=1n;J{p=1n-1s;1c.19(M.4[i][p]+M.4[j][p])}H(--1s);M.4[i]=1c;1I}}}o(M.4[i][i]!=0){2e(j=i+1;j<k;j++){9 a=M.4[j][i]/M.4[i][i];1c=[];1s=1n;J{p=1n-1s;1c.19(p<=i?0:M.4[j][p]-M.4[i][p]*a)}H(--1s);M.4[j]=1c}}}H(--n);8 M},3h:l(){8 7.1K()},2z:l(){o(!7.1y()){8 w}9 M=7.1K();9 a=M.4[0][0],n=M.4.q-1,k=n,i;J{i=k-n+1;a=a*M.4[i][i]}H(--n);8 a},3f:l(){8 7.2z()},2y:l(){8(7.1y()&&7.2z()===0)},2Y:l(){o(!7.1y()){8 w}9 a=7.4[0][0],n=7.4.q-1,k=n,i;J{i=k-n+1;a+=7.4[i][i]}H(--n);8 a},3e:l(){8 7.2Y()},1Y:l(){9 M=7.1K(),1Y=0;9 a=7.4.q,15=a,i,G,10=7.4[0].q,j;J{i=15-a;G=10;J{j=10-G;o(F.13(M.4[i][j])>17.16){1Y++;1I}}H(--G)}H(--a);8 1Y},3d:l(){8 7.1Y()},2W:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}9 T=7.1q(),1p=T.4[0].q;9 b=T.4.q,15=b,i,G,10=M[0].q,j;o(b!=M.q){8 w}J{i=15-b;G=10;J{j=10-G;T.4[i][1p+j]=M[i][j]}H(--G)}H(--b);8 T},2w:l(){o(!7.1y()||7.2y()){8 w}9 a=7.4.q,15=a,i,j;9 M=7.2W(S.I(a)).1K();9 b,1n=M.4[0].q,p,1c,2v;9 c=[],2c;J{i=a-1;1c=[];b=1n;c[i]=[];2v=M.4[i][i];J{p=1n-b;2c=M.4[i][p]/2v;1c.19(2c);o(p>=15){c[i].19(2c)}}H(--b);M.4[i]=1c;2e(j=0;j<i;j++){1c=[];b=1n;J{p=1n-b;1c.19(M.4[j][p]-M.4[i][p]*M.4[j][i])}H(--b);M.4[j]=1c}}H(--a);8 S.u(c)},3c:l(){8 7.2w()},2d:l(){8 7.1b(l(x){8 F.2d(x)})},2V:l(x){8 7.1b(l(p){8(F.13(p-x)<=17.16)?x:p})},2n:l(){9 a=[];9 n=7.4.q,k=n,i;J{i=k-n;a.19(v.u(7.4[i]).2n())}H(--n);8 a.2K(\'\\n\')},26:l(a){9 i,4=a.4||a;o(1g(4[0][0])!=\'1f\'){9 b=4.q,15=b,G,10,j;7.4=[];J{i=15-b;G=4[i].q;10=G;7.4[i]=[];J{j=10-G;7.4[i][j]=4[i][j]}H(--G)}H(--b);8 7}9 n=4.q,k=n;7.4=[];J{i=k-n;7.4.19([4[i]])}H(--n);8 7}};S.u=l(a){9 M=25 S();8 M.26(a)};S.I=l(n){9 a=[],k=n,i,G,j;J{i=k-n;a[i]=[];G=k;J{j=k-G;a[i][j]=(i==j)?1:0}H(--G)}H(--n);8 S.u(a)};S.2X=l(a){9 n=a.q,k=n,i;9 M=S.I(n);J{i=k-n;M.4[i][i]=a[i]}H(--n);8 M};S.1R=l(b,a){o(!a){8 S.u([[F.1H(b),-F.1G(b)],[F.1G(b),F.1H(b)]])}9 d=a.1q();o(d.4.q!=3){8 w}9 e=d.1u();9 x=d.4[0]/e,y=d.4[1]/e,z=d.4[2]/e;9 s=F.1G(b),c=F.1H(b),t=1-c;8 S.u([[t*x*x+c,t*x*y-s*z,t*x*z+s*y],[t*x*y+s*z,t*y*y+c,t*y*z-s*x],[t*x*z-s*y,t*y*z+s*x,t*z*z+c]])};S.3b=l(t){9 c=F.1H(t),s=F.1G(t);8 S.u([[1,0,0],[0,c,-s],[0,s,c]])};S.39=l(t){9 c=F.1H(t),s=F.1G(t);8 S.u([[c,0,s],[0,1,0],[-s,0,c]])};S.38=l(t){9 c=F.1H(t),s=F.1G(t);8 S.u([[c,-s,0],[s,c,0],[0,0,1]])};S.2J=l(n,m){8 S.1j(n,m).1b(l(){8 F.2F()})};S.1j=l(n,m){9 a=[],12=n,i,G,j;J{i=n-12;a[i]=[];G=m;J{j=m-G;a[i][j]=0}H(--G)}H(--12);8 S.u(a)};l 14(){}14.23={24:l(a){8(7.1m(a)&&7.1h(a.K))},1q:l(){8 14.u(7.K,7.U)},2U:l(a){9 V=a.4||a;8 14.u([7.K.4[0]+V[0],7.K.4[1]+V[1],7.K.4[2]+(V[2]||0)],7.U)},1m:l(a){o(a.W){8 a.1m(7)}9 b=7.U.1C(a.U);8(F.13(b)<=17.16||F.13(b-F.1A)<=17.16)},1o:l(a){o(a.W){8 a.1o(7)}o(a.U){o(7.1m(a)){8 7.1o(a.K)}9 N=7.U.2f(a.U).2q().4;9 A=7.K.4,B=a.K.4;8 F.13((A[0]-B[0])*N[0]+(A[1]-B[1])*N[1]+(A[2]-B[2])*N[2])}1d{9 P=a.4||a;9 A=7.K.4,D=7.U.4;9 b=P[0]-A[0],2a=P[1]-A[1],29=(P[2]||0)-A[2];9 c=F.1x(b*b+2a*2a+29*29);o(c===0)8 0;9 d=(b*D[0]+2a*D[1]+29*D[2])/c;9 e=1-d*d;8 F.13(c*F.1x(e<0?0:e))}},1h:l(a){9 b=7.1o(a);8(b!==w&&b<=17.16)},2T:l(a){8 a.1h(7)},1v:l(a){o(a.W){8 a.1v(7)}8(!7.1m(a)&&7.1o(a)<=17.16)},1U:l(a){o(a.W){8 a.1U(7)}o(!7.1v(a)){8 w}9 P=7.K.4,X=7.U.4,Q=a.K.4,Y=a.U.4;9 b=X[0],1z=X[1],1B=X[2],1T=Y[0],1S=Y[1],1M=Y[2];9 c=P[0]-Q[0],2s=P[1]-Q[1],2r=P[2]-Q[2];9 d=-b*c-1z*2s-1B*2r;9 e=1T*c+1S*2s+1M*2r;9 f=b*b+1z*1z+1B*1B;9 g=1T*1T+1S*1S+1M*1M;9 h=b*1T+1z*1S+1B*1M;9 k=(d*g/f+h*e)/(g-h*h);8 v.u([P[0]+k*b,P[1]+k*1z,P[2]+k*1B])},1r:l(a){o(a.U){o(7.1v(a)){8 7.1U(a)}o(7.1m(a)){8 w}9 D=7.U.4,E=a.U.4;9 b=D[0],1l=D[1],1k=D[2],1P=E[0],1O=E[1],1Q=E[2];9 x=(1k*1P-b*1Q),y=(b*1O-1l*1P),z=(1l*1Q-1k*1O);9 N=v.u([x*1Q-y*1O,y*1P-z*1Q,z*1O-x*1P]);9 P=11.u(a.K,N);8 P.1U(7)}1d{9 P=a.4||a;o(7.1h(P)){8 v.u(P)}9 A=7.K.4,D=7.U.4;9 b=D[0],1l=D[1],1k=D[2],1w=A[0],18=A[1],1a=A[2];9 x=b*(P[1]-18)-1l*(P[0]-1w),y=1l*((P[2]||0)-1a)-1k*(P[1]-18),z=1k*(P[0]-1w)-b*((P[2]||0)-1a);9 V=v.u([1l*x-1k*z,1k*y-b*x,b*z-1l*y]);9 k=7.1o(P)/V.1u();8 v.u([P[0]+V.4[0]*k,P[1]+V.4[1]*k,(P[2]||0)+V.4[2]*k])}},1V:l(t,a){o(1g(a.U)==\'1f\'){a=14.u(a.1N(),v.k)}9 R=S.1R(t,a.U).4;9 C=a.1r(7.K).4;9 A=7.K.4,D=7.U.4;9 b=C[0],1E=C[1],1J=C[2],1w=A[0],18=A[1],1a=A[2];9 x=1w-b,y=18-1E,z=1a-1J;8 14.u([b+R[0][0]*x+R[0][1]*y+R[0][2]*z,1E+R[1][0]*x+R[1][1]*y+R[1][2]*z,1J+R[2][0]*x+R[2][1]*y+R[2][2]*z],[R[0][0]*D[0]+R[0][1]*D[1]+R[0][2]*D[2],R[1][0]*D[0]+R[1][1]*D[1]+R[1][2]*D[2],R[2][0]*D[0]+R[2][1]*D[1]+R[2][2]*D[2]])},1t:l(a){o(a.W){9 A=7.K.4,D=7.U.4;9 b=A[0],18=A[1],1a=A[2],2N=D[0],1l=D[1],1k=D[2];9 c=7.K.1t(a).4;9 d=b+2N,2h=18+1l,2o=1a+1k;9 Q=a.1r([d,2h,2o]).4;9 e=[Q[0]+(Q[0]-d)-c[0],Q[1]+(Q[1]-2h)-c[1],Q[2]+(Q[2]-2o)-c[2]];8 14.u(c,e)}1d o(a.U){8 7.1V(F.1A,a)}1d{9 P=a.4||a;8 14.u(7.K.1t([P[0],P[1],(P[2]||0)]),7.U)}},1Z:l(a,b){a=v.u(a);b=v.u(b);o(a.4.q==2){a.4.19(0)}o(b.4.q==2){b.4.19(0)}o(a.4.q>3||b.4.q>3){8 w}9 c=b.1u();o(c===0){8 w}7.K=a;7.U=v.u([b.4[0]/c,b.4[1]/c,b.4[2]/c]);8 7}};14.u=l(a,b){9 L=25 14();8 L.1Z(a,b)};14.X=14.u(v.1j(3),v.i);14.Y=14.u(v.1j(3),v.j);14.Z=14.u(v.1j(3),v.k);l 11(){}11.23={24:l(a){8(7.1h(a.K)&&7.1m(a))},1q:l(){8 11.u(7.K,7.W)},2U:l(a){9 V=a.4||a;8 11.u([7.K.4[0]+V[0],7.K.4[1]+V[1],7.K.4[2]+(V[2]||0)],7.W)},1m:l(a){9 b;o(a.W){b=7.W.1C(a.W);8(F.13(b)<=17.16||F.13(F.1A-b)<=17.16)}1d o(a.U){8 7.W.2k(a.U)}8 w},2k:l(a){9 b=7.W.1C(a.W);8(F.13(F.1A/2-b)<=17.16)},1o:l(a){o(7.1v(a)||7.1h(a)){8 0}o(a.K){9 A=7.K.4,B=a.K.4,N=7.W.4;8 F.13((A[0]-B[0])*N[0]+(A[1]-B[1])*N[1]+(A[2]-B[2])*N[2])}1d{9 P=a.4||a;9 A=7.K.4,N=7.W.4;8 F.13((A[0]-P[0])*N[0]+(A[1]-P[1])*N[1]+(A[2]-(P[2]||0))*N[2])}},1h:l(a){o(a.W){8 w}o(a.U){8(7.1h(a.K)&&7.1h(a.K.2j(a.U)))}1d{9 P=a.4||a;9 A=7.K.4,N=7.W.4;9 b=F.13(N[0]*(A[0]-P[0])+N[1]*(A[1]-P[1])+N[2]*(A[2]-(P[2]||0)));8(b<=17.16)}},1v:l(a){o(1g(a.U)==\'1f\'&&1g(a.W)==\'1f\'){8 w}8!7.1m(a)},1U:l(a){o(!7.1v(a)){8 w}o(a.U){9 A=a.K.4,D=a.U.4,P=7.K.4,N=7.W.4;9 b=(N[0]*(P[0]-A[0])+N[1]*(P[1]-A[1])+N[2]*(P[2]-A[2]))/(N[0]*D[0]+N[1]*D[1]+N[2]*D[2]);8 v.u([A[0]+D[0]*b,A[1]+D[1]*b,A[2]+D[2]*b])}1d o(a.W){9 c=7.W.2f(a.W).2q();9 N=7.W.4,A=7.K.4,O=a.W.4,B=a.K.4;9 d=S.1j(2,2),i=0;H(d.2y()){i++;d=S.u([[N[i%3],N[(i+1)%3]],[O[i%3],O[(i+1)%3]]])}9 e=d.2w().4;9 x=N[0]*A[0]+N[1]*A[1]+N[2]*A[2];9 y=O[0]*B[0]+O[1]*B[1]+O[2]*B[2];9 f=[e[0][0]*x+e[0][1]*y,e[1][0]*x+e[1][1]*y];9 g=[];2e(9 j=1;j<=3;j++){g.19((i==j)?0:f[(j+(5-i)%3)%3])}8 14.u(g,c)}},1r:l(a){9 P=a.4||a;9 A=7.K.4,N=7.W.4;9 b=(A[0]-P[0])*N[0]+(A[1]-P[1])*N[1]+(A[2]-(P[2]||0))*N[2];8 v.u([P[0]+N[0]*b,P[1]+N[1]*b,(P[2]||0)+N[2]*b])},1V:l(t,a){9 R=S.1R(t,a.U).4;9 C=a.1r(7.K).4;9 A=7.K.4,N=7.W.4;9 b=C[0],1E=C[1],1J=C[2],1w=A[0],18=A[1],1a=A[2];9 x=1w-b,y=18-1E,z=1a-1J;8 11.u([b+R[0][0]*x+R[0][1]*y+R[0][2]*z,1E+R[1][0]*x+R[1][1]*y+R[1][2]*z,1J+R[2][0]*x+R[2][1]*y+R[2][2]*z],[R[0][0]*N[0]+R[0][1]*N[1]+R[0][2]*N[2],R[1][0]*N[0]+R[1][1]*N[1]+R[1][2]*N[2],R[2][0]*N[0]+R[2][1]*N[1]+R[2][2]*N[2]])},1t:l(a){o(a.W){9 A=7.K.4,N=7.W.4;9 b=A[0],18=A[1],1a=A[2],2M=N[0],2L=N[1],2Q=N[2];9 c=7.K.1t(a).4;9 d=b+2M,2p=18+2L,2m=1a+2Q;9 Q=a.1r([d,2p,2m]).4;9 e=[Q[0]+(Q[0]-d)-c[0],Q[1]+(Q[1]-2p)-c[1],Q[2]+(Q[2]-2m)-c[2]];8 11.u(c,e)}1d o(a.U){8 7.1V(F.1A,a)}1d{9 P=a.4||a;8 11.u(7.K.1t([P[0],P[1],(P[2]||0)]),7.W)}},1Z:l(a,b,c){a=v.u(a);a=a.1N();o(a===w){8 w}b=v.u(b);b=b.1N();o(b===w){8 w}o(1g(c)==\'1f\'){c=w}1d{c=v.u(c);c=c.1N();o(c===w){8 w}}9 d=a.4[0],18=a.4[1],1a=a.4[2];9 e=b.4[0],1W=b.4[1],1X=b.4[2];9 f,1i;o(c!==w){9 g=c.4[0],2l=c.4[1],2t=c.4[2];f=v.u([(1W-18)*(2t-1a)-(1X-1a)*(2l-18),(1X-1a)*(g-d)-(e-d)*(2t-1a),(e-d)*(2l-18)-(1W-18)*(g-d)]);1i=f.1u();o(1i===0){8 w}f=v.u([f.4[0]/1i,f.4[1]/1i,f.4[2]/1i])}1d{1i=F.1x(e*e+1W*1W+1X*1X);o(1i===0){8 w}f=v.u([b.4[0]/1i,b.4[1]/1i,b.4[2]/1i])}7.K=a;7.W=f;8 7}};11.u=l(a,b,c){9 P=25 11();8 P.1Z(a,b,c)};11.2I=11.u(v.1j(3),v.k);11.2H=11.u(v.1j(3),v.i);11.2G=11.u(v.1j(3),v.j);11.36=11.2I;11.35=11.2H;11.3j=11.2G;9 $V=v.u;9 $M=S.u;9 $L=14.u;9 $P=11.u;',62,206,'||||elements|||this|return|var||||||||||||function|||if||length||||create|Vector|null|||||||||Math|nj|while||do|anchor||||||||Matrix||direction||normal||||kj|Plane|ni|abs|Line|ki|precision|Sylvester|A2|push|A3|map|els|else||undefined|typeof|contains|mod|Zero|D3|D2|isParallelTo|kp|distanceFrom|cols|dup|pointClosestTo|np|reflectionIn|modulus|intersects|A1|sqrt|isSquare|X2|PI|X3|angleFrom|mod1|C2|mod2|sin|cos|break|C3|toRightTriangular|false|Y3|to3D|E2|E1|E3|Rotation|Y2|Y1|intersectionWith|rotate|v12|v13|rank|setVectors|nc|sum|multiply|prototype|eql|new|setElements|case|each|PA3|PA2|part|new_element|round|for|cross|product|AD2|isSameSizeAs|add|isPerpendicularTo|v22|AN3|inspect|AD3|AN2|toUnitVector|PsubQ3|PsubQ2|v23|dot|divisor|inverse|true|isSingular|determinant|max|canMultiplyFromLeft|subtract|rows|col|random|ZX|YZ|XY|Random|join|N2|N1|D1|slice|default|N3|dimensions|switch|liesIn|translate|snapTo|augment|Diagonal|trace|indexOf|diagonal|transpose|minor|row|isAntiparallelTo|ZY|YX|acos|RotationZ|RotationY|liesOn|RotationX|inv|rk|tr|det|toDiagonalMatrix|toUpperTriangular|version|XZ'.split('|'),0,{}));

// zig.js main closure
(function(){ 

//-----------------------------------------------------------------------------
// Helper objects
//-----------------------------------------------------------------------------

function Events() {
	var events = {};
	var listeners = [];	

	function addEventListener(eventName, callback) {
		eventName = "on" + eventName;
		if (!events.hasOwnProperty(eventName)) {
			events[eventName] = [];
		}
		events[eventName].push(callback);
		return callback;
	}

	function removeEventListener(eventName, callback) {
		eventName = "on" + eventName;
		if (!events.hasOwnProperty(eventName)) return;
		var i = events[eventName].indexOf(callback);
		if (1 >= 0) events[eventName].splice(i,1);
	}

	function addListener(listener) {
		listeners.push(listener);
		return listener;
	}

	function removeListener(listener) {
		if (undefined === listener) {
			listeners = [];
			return;
		}
		var i = listeners.indexOf(listener);
		if (i>=0) listeners.splice(i,1);
	}

	function _sendEvent(target, eventName, arg) {
		if (target.hasOwnProperty(eventName)) {
			try {
				target[eventName].call(target, arg);
			} catch (e) { 
				console.error("Error calling callback for " + eventName + ":\n" + e.stack); 
			}
		}
	}

	function fireEvent(eventName, arg, specificListener) {
		eventName = "on" + eventName;

		// first listeners
		listeners.forEach(function(listener) {
			if (undefined !== specificListener && specificListener != listener) return;
			_sendEvent(listener, eventName, arg);
		});

		// and then events
		if (events.hasOwnProperty(eventName)) {
			events[eventName].forEach(function(cb) {
				if (undefined !== specificListener && cb != specificListener) return;
				try {
					cb.call(null, arg);
				} catch (e) { 
					console.error("Error calling callback for " + eventName + ":\n" + e.stack); 
				}
			});
		}
	}

	function eventify(obj) {
		obj.addEventListener = addEventListener;
		obj.removeEventListener = removeEventListener;
		obj.addListener = function(listener) {
			addListener(listener);
			_sendEvent(listener, 'onattach', obj);
			_sendEvent(obj, 'onlistenerattach', listener);
			return listener;
		}
		obj.removeListener = function(listener) {
			fireEvent('detach', obj, listener);
			if (undefined === listener) {
				listeners.forEach(function (l) {
					_sendEvent(obj, 'onlistenerdetach', l);
				});
			} else {
				_sendEvent(obj, 'onlistenerdetach', listener);
			}
			removeListener(listener);
		}

		return obj;
	}

	return {
		addEventListener : addEventListener,
		removeEventListener : removeEventListener,
		addListener : addListener,
		removeListener : removeListener,
		fireEvent : fireEvent,
		eventify : eventify,
	}
}

function BoundingBox(size, center) {

	if (undefined === center) {
		center = [0,0,0];
	}
	if (undefined === size) {
		size = [0,0,0];
	}

	var center = $V(center);
	var size = $V(size);
	var extents = size.multiply(0.5);
	var min = center.subtract(extents);
	var max = center.add(extents);

	function contains(point) {
		point = $V(point);
		return (point.e(1) >= min.e(1) && point.e(1) <= max.e(1) && 
				point.e(2) >= min.e(2) && point.e(2) <= max.e(2) &&
				point.e(3) >= min.e(3) && point.e(3) <= max.e(3));
	}

	function recenter(newCenter) {
		center = $V(newCenter);
		min = center.subtract(extents);
		max = center.add(extents);
	}

	function resize(newSize) {
		size = $V(newSize);
		extents = size.multiply(0.5);
		min = center.subtract(extents);
		max = center.add(extents);
	}

	function inspect() {
		console.log({center: center, size: size, min : min, max : max});
	}

	return {
		contains : contains,
		resize : resize,
		recenter : recenter,
		inspect : inspect,
		getsize : function() { return size; },
		getcenter : function() { return center; },
		getmin : function() { return min; },
		getmax : function() { return max; },
	}
}

function FpsCounter() {
	var lastFrame;

	var pub = {
		markframe : markframe,
		lastDelta : 0,
		fps : 0,
	}

	function markframe(timestamp) {
		timestamp = timestamp || (new Date()).getTime();
		lastFrame = lastFrame || timestamp;
		pub.lastDelta = ((timestamp - lastFrame) / 1000);
		pub.fps = 1 / pub.lastDelta;
		lastFrame = timestamp;
	}

	return pub;
}

function clamp(x, min, max) {
	if (x < min) return min;
	if (x > max) return max;
	return x;
}

function vclamp(v, vmin, vmax) {
	return [clamp(v[0], vmin[0], vmax[0]), clamp(v[1], vmin[1], vmax[1]), clamp(v[2], vmin[2], vmax[2])];
}

function lerp(from, to, amount) {
	return from + ((to - from) * amount);
}

function vlerp(p1,p2,r) {
	out = [];
	for (i=0;i<p1.length;i++) {	
		out.push(p2[i]*r+p1[i]*(1-r));
	}
	return out;
}

function vscale(v1, v2) {
	return [v1[0]*v2[0], v1[1]*v2[1], v1[2]*v2[2]];
}

// enum: zig.Joint
// List of Joint ID's
var Joint = {
 	Invalid 		: 0,
 	Head 			: 1,
 	Neck 			: 2,
 	Torso 			: 3,
 	Waist 			: 4,
 	LeftCollar		: 5,
 	LeftShoulder 	: 6,
 	LeftElbow 		: 7,
 	LeftWrist 		: 8,
 	LeftHand 		: 9,
 	LeftFingertip 	: 10,
 	RightCollar 	: 11,
 	RightShoulder 	: 12,
 	RightElbow 		: 13,
 	RightWrist 		: 14,
 	RightHand 		: 15,
 	RightFingertip 	: 16,
 	LeftHip 		: 17,
 	LeftKnee 		: 18,
 	LeftAnkle 		: 19,
 	LeftFoot 		: 20,
 	RightHip 		: 21,
 	RightKnee 		: 22,
 	RightAnkle 		: 23,
 	RightFoot 		: 24,
 	ExternalHandpoint : 100,
};

// enum: zig.Orientation
// Possible orientations for oriented controls (<Fader>, for instance)
var Orientation = {
	X : 0,
	Y : 1,
	Z : 2,
}

//-----------------------------------------------------------------------------
// class: SteadyDetector
// Detects steady
//
// event: steady
// Triggered when hand is steady. Triggered only once per steady
//
// event: unsteady
// Triggered when hand is unsteady. Triggered only once per unsteady.
//-----------------------------------------------------------------------------
function SteadyDetector(maxVariance) {
	if (undefined === maxVariance) {
		maxVariance = 50;
	}

	var frameCount = 15;
	var pointBuffer = [];
	var maxVariance = maxVariance;
	var events = Events();
	
	function sumMatrix(mat) {
		var sum = 0;
		elements = mat.elements
		for(var i=0; i<elements.length; i++) {
			for(var j=0; j<elements[i].length; j++) {
				sum += elements[i][j];
			}
		}
		return sum;
	}
	
	// Reference : Oliver K. Smith: Eigenvalues of a symmetric 3 × 3 matrix. Commun. ACM 4(4): 168 (1961) 
	// find the eigenvalues of a 3x3 symmetric matrix
	function getEigenvalues(mat) {
		var m = mat.trace() / 3;
		var K = mat.subtract( Matrix.I(3).x(m)); // K = mat - I*tr(mat)
		var q = K.determinant() / 2;
		var tempForm = K.x(K);
	 
		var p = sumMatrix(tempForm) / 6;
	 
		// NB in Smith's paper he uses phi = (1/3)*arctan(sqrt(p*p*p - q*q)/q), which is equivalent to below:
		var phi = (1/3)*Math.acos(q/Math.sqrt(p*p*p));
	 
		if (Math.abs(q) >= Math.abs(Math.sqrt(p*p*p))) {
			phi = 0;
		}
	 
		if (phi < 0) {
			phi = phi + Math.PI/3;
		}
	 
		var eig1 = m + 2*Math.sqrt(p)*Math.cos(phi);
		var eig2 = m - Math.sqrt(p)*(Math.cos(phi) + Math.sqrt(3)*Math.sin(phi));
		var eig3 = m - Math.sqrt(p)*(Math.cos(phi) - Math.sqrt(3)*Math.sin(phi));
	 
		return [eig1, eig2, eig3];
	}

	function getCofactorMatrix(mat) {
		var dims = mat.dimensions();
		var xSize = dims.cols;
		var ySize = dims.rows;
		var output = mat.map(function(x, i, j) { return mat.minor(i+1,j+1,xSize-1, ySize-1).determinant(); } );
		return output;
	}

	function getStddevs(vectors) {
		if (vectors.length == 0) { return []; }
		var sum = Vector.Zero(vectors[0].dimensions());
		for (var k=0; k<vectors.length; k++) {
			sum = sum.add(vectors[k]);
		}
		var avg = sum.multiply(1/(vectors.length));
		var covarianceMatrix = Matrix.Zero(avg.dimensions(), avg.dimensions());
		for (var k=0; k<vectors.length; k++) {
			var temp = vectors[k].subtract(avg);
			covarianceMatrix = covarianceMatrix.map(function(x, i, j) { return x + temp.elements[i-1]*temp.elements[j-1]; } );
		}
		var values = getEigenvalues(covarianceMatrix);
		for (var k=0; k<values.length; k++) {
			values[k] = Math.sqrt(Math.abs(values[k]));
		}
		return values;
	}
	
	function clear() {
		pointBuffer = [];
		publicApi.isSteady = false;
	}
	
	// method: addPosition
	// Add an external position [x,y,z] to the steady detector
	//
	// Arguments:
	//   position - the external position [x,y,z] to add
	function addPosition(position) {
		pointBuffer.push($V(position));
		while (pointBuffer.length > frameCount) {
			pointBuffer.shift();
		}
		pb = pointBuffer;
		var steadyThisFrame = true;
		var stdDevs = getStddevs(pointBuffer);
		for (var k=0; k<stdDevs.length; k++) {
			steadyThisFrame &= stdDevs[k] < publicApi.maxVariance;
		}
		if (steadyThisFrame && (!publicApi.isSteady)) {
			publicApi.isSteady = true;
			events.fireEvent('steady', publicApi);
			events.fireEvent('steadychanged', publicApi);
		} else if (!steadyThisFrame && publicApi.isSteady) {
			publicApi.isSteady = false;
			events.fireEvent('unsteady', publicApi);
			events.fireEvent('steadychanged', publicApi);
		}
	}

	function onsessionstart(focusPosition) {
		clear();
	}

	function onsessionupdate(position) {
		addPosition(position);
	}
	
	var publicApi = {
		addPosition : addPosition,
		// property: maxVariance
		// Steady detector sensitivity
		maxVariance : maxVariance,
		onsessionstart : onsessionstart,
		onsessionupdate : onsessionupdate,
		// property: isSteady
		// Is hand steady right now? *Read only*.
		isSteady : false,
	}
	events.eventify(publicApi);
	return publicApi;
}

//-----------------------------------------------------------------------------
// class: Fader
// Axis aligned fader. Can be oriented on x, y, or z. The fader can also be split up into logical items using <itemsCount>.
// 
// event: valuechange
// Triggered whenever the fader value changes
//
// event: edge
// Triggered when the fader reaches an edge (value of 0 or 1). Will only trigger once per edge
//
// event: hoverstart
// Triggered when the hand is hovering over <Fader.hoverItem>
//
// event: hoverstop
// Triggered when the hand is not hovering over <Fader.hoverItem> any more
//-----------------------------------------------------------------------------
function Fader(orientation, size) {
	// defaults
	size = size || 250;

	// return object
	var api = {
		// property: itemsCount
		// How many logical items on our Fader
		itemsCount : 1,
		// property: hysteresis
		// Used by <Fader.hoverstart> and <Fader.hoverstop> events.
		hysteresis : 0.1,
		// property: initialValue
		// Value of fader when hand is in the initial focus position of the UI session
		initialValue : 0.5,
		// property: flip
		// Use this to flip the value of the fader
		flip : false,
		// property: value
		// Current fader value. Useful for visualizing the fader
		value : 0,
		// property: hoverItem
		// Logical hovered item. -1 if not in session
		hoverItem : -1,
		// property: driftAmount
		// If larger than 0, the fader will drift towards current hand point until fader <value> is <initialValue>
		driftAmount : 0,
		// property: autoMoveToContain
		// If true, the fader will always move to contain current hand point
		autoMoveToContain : false,
		// property: size
		// Physical size of fader, in millimeters
		size : size,
		// property: orientation
		// Which <zig.Orientation> is this fader aligned to?
		orientation : orientation,

		updatePosition : updatePosition,
		updateValue : updateValue,
		moveTo : moveTo,
		moveToContain : moveToContain,
		onsessionstart : onsessionstart,
		onsessionupdate : onsessionupdate,
		onsessionend : onsessionend,
	}
	var events = Events();
	events.eventify(api);

	var isEdge = false;
	var center = [0,0,0];
	var fps = FpsCounter();

	// hand point control callbacks

	function onsessionstart(focusPosition) {
		moveTo(focusPosition, api.initialValue);
		api.value = api.initialValue;
		api.hoverItem = Math.floor(api.itemsCount * api.value);
		events.fireEvent('hoverstart', api);
	}

	function onsessionupdate(position) {
		updatePosition(position);
	}

	function onsessionend() {
		events.fireEvent('hoverstop', api);
		api.hoverItem = -1;
	}

	// method: updatePosition
	// Manually update a fader with external positions
	//
	// Arguments:
	//   position - external position [x,y,z]
	function updatePosition(position) {
		fps.markframe();
		if (api.autoMoveToContain) {
			moveToContain(position);
		}

		var distanceFromCenter = position[api.orientation] - center[api.orientation];
		var ret = (distanceFromCenter / api.size) + 0.5;
		ret = clamp(ret, 0, 1);
		if (api.flip) ret = 1 - ret;
		updateValue(ret);

		if (api.driftAmount != 0) {
			var delta = api.initialValue - api.value;
			moveTo(position, api.value + (delta * 0.05));//api.driftAmount * fps.lastDelta));
		}
	}

	// method: updateValue
	// Manually update the fader with external values
	//
	// Arguments:
	//   value - normalized (0-1) external value
	function updateValue(value) {
		var newSelected = api.hoverItem;
		var minValue = (api.hoverItem * (1 / api.itemsCount)) - api.hysteresis;
		var maxValue = (api.hoverItem + 1) * (1 / api.itemsCount) + api.hysteresis;
		
		api.value = value;
		events.fireEvent('valuechange', api);
		
		var isThisFrameEdge = (value == 0) || (value == 1);
		if (!isEdge && isThisFrameEdge) {
			events.fireEvent('edge', api);
		}
		isEdge = isThisFrameEdge;

		if (api.value > maxValue) {
			newSelected++;
		}
		if (api.value < minValue) {
			newSelected--;
		}
		
		if (newSelected != api.hoverItem) {
			events.fireEvent('hoverstop', api);
			api.hoverItem = newSelected;
			events.fireEvent('hoverstart', api);
		}		
	}
	
	// method: moveTo
	// Move the fader so that when the hand is at given position, the <Fader.value> will be given value
	//
	// Arguments:
	//   position - position [x,y,z]
	//   value - target value for given position
	function moveTo(position, value) {
		if (api.flip) value = 1 - value;
		center[api.orientation] = position[api.orientation] + ((0.5 - value) * api.size);
	}
	
	// method: moveToContain
	// Move the fader to ensure that given position is within the fader bounds
	//
	// Arguments:
	//   position - position [x,y,z]
	function moveToContain(position) {
		var distanceFromCenter = position[api.orientation] - center[api.orientation];
		if (distanceFromCenter > api.size / 2) {
			center[api.orientation] += distanceFromCenter - (api.size / 2);
		} else if (distanceFromCenter < api.size / -2) {
			center[api.orientation] += distanceFromCenter + (api.size / 2);
		}
	}

	return api;
}

// 3D fader
function Fader3D(size) {
	var events = Events();
	var api = {
		size : size,
		value : [0,0,0],
		initialValue : [0.5, 0.5, 0.5],
		onsessionstart : onsessionstart,
		onsessionupdate : onsessionupdate,
		onsessionend : function() {},
	}
	events.eventify(api);

	var center = [0,0,0];

	function onsessionstart(focusPosition) {
		moveTo(focusPosition, api.initialValue);
	}

	function onsessionupdate(position) {
		var d = $V(position).subtract($V(center)).elements;
		var val = [clamp((d[0]/api.size[0]) + 0.5, 0, 1),
				   clamp((d[1]/api.size[1]) + 0.5, 0, 1),
				   clamp((d[2]/api.size[2]) + 0.5, 0, 1)];
		updateValue(val);
	}

	function updateValue(value) {
		api.value = value;
		events.fireEvent('valuechange', api);
	}

	function moveTo(position, value) {
		//var delta = vscale($V([0.5,0.5,0.5]).subtract($V(value)).elements, api.size);
		//center = position.add($V(delta)).elements;
		center[0] = position[0] + ((0.5 - value[0]) * api.size[0]);
		center[1] = position[1] + ((0.5 - value[1]) * api.size[1]);
		center[2] = position[2] + ((0.5 - value[2]) * api.size[2]);
	}

	return api;
}

// 2D fader
function Fader2D(width, height) {
	width = width || 300;
	height = height || 250;

	var events = Events();
	var api = {
		width : width,
		height : height,
		value : [0,0],
		onsessionstart : onsessionstart,
		onsessionupdate : onsessionupdate,
		onsessionend : onsessionend,
	}
	events.eventify(api);

	var fader3d = Fader3D([width, height, 1]);
	fader3d.addEventListener('valuechange', function(f) {
		api.value[0] = f.value[0];
		api.value[1] = f.value[1];
		events.fireEvent('valuechange', api);
	});

	function onsessionstart(focusPosition) {
		fader3d.onsessionstart(focusPosition);
	}
	function onsessionupdate(position) {
		fader3d.size[0] = api.width;
		fader3d.size[1] = api.height;
		fader3d.onsessionupdate(position);
	}
	function onsessionend() {
		fader3d.onsessionend();
	}

	return api;
}

//-----------------------------------------------------------------------------
// class: PushDetector
// Detects push gestures
//
// event: push
// Push
//
// event: release
// Release
//
// event: click
// Click
//-----------------------------------------------------------------------------
function PushDetector(size) {
	size = size || 160;

	var api = {
		// property: isPushed
		// push state, true when pushed. *read only*
		isPushed : false,
		// property: pushProgress
		// Normalized push progress, useful for push visualization on a cursor
		pushProgress : 0,
		// property: pushTime
		// Timestamp of last push
		pushTime : 0,
		// property: pushPosition
		// position of last push event
		pushPosition : [0,0,0],
		// property: driftAmount
		// How fast should the push detector drift after the hand point
		driftAmount : 15,
		// method: release
		// force a release. should be called after the push event, and before the 
		// release event. 
		release : release,
		fader : undefined,
		onsessionstart: onsessionstart,
		onsessionupdate: onsessionupdate,
		onsessionend : onsessionend,
	}
	var events = Events();
	events.eventify(api);

	var fader = Fader(Orientation.Z, size);
	fader.flip = true; // positive Z is backwards by default, so flip it
	fader.initialValue = 0.2;
	fader.autoMoveToContain = true;
	api.fader = fader;

	fader.driftAmount = api.driftSpeed; // mm/s
	
	function onsessionstart(focusPosition) {
		fader.onsessionstart(focusPosition);
	}

	function onsessionupdate(position) {
		fader.moveToContain(position);
		fader.onsessionupdate(position);
		api.pushProgress = fader.value;
		
		if (!api.isPushed) {
			if (1.0 == api.pushProgress) {
				api.isPushed = true;
				api.pushTime = (new Date()).getTime();
				api.pushPosition = position;
				fader.driftAmount = 0; // stop drifting when pushed
				events.fireEvent('push', api);
			}
		} else {
			if (api.pushProgress < 0.5) {
				release();
			}
		}
	}

	function release() {
		if (!api.isPushed) return;
		api.isPushed = false;
		fader.driftAmount = api.driftAmount;
		events.fireEvent('release', api);
		if (isClick()) {
			events.fireEvent('click', api);
		}		
	}
	
	function onsessionend() {
		fader.onsessionend();
		if (api.isPushed) {
			api.isPushed = false;
			events.fireEvent('release', api);
		}
	}

	function isClick() {
		var delta = (new Date()).getTime() - api.pushTime;
		return (delta < 1000);
	} 

	return api;
}

//-----------------------------------------------------------------------------
// class: SwipeDetector
// Detects swipes
//
// event: swipeup
// Swipe up
//
// event: swipedown
// Swipe down
//
// event: swipeleft
// Swipe left
//
// event: swiperight
// Swipe right
//
// event: swipe
// Triggered every swipe with direction argument. Direction will be one of 'up', 'down', 'left', or 'right'.
//
// event: swiperelease
// Triggered after a swipe is 'released', when the hand moves back towards the initial position
//-----------------------------------------------------------------------------
function SwipeDetector() {
	var events = Events();
	var horizontalFader = Fader(Orientation.X);
	var verticalFader = Fader(Orientation.Y);
	var api = {
		// property: driftAmount
		// How fast should the swipe detector follow the hand point
		driftAmount : 20,
		// property: horizontalFader
		// Internal <Fader> used to detect horizontal swipes. *Read only*.
		horizontalFader : horizontalFader,
		// property: verticalFader
		// Internal <Fader> used to detect vertical swipes. *Read only*.
		verticalFader : verticalFader,
		// property: isSwiped
		// True when the swipe detector is 'swiped', between one of the swipe* events and the <swiperelease> event
		isSwiped : false,
		onattach : onattach,
		ondetach : ondetach,
		onedge : onedge,
		onvaluechange : onvaluechange,
	}
	events.eventify(api);

	horizontalFader.autoMoveToContain = true;
	verticalFader.autoMoveToContain = true;
	horizontalFader.driftAmount = api.driftAmount;
	verticalFader.driftAmount = api.driftAmount;

	horizontalFader.swipeDirections = ['left','right'];
	verticalFader.swipeDirections = ['down','up'];

	horizontalFader.addListener(api);
	verticalFader.addListener(api);

	function onedge(fader) {
		var dir = fader.swipeDirections[fader.value];
		events.fireEvent('swipe' + dir, api);
		events.fireEvent('swipe', dir);
		fader.driftAmount = 0;
		fader.swipeValue = fader.value;
	}

	function onvaluechange(fader) {
		if (undefined !== fader.swipeValue) {
			if (Math.abs(fader.swipeValue - fader.value) >= 0.5) {
				delete fader.swipeValue;
				fader.driftAmount = api.driftAmount;
				events.fireEvent('swiperelease', api);
			}
		}
	}

	function onattach(target) {
		target.addListener(horizontalFader);
		target.addListener(verticalFader);
	}

	function ondetach(target) {
		target.removeListener(horizontalFader);
		target.removeListener(verticalFader);
	}

	return api;
}

//-----------------------------------------------------------------------------
// class: Cursor
// Basic cursor, implemented using <Fader2D> and <PushDetector>
//
// event: push
// Push
//
// event: release
// Release
//
// event: click
// Click
//-----------------------------------------------------------------------------
function Cursor() {
	var fader2d = Fader2D();
	var pushDetector = PushDetector();

	var events = Events();
	var api = {
		onattach : onattach,
		ondetach : ondetach,
		pushDetector : pushDetector,
		fader2d : fader2d,
		value : [0,0],
		x : 0,
		y : 0,
	}
	events.eventify(api);
	
	fader2d.addEventListener('valuechange', function(f) {
		api.value[0] = api.x = f.value[0];
		api.value[1] = api.y = 1 - f.value[1];
		events.fireEvent('move', api);
	});

	pushDetector.addEventListener('push', function(pd) {
		events.fireEvent('push', api);
	});
	pushDetector.addEventListener('release', function(pd) {
		events.fireEvent('release', api);
	});
	pushDetector.addEventListener('click', function(pd) {
		events.fireEvent('click', api);
	});

	function onattach(target) {
		target.addListener(fader2d);
		target.addListener(pushDetector);
	}

	function ondetach(target) {
		target.removeListener(fader2d);
		target.removeListener(pushDetector);
	}

	return api;
}

//-----------------------------------------------------------------------------
// class: WaveDetector
// Detects wave gestures
//
// event: wave
// Triggered when a wave gesture is detected
//-----------------------------------------------------------------------------
function WaveDetector() {
	var fader = Fader(Orientation.X, 100);
	fader.autoMoveToContain = true;
	fader.driftAmount = 15;

	var api = {
		onattach : onattach,
		ondetach : ondetach,
		// property: fader
		// The <Fader> used internally by the wave detector
		fader : fader,
		// property: numberOfWaves
		// How many waves before we trigger the <wave> event
		numberOfWaves : 5,
	}
	var events = Events();
	events.eventify(api);

	var edgebuffer = []
	var lastEdge = -1;

	fader.addEventListener('edge', function(f) {
		var now = (new Date()).getTime();
		while ((edgebuffer.length > 0) && (now - edgebuffer[0] > 2000)) edgebuffer.shift();
		if (edgebuffer.length == 0) lastEdge = -1;
		if (lastEdge != f.value) edgebuffer.push(now);
		lastEdge = f.value;

		if (edgebuffer.length >= api.numberOfWaves) {
			events.fireEvent('wave', api);
			edgebuffer=[];
		}
	});

	function onattach(target) {
		target.addListener(fader);
	}
	function ondetach(target) {
		target.removeListener(fader);
	}

	return api;
}

//-----------------------------------------------------------------------------
// class: HandSessionDetector
// Manages the lifetime of hand point based sessions.
//
// event: sessionstart(focusPosition)
// Triggered when a hand session is started, with the initial focus position as an argument
//
// event: sessionupdate(position)
// Triggered every frame during a session with current hand position
// 
// event: sessionend
// Triggered when the session ends. This can happen if tracked hand is lowered, or if the tracked user leaves the scene
//-----------------------------------------------------------------------------
function HandSessionDetector() {
	var events = Events();
	var api = {
		// property: shouldRotateHand
		// Attempt to normalize hand positions to sensor center. Makes implementing UI controls a bit easier if we can assume the user is always facing the sensor, even when this isn't the case
		shouldRotateHand : true,
		// property: shouldSmoothPoints
		// Should hand points be smoothed
		shouldSmoothPoints : true,
		onuserupdate : onuserupdate,
		onattach : onattach,
		ondetach : ondetach,
		startSession : startSession,
		stopSession : stopSession,
		// property: startOnWave
		// Should a hand session start when user waves?
		startOnWave : true,
		// property: startOnSteady
		// Should a hand session start on hand steady?
		startOnSteady : true,
		startOnExternalHandpoint : true,
		// property: bbox
		// Bounding box for session bounds
		bbox : BoundingBox([1000, 500, 500]),
		// property: bboxOffset
		// Offset of session bounds from user position
		bboxOffset : [0, 250, -300],
		// property: focusPosition
		// focus point for current session
		focusPosition : [0,0,0]
	}
	events.eventify(api);

	//var bboxOffset = $V([0, 250, -300]);
	//var bbox = BoundingBox([1000, 500, 500]);

	var rotateReference;
	var inSession = false;
	var jointToUse;
	var useExternalHandpoint = false;
	var framesNotInBbox = 0;
	var maxFramesNotInBbox = 15;
	var lastPosition = undefined;

	var currentUser;

	function onattach(user) {
		currentUser = user;
		rotateReference = user.position;

		if (api.startOnWave) {
			var wdLeft = WaveDetector();
			var wdRight = WaveDetector();
			wdLeft.addEventListener('wave', sessionShouldStart);
			wdRight.addEventListener('wave', sessionShouldStart);
			user.mapJointToControl(Joint.LeftHand, wdLeft);
			user.mapJointToControl(Joint.RightHand, wdRight);
		}

		if (api.startOnSteady) {
			var sdLeft = SteadyDetector();
			var sdRight = SteadyDetector();
			sdLeft.addEventListener('steady', sessionShouldStart);
			sdRight.addEventListener('steady', sessionShouldStart);
			user.mapJointToControl(Joint.LeftHand, sdLeft);
			user.mapJointToControl(Joint.RightHand, sdRight);
		}
	}

	function ondetach(user) {
		if (inSession) {
			inSession = false;
			events.fireEvent('sessionend');
		}
		currentUser = undefined;
		// TODO: unmap joint->control
	}
	
	function rotatedPoint(point) {
		return (api.shouldRotateHand) ? rotatePoint(point, rotateReference) : point;
	}

	function inBbox(point) {
		var userPosition = rotatedPoint(currentUser.position);
		api.bbox.recenter($V(userPosition).add($V(api.bboxOffset)));
		return api.bbox.contains(rotatedPoint(point));
	}

	function sessionShouldStart(detector) {
		if (inSession) return;
		
		if (inBbox(currentUser.skeleton[detector.mappedJoint].position)) {
			startSession(detector.mappedJoint);
		}
	}

	function onuserupdate(userData) {
		if (!inSession && api.startOnExternalHandpoint && 
			userData.skeleton.hasOwnProperty(Joint.ExternalHandpoint)) {
			sessionShouldStart({mappedJoint : Joint.ExternalHandpoint });
		}

		if (inSession && jointToUse == Joint.ExternalHandpoint && 
			!userData.skeleton.hasOwnProperty(Joint.ExternalHandpoint)) {
			stopSession();
		}
		
		rotateReference = vlerp(rotateReference, userData.position, 0.5);
		if (inSession) {
			var pos = userData.skeleton[jointToUse].position;
			if (!inBbox(pos)) {
				framesNotInBbox++;
				if (framesNotInBbox >= maxFramesNotInBbox) {
					framesNotInBbox = 0;
					stopSession();
				}
			} else {
				framesNotInBbox = 0;
				var rotatedPos = rotatedPoint(pos);
				if (api.shouldSmoothPoints) {
					rotatedPos = vlerp(lastPosition, rotatedPos, 0.8);
				}
				lastPosition = rotatedPos;
				events.fireEvent('sessionupdate', lastPosition);
			}
		}
	}

	function startSession(joint) {
		stopSession();
		inSession = true;
		jointToUse = joint;
		lastPosition = rotatedPoint(currentUser.skeleton[joint].position);
		api.focusPosition = lastPosition;
		events.fireEvent('sessionstart', api.focusPosition);
	}

	function stopSession() {
		if (inSession) {
			inSession = false;
			events.fireEvent('sessionend');
		}
	}

	function onlistenerattach(listener) {
		if (inSession) {
			events.fireEvent("sessionstart", api.focusPosition, listener);
		}
	}

	function onlistenerdetach(listener) {
		if (inSession) {
			events.fireEvent("sessionend", null, listener);
		}
	}

	function rotatePoint(handPos, comPos)
	{
		// change the forward vector to be u = (CoM - (0,0,0))
		// instead of (0,0,1)
		var cx = comPos[0];
		var cy = comPos[1];
		var cz = comPos[2];
		
		var len = Math.sqrt(cx*cx + cy*cy + cz*cz);
		// project the vector to XZ plane, so it's actually (cx,0,cz). let's call it v
		// so cos(angle) = v . u / (|u|*|v|)
		var lenProjected = Math.sqrt(cx*cx + cz*cz);
		var cosXrotation = (cx*cx + cz*cz) / (lenProjected * len); // this can be slightly simplified
		var xRot = Math.acos(cosXrotation);
		if (cy < 0) xRot = -xRot; // set the sign which we lose in 
		// now for the angle between v and the (0,0,1) vector for Y-axis rotation
		var cosYrotation = cz / lenProjected;
		var yRot = Math.acos(cosYrotation);
		if (cx > 0) yRot = -yRot;
		return (Matrix.RotationX(xRot).x(Matrix.RotationY(yRot))).x($V(handPos)).elements;
	}

	return api;
}


//-----------------------------------------------------------------------------
// user engagers
//-----------------------------------------------------------------------------

// class: EngageFirstUserInSession
// Waits for the first user in session
function EngageFirstUserInSession() {
	var events = Events();
	var api = {
		onuserfound : onuserfound,
		onuserlost : onuserlost,
		onlistenerattach : onlistenerattach,
		onlistenerdetach : onlistenerdetach,
		engagedUser : null,
		engagedHSD : null,
		bboxBounds : [1000, 500, 500],
		bboxOffset : [0, 250, -300],
		startOnWave : true,
		startOnSteady : true,
		startOnExternalHandpoint : true,
	}
	events.eventify(api);
	var engagedUserId = 0;
	var inSession = false;
	var focusPosition = [0,0,0];

	function onsessionstart(user, fp, detector) {
		if (engagedUserId != 0) return;

		inSession = true;
		focusPosition = fp
		engagedUserId = user.id;
		api.engagedUser = user;
		api.engagedHSD = detector;
		events.fireEvent('userengaged', user);
		events.fireEvent('sessionstart', focusPosition);
	}

	function onsessionupdate(user, position) {
		if (user.id == engagedUserId) {
			events.fireEvent('sessionupdate', position);
		}
	}

	function onsessionend(user) {
		if (user.id == engagedUserId) {
			engagedUserId = 0;
			api.engagedUser = null;
			api.engagedHSD = null;
			events.fireEvent('sessionend');
			events.fireEvent('userdisengaged', user);
		}
	}

	function onuserfound(newUser) {
		var sessionDetector = HandSessionDetector();
		sessionDetector.bbox.resize(api.bboxBounds);
		sessionDetector.bboxOffset = api.bboxOffset;
		sessionDetector.startOnWave = api.startOnWave;
		sessionDetector.startOnSteady = api.startOnSteady;
		sessionDetector.startOnExternalHandpoint = api.startOnExternalHandpoint;

		sessionDetector.addEventListener('sessionstart', function(focusPosition) {
			onsessionstart(newUser, focusPosition, sessionDetector);
		});
		sessionDetector.addEventListener('sessionupdate', function(position) {
			onsessionupdate(newUser, position);
		});
		sessionDetector.addEventListener('sessionend', function() {
			onsessionend(newUser);
		});

		newUser.addListener(sessionDetector);
	}

	function onuserlost(lostUser) {
		if (lostUser.id == engagedUserId) {
			onsessionend(lostUser);
		}
	}

	function onlistenerattach(listener) {
		if (inSession) {
			events.fireEvent("sessionstart", focusPosition, listener);
		}
	}

	function onlistenerdetach(listener) {
		if (inSession) {
			events.fireEvent("sessionend", null, listener);
		}
	}

	return api;
}

// class: EngageUsersWithSkeleton
// Waits for the first n users with skeleton tracking to enter the frame
function EngageUsersWithSkeleton(count) {
	if (undefined === count) {
		count = 1;
	}

	var events = Events();
	var api = {
		onuserlost : onuserlost,
		ondataupdate : ondataupdate,
	}
	events.eventify(api);

	var engagedUsers = [];

	function ondataupdate(zigObject) {
		// if we're looking for more users to engage
		if (engagedUsers.length < count) {
			for (var userid in zigObject.users) if (zigObject.users.hasOwnProperty(userid)) {
				var user = zigObject.users[userid];
				if (user.skeletonTracked && (-1 == engagedUsers.indexOf(user))) {
					if (engagedUsers.length < count) {
						engagedUsers.push(user);
						events.fireEvent('userengaged', user);
					}
				}
			}

			if (engagedUsers.length == count) {
				events.fireEvent('allusersengaged', engagedUsers);
			}
		}
	}

	function onuserlost(lostUser) {
		var i = engagedUsers.indexOf(lostUser);
		if (-1 != i) {
			engagedUsers.splice(i, 1);
			events.fireEvent('userdisengaged', lostUser);
		}
	}

	return api;
}

//-----------------------------------------------------------------------------
// class: UserJoint
// Represents a tracked joint
//-----------------------------------------------------------------------------
function UserJoint() {
	// property: id
	// The <zig.Joint> of this joint. *Read only*.
	var id;
	// property: position
	// Joint position as 3d vector [x,y,z] in millimeters relative to the depth sensor [x,y,z] *Read only*.
	var position;
	// property: rotation
	// Joint orientation as 3x3 rotation matrix relative to the depth sensor. *Read only*.
	var rotation;
}

//-----------------------------------------------------------------------------
// class: User
// Represents a tracked user
//
// event: userupdate
// Called every frame, with the tracked <User> as the single argument
//-----------------------------------------------------------------------------
function User(userData) {

	var api = {
		// property: id
		// User id as reported by middleware. *Read only*.
		id : 0,
		// property: positionTracked
		// true if user has a valid position. *Read only*.
		positionTracked : false,
		// property: position
		// Position of user relative to the sensor, only valid if <positionTracked> is true. *Read only*.
		position : [0,0,0],
		// property: skeletonTracked
		// true if user has full body skeleton data available. *Read only*.
		skeletonTracked : false,
		// property: skeleton
		// Full body skeleton data, only valid if <skeletonTracked> is true. Collection of <UserJoints> indexed by <UserJoint.id>. *Read only*.
		skeleton : {},
		mapJointToControl : mapJointToControl,
		update : update,
	};

	update(userData);

	function update(userData) {
		api.id = userData.id;
		api.positionTracked = true;
		api.position = userData.centerofmass;
		api.skeletonTracked = (userData.tracked > 0);

		// convert joints from an array to associative list for easier access
		var currjoints = userData.joints;
		var newjoints = {};
		for (var i=0; i<currjoints.length; i++) {
			newjoints[currjoints[i].id] = currjoints[i];
		}
		api.skeleton = newjoints;
	}

	// method: mapJointToControl
	// Updates a control with data from a specific <zig.Joint> for tracked <User>
	//
	// Arguments:
	//   joint - the <zig.Joint> to map to the control
	//   control - listener
	//
	// Return Value:
	// The function returns a listener object that can be used with <removeListener> to remove this joint to control mapping
	function mapJointToControl(joint, control) {
		var events = Events();
		var inSession = false;

		function onuserupdate(userData) {
			if (userData.skeletonTracked && userData.skeleton.hasOwnProperty(joint)) {
				if (!inSession) {
					control.mappedJoint = joint;
					inSession = true;
					events.fireEvent('sessionstart', userData.skeleton[joint].position);
				}
				events.fireEvent('sessionupdate', userData.skeleton[joint].position);
			} else if (inSession) {
				inSession = false;
				delete control.mappedJoint;
				events.fireEvent('sessionend');
			}
		}

		var adapter = {
			onuserupdate : onuserupdate
		}
		events.eventify(adapter);
		adapter.addListener(control);
		api.addListener(adapter);
		return adapter;
	}

	return api;
}

//-----------------------------------------------------------------------------
// class: zig
//
// event: userfound(user)
// Triggered when a new <User> enters the scene
//
// event: userleft(user)
// Triggered when a tracked <User> leaves the scene
//
// event: dataupdate
// Triggered every frame
//
// event: statuschange
// Triggered when <sensorConnected> changes
//-----------------------------------------------------------------------------
zig = (function() {
	var plugin;

	// both of these will hold data per user (indexed by userid)
	var trackedUsers = {};
	var userCallbacks = {};

	var controls = {
		SteadyDetector : SteadyDetector,
		Fader : Fader,
		Fader2D : Fader2D,
		Fader3D : Fader3D,
		PushDetector : PushDetector,
		SwipeDetector : SwipeDetector,
		WaveDetector : WaveDetector,
		Cursor : Cursor,
	}

	var version = "0.9.9";

	var publicApi = {
		// method: init
		// Initializes zigjs using an existing plugin object
		init : init,
		// method: embed
		// Initializes zigjs by embedding a new plugin object in the dom
		embed : embed,
		// method : findZigObject
		// Find the zig object dom element, or null if none found
		findZigObject : findzigobject,
		// property: pluginInstalled
		// true if zig.js plugin is installed
		pluginInstalled : false,
		// property: version
		// Zig.js version number, not to be confused with the plugin version number. *Read only*.
		version : version,
		// property: pluginVersion
		// Browser plugin version, not to be confused with zig.js version
		pluginVersion : 0,
		// property: verbose
		// Output zig.js trace messages to console
		verbose : true,
		// property: users
		// Collection of <Users> currently tracked, indexed by <User.id>. *Read only*.
		users : trackedUsers,
		// property: sensorConnected
		// true when the a depth sensor is connected, false otherwise
		sensorConnected : false,

		Joint : Joint,
		Orientation : Orientation,

		EngageFirstUserInSession : EngageFirstUserInSession,
		EngageUsersWithSkeleton : EngageUsersWithSkeleton,
		HandSessionDetector : HandSessionDetector,
		controls : controls,
	}

	// Make sure our public API supports events
	var events = Events();
	events.eventify(publicApi);

	function log(text) {
		if (publicApi.verbose) console.log("Zig: " + text);
	}

	function bindDomEvent(target,eventName,handlerName) {
		if (target.attachEvent) {
			target.attachEvent("on" + eventName, handlerName);
		} else if ( target.addEventListener ) {
			target.addEventListener(eventName, handlerName, false);
		} else {
			target["on" + eventName] = handlerName;
		}
	}

	function getItemById(collection, id) {
		for (var key in collection) if (collection.hasOwnProperty(key)) {
			if (collection[key].id == id) return collection[key];
		}
		return undefined;
	}

	function doUpdate(users, hands) {
		var toRemove = [];
		var toAdd = [];

		// find users to remove
		for (var userid in trackedUsers) if (trackedUsers.hasOwnProperty(userid)) {
			if (undefined === getItemById(users, userid)) {
				var lostUser = trackedUsers[userid];
				delete trackedUsers[userid];
				toRemove.push(lostUser);
			}
		}

		// find users to add
		for (var key in users) if (users.hasOwnProperty(key)) {
			if (!trackedUsers.hasOwnProperty(users[key].id)) {
				
				// create the new user & feed it with initial data
				var userEvents = Events();
				var newUser = User(users[key])
				userEvents.eventify(newUser);

				// add to internal lists
				trackedUsers[newUser.id] = newUser;
				userCallbacks[newUser.id] = userEvents;

				// keep track for later
				toAdd.push(newUser);
			}
		}

		// update user data for each tracked user
		for (var userid in trackedUsers) if (trackedUsers.hasOwnProperty(userid)) {
			var user = getItemById(users, userid);
			if (undefined === user) {
				console.log('ERROR!! getItemById returned undefined for userid ' + userid);
				console.log(users);
				console.log(trackedUsers);
				continue;
			} 
			trackedUsers[userid].update(getItemById(users, userid));
		}

		// add external hand points to users
		hands.forEach(function(hand) {
			if (trackedUsers.hasOwnProperty(hand.userid)) {
				trackedUsers[hand.userid].skeleton[Joint.ExternalHandpoint] = {
					id : Joint.ExternalHandpoint,
					position : hand.position,
				};
			}
		});

		// fire all add/remove events 
		toRemove.forEach(function(user) { log('Lost user: ' + user.id); user.removeListener(); events.fireEvent('userlost', user); });
		toAdd.forEach(function(user) { log('New user: ' + user.id); events.fireEvent('userfound', user); });

		// fire all update events (dataupdate for all users and userupdate for each user)
		events.fireEvent('dataupdate', publicApi);
		for (var userid in trackedUsers) if (trackedUsers.hasOwnProperty(userid)) {
			userCallbacks[userid].fireEvent('userupdate', trackedUsers[userid]);
		}
	}

	function init(zo) {
		plugin = zo;
		bindDomEvent(zo, "NewFrame", function () {
		 return function(data) { 
		 	try {
				var obj = JSON.parse(data); 
			} catch (e) { 
				console.log("Error parsing JSON from plugin, skipping frame");
				return;
			}
			doUpdate(obj.users, obj.hands);
		 }}());
		log("inited");
		events.fireEvent('loaded', zo);

		// anyone registering to 'loaded' event from now on will have his cb fired immediately
		var oldaddEventListener = publicApi.addEventListener;
		var newaddEventListener = function(eventName, cb) {
			oldaddEventListener(eventName, cb);
			if ('loaded' == eventName) {
				events.fireEvent('loaded', zo, cb);
			}
		}
		publicApi.addEventListener = newaddEventListener;

		publicApi.sensorConnected = zo.sensorConnected;
		bindDomEvent(zo, "StatusChange", function(status) {
			publicApi.sensorConnected = status;
			events.fireEvent('statuschange', status);
		});

		publicApi.pluginVersion = zo.version;
	}

	function embed(div) {
		if (null != findzigobject()) return;
		if (undefined === div) {
			div = document.createElement('div');
			document.body.appendChild(div);
		}
		if ('string' == typeof div) div = document.getElementById(div);

		var html = '<object id="zigPluginObject" type="application/x-zig" width="0" height="0"><param name="onload" value="zigloaded" /></object>';
		div.innerHTML = html;
		//return document.getElementById('zigPluginObject');
	}

	var zigobject = null;
	function findzigobject() {
		if (typeof zigobject == 'undefined') {
			zigobject = null;
		}

		if (null == zigobject) {
			var objs = document.getElementsByTagName('object');
			for (var i=0; i<objs.length; i++) {
				if (objs[i].requestStreams !== undefined) {
					zigobject = objs[i];
					break;
				}
			}
		}
		return zigobject;
	}

	function hasPlugin(mimeType) {
		for (var k in navigator.plugins) if (navigator.plugins.hasOwnProperty(k)) {
			var p = navigator.plugins[k];
			for (var mime in p) if (p.hasOwnProperty(mime)) {
				if (undefined !== p[mime].type && mimeType == p[mime].type) {
					return true;
				}
			}
		}
		return false;
	}

	function domloaded() {
		// try and embed the zig plugin object, if it isn't embedded already
		var zo = findzigobject();
		if (null != zo) {
			init(zo);
		} else {
			embed();
		}
	}
	document.addEventListener('DOMContentLoaded', function () { setTimeout(domloaded, 200); }, false); 

	// some default controls, always available
	// comment out if taking too much cpu
	publicApi.singleUserSession = EngageFirstUserInSession();
	publicApi.addListener(publicApi.singleUserSession);

	// is the plugin installed?
	publicApi.pluginInstalled = hasPlugin("application/x-zig");

	return publicApi;

}());
zigloaded = function() {
	zig.init(zig.findZigObject());	
}


// NOT SURE WHERE THESE ALL BELONG

zig.toys = (function() {

	function usersRadar(parentElement) {
		// physical dimensions of radar in room. Lets use 4m x 4m
		this.radarWidth = 4000;
		this.radarHeight = 4000;
	 
		this.onuserfound = function(user) {
			// create a new element for this user, add to dom
			var el = document.createElement('div');
			el.classList.add('user');
			parentElement.appendChild(el);
			// we can simply add the newly created element to the tracked user object for later
			user.radarElement = el;
	 
			// move the element every frame
			var that = this;
			user.addEventListener('userupdate', function(user) {
				// we need to convert [user.x, user.z] to [screen.x, screen.y]
				// first get normalized user position
				var xpos = (user.position[0] / that.radarWidth) + 0.5; // 0 for x is actually the center of the depthmap
				var ypos = (user.position[2] / that.radarHeight);
				// convert normalized position to fit into our radar element
				var el = user.radarElement;
				el.style.left = xpos * parentElement.offsetWidth - (el.offsetWidth / 2) + "px";
				el.style.top = ypos * parentElement.offsetHeight - (el.offsetHeight / 2) + "px";
			});
		}
		
		this.onuserlost = function(user) {
			// remove the element we created from the dom and ZDK user object
			parentElement.removeChild(user.radarElement);
			delete user.radarElement;
		}

		zig.singleUserSession.addEventListener('userengaged', function(user) {
			user.radarElement.classList.add('active');
		});
		zig.singleUserSession.addEventListener('userdisengaged', function(user) {
			user.radarElement.classList.remove('active');
		});
	}

	function injectRadar() {
		console.log('injecting radar');
		// create some style sheets for our radar
		var style = document.createElement('style');
		style.type = 'text/css';
		style.innerHTML = '#zigfuRadar { width:300px;height:300px;bottom:20px;right:20px;border-radius:15px;position:fixed;display:block;background:url(http://cdn.zigfu.com/zigjs/toys/radar.png) } ';
		style.innerHTML += '#zigfuRadar .user { width:35px; height:35px; position:relative;display:block; background:url(http://cdn.zigfu.com/zigjs/toys/user.png) } ';
		style.innerHTML += '#zigfuRadar .user.active { background:url(http://cdn.zigfu.com/zigjs/toys/user_active.png) } ';
		document.getElementsByTagName('head')[0].appendChild(style);

		// create radar element
		var re = document.createElement('div');
		re.id = 'zigfuRadar';
		document.body.appendChild(re);

		// create radar listener
		var r = new usersRadar(re);
		zig.addListener(r);
	}

	function injectCursor() {
		var c = zig.controls.Cursor();
		var ce = document.createElement('div');
		ce.style.position = 'fixed';
		ce.style.display = 'none';
		ce.style.width = '50px';
		ce.style.height = '50px';
		ce.style.backgroundColor = 'blue';
		document.body.appendChild(ce);

		// show/hide cursor on session start/end
		zig.singleUserSession.addEventListener('sessionstart', function(focusPosition) {
			ce.style.display = 'block';
		});
		zig.singleUserSession.addEventListener('sessionend', function() {
			ce.style.display = 'none';
		});

		// move the cursor element on cursor move
		c.addEventListener('move', function(cursor) {
			ce.style.left = (c.x * window.innerWidth - (ce.offsetWidth / 2)) + "px";
			ce.style.top = (c.y * window.innerHeight - (ce.offsetHeight / 2)) + "px";
		});

		// add the cursor to our singleUserSession to make sure we get events
		zig.singleUserSession.addListener(c);
	}

	return {
		injectCursor : injectCursor,
		injectRadar : injectRadar,
	}
}());

}()); // zig.js closure
} // if (undefined === zig)