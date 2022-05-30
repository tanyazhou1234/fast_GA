function mpcm(xx,yy,min_fs,max_fs,cpoint,weight)


mkdir("L_sound");	%出力音声格納用

##############初期値設定################
sp_num = 16; 	%スピーカ数
L = 2048;	%フィルタ長

freq=16000/L*[1:L/2];	%周波数48K
spdis=0.1;		%スピーカ素子間隔[m]
c=340;			%音速


############各SPから各制御点までの距離############################################
#disn(M,N)→M=制御点の数、N=スピーカー素子の数
#1各SPから制御点へ

#スピーカの座標
sp=zeros(sp_num,2);
for ii=1:sp_num/2
	sp(ii,1)=-(((sp_num/2-1)/2)-(ii-1))*spdis;
	sp(ii,2)=0;
endfor

for ii=sp_num/2+1:sp_num
	sp(ii,1)=-(((sp_num/2-1)/2)-(ii-sp_num/2-1))*spdis;
	sp(ii,2)=3;
endfor

#targetのx,y座標l
#応答点の座標

re_num=2;%応答制御点

tx=zeros(re_num,1);
ty=zeros(re_num,1);

tx(1)=-1;
ty(1)=1.5;

tx(2)=1;
ty(2)=1.5;

#各応答点から各スピーカまでの距離
for ii=1:re_num
	for jj=1:sp_num
		disn(ii,jj)=sqrt((tx(ii)-sp(jj,1)).^2 + (ty(ii)-sp(jj,2)).^2);
	endfor
endfor

#各抑圧点から各スピーカまでの距離
for kk=1:cpoint
	for jj=1:sp_num
		disn(kk+re_num,jj)=sqrt((xx(kk)-sp(jj,1)).^2 + (yy(kk)-sp(jj,2)).^2);
	endfor
endfor


cpoint_num = length(disn(:,1));             #制御点数

one=ones(re_num,1);
weight2=[one;weight];
A=diag(weight2);               #Aは重み係数を示す対角行列


II=eye(sp_num);               #正則化を行うための正方行列
gn = zeros(cpoint_num,sp_num);    #伝達関数の箱
target=zeros(cpoint_num,1);       #制御点性質の箱
target(1:re_num,1)=1;                #応答制御点に


ii=1:sp_num;
w_len=1:L/2;
###########フィルタ設計###############

for w = 1:L/2; %周波数


if freq(w)>=min_fs && freq(w) <=max_fs    #もし周波数帯域内なら

  k=2*pi*freq(w)/c;#波数 1024次元 2*pi*freq(w)=ω

  l=1:cpoint_num;
	m=1:sp_num;

  gn(l,m)=(1./(4*pi*disn(l,m))).*exp(-j*k*disn(l,m));#伝達関数

  #h=((gn'*gn)+(1.0e-1*II))\(gn'*target);
  h=((gn'*A*gn)+(1.0e-1*II))\(gn'*A*target);  #重みつき最小二乗法

  #######拘束条件#########

  H(ii,w)=h(ii,1);
  else
	H(ii,w)=0;	% Hに各スピーカ,周波数
  endif
endfor

############複素共役をとって1012→2024##############
H_conj(ii,w_len)=conj(H(ii,(L/2+1-w_len)));
H=[H H_conj];

#############フィルタのゲイン調整#################	%全フィルタ中の最大が0dB
for kk=1:sp_num;
A=H(kk,:);
B=10*log10(A.*conj(A));
if kk==1
C=max(B);
ll=kk;
endif
if max(B)>C
C=max(B);
ll=kk;
endif
endfor
max_filter_num=ll;	%最大のフィルタ番号
max_db=C;	%最大dB
amp=10.^(-C/20);		%dB調整係数


  H=conj(H');
  H=H*amp;
  H_time(:,ii)=real(ifft(H(:,ii)));  	%フィルタを時間領域に


###############音声作成#################
fname=sprintf("white.raw");
fpi1=fopen(fname,'r');

for jj=1:sp_num

	fname=sprintf("L_sound/sound%d.raw",jj);
	fo=fopen(fname,'w');
	signal1=fread(fpi1,inf,'short');
	signal2=fftfilt(H_time(:,jj),signal1);		%fftfiltで畳み込み
	yout1=int32(signal2);
	fwrite(fo,yout1,'short');

frewind(fpi1);
fclose(fo);
endfor

fclose(fpi1);
