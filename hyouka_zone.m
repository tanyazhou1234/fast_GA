function semisin = hyouka_zone(min_fs,max_fs)
#評価点配置正方型、マップを出力するプログラムのxy座標を指定したもの

mkdir("sound");
#音声ファイル読み込み
#tic()
#printf("hyouka: reading sound(form 32 loudspeakers): ")
fname=sprintf("L_sound/sound1.raw");
fpi1=fopen(fname,'r');
fname=sprintf("L_sound/sound2.raw");
fpi2=fopen(fname,'r');
fname=sprintf("L_sound/sound3.raw");
fpi3=fopen(fname,'r');
fname=sprintf("L_sound/sound4.raw");
fpi4=fopen(fname,'r');
fname=sprintf("L_sound/sound5.raw");
fpi5=fopen(fname,'r');
fname=sprintf("L_sound/sound6.raw");
fpi6=fopen(fname,'r');
fname=sprintf("L_sound/sound7.raw");
fpi7=fopen(fname,'r');
fname=sprintf("L_sound/sound8.raw");
fpi8=fopen(fname,'r');
fname=sprintf("L_sound/sound9.raw");
fpi9=fopen(fname,'r');
fname=sprintf("L_sound/sound10.raw");
fpi10=fopen(fname,'r');
fname=sprintf("L_sound/sound11.raw");
fpi11=fopen(fname,'r');
fname=sprintf("L_sound/sound12.raw");
fpi12=fopen(fname,'r');
fname=sprintf("L_sound/sound13.raw");
fpi13=fopen(fname,'r');
fname=sprintf("L_sound/sound14.raw");
fpi14=fopen(fname,'r');
fname=sprintf("L_sound/sound15.raw");
fpi15=fopen(fname,'r');
fname=sprintf("L_sound/sound16.raw");
fpi16=fopen(fname,'r');
#toc()
#printf("\n");
#printf("\n");

mnw=512;
L=256;
wnd=hamming(mnw)';%ハミング窓
%音速
c=340.0;
%マップの大きさ指定(メートル)
len=3.0;
%sp数
spnum=16.0;
%sp間の距離
spdis=0.1;
%メッシュ間隔
dis_x1=0.25;#再生評価点のメッシュ間隔
dis_y1=0.25;

dis_x0=0.25;#抑圧評価点のメッシュ間隔
dis_y0=0.25;
#tic()
#printf("hyouka: make evaluation points: ");
########reproducted evaluation points####
ii=0;
%%%--1---2---%%left & right zones%%
for yy_h=0.5:dis_y1:2.5
	for xx_h=0.5:dis_x1:0.75
		ii++;
		e_point_1(ii,1)=xx_h;
		e_point_1(ii,2)=yy_h;
		e_point_1(ii,3)=1;
	endfor

	for xx_h=2.25:dis_x1:2.5
		ii++;
		e_point_1(ii,1)=xx_h;
		e_point_1(ii,2)=yy_h;
		e_point_1(ii,3)=1;
	endfor

endfor


%%%--3---4---%%upper & down zones%%

for xx_h=1:dis_x1:2
	for yy_h=0.5:dis_y1:0.75
		ii++;
		e_point_1(ii,1)=xx_h;
		e_point_1(ii,2)=yy_h;
		e_point_1(ii,3)=1;
	endfor
	for yy_h=2.25:dis_y1:2.5
		ii++;
		e_point_1(ii,1)=xx_h;
		e_point_1(ii,2)=yy_h;
		e_point_1(ii,3)=1;
	endfor
endfor

num_1=ii;#再生評価点数

############################################

########suppressed evaluation points#######
jj=0;
for xx_h=1:dis_x0:2
	for yy_h=1:dis_y0:2
		jj++;
		e_point_0(jj,1)=xx_h;
		e_point_0(jj,2)=yy_h;
		e_point_0(jj,3)=0;
	endfor
endfor

num_0=jj; #抑圧評価点数
###########################################
#toc()
#printf("\n");
#printf("\n");

#tic()
#printf("再生評価点音圧生成: ");
%%%%%再生評価点音圧の計算%%%%%
for kk=1:num_1
	xx=e_point_1(kk,1);
	yy=e_point_1(kk,2);

dis(1,1)=sqrt((len/2-spdis*7.5-xx)^2 + yy^2);
dis(1,2)=sqrt((len/2-spdis*6.5-xx)^2 + yy^2);
dis(1,3)=sqrt((len/2-spdis*5.5-xx)^2 + yy^2);
dis(1,4)=sqrt((len/2-spdis*4.5-xx)^2 + yy^2);
dis(1,5)=sqrt((len/2-spdis*3.5-xx)^2 + yy^2);
dis(1,6)=sqrt((len/2-spdis*2.5-xx)^2 + yy^2);
dis(1,7)=sqrt((len/2-spdis*1.5-xx)^2 + yy^2);
dis(1,8)=sqrt((len/2-spdis*0.5-xx)^2 + yy^2);

dis(1,9)=sqrt((len/2+spdis*0.5-xx)^2 + (len-yy)^2);
dis(1,10)=sqrt((len/2+spdis*1.5-xx)^2 + (len-yy)^2);
dis(1,11)=sqrt((len/2+spdis*2.5-xx)^2 + (len-yy)^2);
dis(1,12)=sqrt((len/2+spdis*3.5-xx)^2 + (len-yy)^2);
dis(1,13)=sqrt((len/2+spdis*4.5-xx)^2 + (len-yy)^2);
dis(1,14)=sqrt((len/2+spdis*5.5-xx)^2 + (len-yy)^2);
dis(1,15)=sqrt((len/2+spdis*6.5-xx)^2 + (len-yy)^2);
dis(1,16)=sqrt((len/2+spdis*7.5-xx)^2 + (len-yy)^2);

%伝達関数算出
g1=zeros(1,L);
g2=zeros(1,L);
g3=zeros(1,L);
g4=zeros(1,L);
g5=zeros(1,L);
g6=zeros(1,L);
g7=zeros(1,L);
g8=zeros(1,L);
g9=zeros(1,L);
g10=zeros(1,L);
g11=zeros(1,L);
g12=zeros(1,L);
g13=zeros(1,L);
g14=zeros(1,L);
g15=zeros(1,L);
g16=zeros(1,L);


freq=16000/mnw*[1:mnw/2];
for(n=1:256)#制御したい周波数帯域をnで分割

if freq(n)>=min_fs && freq(n) <=max_fs  #設定された周波数帯域内であれば

	#freq=(8000/256)*n;#周波数
	k=2*pi*freq(n)/c;#波数

  %{
		for m=1:32
			if(dis(1,m) < 1.0e-5)
			  for n=1:16
				gn(1,n) = 0;
			  endfor
			  break;
			else
			gn(1,m)=(1/(4*pi*dis(1,m)))*exp(-j*k*dis(1,m));#伝達関数（周波数ごと）
			endif
		endfor
%}
      m=1:spnum;
		  gn(1,m)=(1./(4*pi*dis(1,m))).*exp(-j*k*dis(1,m));#伝達関数

	g1(n)=gn(1,1);
	g2(n)=gn(1,2);
	g3(n)=gn(1,3);
	g4(n)=gn(1,4);
	g5(n)=gn(1,5);
	g6(n)=gn(1,6);
	g7(n)=gn(1,7);
	g8(n)=gn(1,8);
	g9(n)=gn(1,9);
	g10(n)=gn(1,10);
	g11(n)=gn(1,11);
	g12(n)=gn(1,12);
	g13(n)=gn(1,13);
	g14(n)=gn(1,14);
	g15(n)=gn(1,15);
	g16(n)=gn(1,16);


else

	g1(n)=0;
	g2(n)=0;
	g3(n)=0;
	g4(n)=0;
	g5(n)=0;
	g6(n)=0;
	g7(n)=0;
	g8(n)=0;
	g9(n)=0;
	g10(n)=0;
	g11(n)=0;
	g12(n)=0;
	g13(n)=0;
	g14(n)=0;
	g15(n)=0;
	g16(n)=0;

endif


endfor

jj=1:L;

  g1=real(ifft([g1 conj(g1(257-jj))]));
  g2=real(ifft([g2 conj(g2(257-jj))]));
  g3=real(ifft([g3 conj(g3(257-jj))]));
  g4=real(ifft([g4 conj(g4(257-jj))]));
  g5=real(ifft([g5 conj(g5(257-jj))]));
  g6=real(ifft([g6 conj(g6(257-jj))]));
  g7=real(ifft([g7 conj(g7(257-jj))]));
  g8=real(ifft([g8 conj(g8(257-jj))]));
  g9=real(ifft([g9 conj(g9(257-jj))]));
  g10=real(ifft([g10 conj(g10(257-jj))]));
  g11=real(ifft([g11 conj(g11(257-jj))]));
  g12=real(ifft([g12 conj(g12(257-jj))]));
  g13=real(ifft([g13 conj(g13(257-jj))]));
  g14=real(ifft([g14 conj(g14(257-jj))]));
  g15=real(ifft([g15 conj(g15(257-jj))]));
  g16=real(ifft([g16 conj(g16(257-jj))]));


	x1buf=zeros(1,mnw);
	x2buf=zeros(1,mnw);
	x3buf=zeros(1,mnw);
	x4buf=zeros(1,mnw);
	x5buf=zeros(1,mnw);
	x6buf=zeros(1,mnw);
	x7buf=zeros(1,mnw);
	x8buf=zeros(1,mnw);
	x9buf=zeros(1,mnw);
	x10buf=zeros(1,mnw);
	x11buf=zeros(1,mnw);
	x12buf=zeros(1,mnw);
	x13buf=zeros(1,mnw);
	x14buf=zeros(1,mnw);
	x15buf=zeros(1,mnw);
	x16buf=zeros(1,mnw);

	y1buf=zeros(1,mnw);
	y2buf=zeros(1,mnw);
	y3buf=zeros(1,mnw);
	y4buf=zeros(1,mnw);
	y5buf=zeros(1,mnw);
	y6buf=zeros(1,mnw);
	y7buf=zeros(1,mnw);
	y8buf=zeros(1,mnw);
	y9buf=zeros(1,mnw);
	y10buf=zeros(1,mnw);
	y11buf=zeros(1,mnw);
	y12buf=zeros(1,mnw);
	y13buf=zeros(1,mnw);
	y14buf=zeros(1,mnw);
	y15buf=zeros(1,mnw);
	y16buf=zeros(1,mnw);

	z1buf=zeros(1,mnw);
	z2buf=zeros(1,mnw);
	z3buf=zeros(1,mnw);
	z4buf=zeros(1,mnw);
	z5buf=zeros(1,mnw);
	z6buf=zeros(1,mnw);
	z7buf=zeros(1,mnw);
	z8buf=zeros(1,mnw);
	z9buf=zeros(1,mnw);
	z10buf=zeros(1,mnw);
	z11buf=zeros(1,mnw);
	z12buf=zeros(1,mnw);
	z13buf=zeros(1,mnw);
	z14buf=zeros(1,mnw);
	z15buf=zeros(1,mnw);
	z16buf=zeros(1,mnw);

	out1=zeros(1,L);
	out2=zeros(1,L);
	out3=zeros(1,L);
	out4=zeros(1,L);
	out5=zeros(1,L);
	out6=zeros(1,L);
	out7=zeros(1,L);
	out8=zeros(1,L);
	out9=zeros(1,L);
	out10=zeros(1,L);
	out11=zeros(1,L);
	out12=zeros(1,L);
	out13=zeros(1,L);
	out14=zeros(1,L);
	out15=zeros(1,L);
	out16=zeros(1,L);

	signal1=zeros(1,L);
	signal2=zeros(1,L);
	signal3=zeros(1,L);
	signal4=zeros(1,L);
	signal5=zeros(1,L);
	signal6=zeros(1,L);
	signal7=zeros(1,L);
	signal8=zeros(1,L);
	signal9=zeros(1,L);
	signal10=zeros(1,L);
	signal11=zeros(1,L);
	signal12=zeros(1,L);
	signal13=zeros(1,L);
	signal14=zeros(1,L);
	signal15=zeros(1,L);
	signal16=zeros(1,L);

	yout=zeros(1,L);

	fname=sprintf("sound/out_%d_%d.p341",int32(xx*1000),int32(yy*1000));
	fpo=fopen(fname,'w');

	signal1=fread(fpi1,inf,'short');
	signal2=fread(fpi2,inf,'short');
	signal3=fread(fpi3,inf,'short');
	signal4=fread(fpi4,inf,'short');
	signal5=fread(fpi5,inf,'short');
	signal6=fread(fpi6,inf,'short');
	signal7=fread(fpi7,inf,'short');
	signal8=fread(fpi8,inf,'short');
	signal9=fread(fpi9,inf,'short');
	signal10=fread(fpi10,inf,'short');
	signal11=fread(fpi11,inf,'short');
	signal12=fread(fpi12,inf,'short');
	signal13=fread(fpi13,inf,'short');
	signal14=fread(fpi14,inf,'short');
	signal15=fread(fpi15,inf,'short');
	signal16=fread(fpi16,inf,'short');

	out1=fftfilt(g1,signal1);
	out2=fftfilt(g2,signal2);
	out3=fftfilt(g3,signal3);
	out4=fftfilt(g4,signal4);
	out5=fftfilt(g5,signal5);
	out6=fftfilt(g6,signal6);
	out7=fftfilt(g7,signal7);
	out8=fftfilt(g8,signal8);
    out9=fftfilt(g9,signal9);
	out10=fftfilt(g10,signal10);
	out11=fftfilt(g11,signal11);
	out12=fftfilt(g12,signal12);
	out13=fftfilt(g13,signal13);
	out14=fftfilt(g14,signal14);
	out15=fftfilt(g15,signal15);
	out16=fftfilt(g16,signal16);


	yout=(out1+out2+out3+out4+out5+out6+out7+out8+out9+out10+out11+out12+out13+out14+out15+out16);
	yout=int32(yout);

	fwrite(fpo,yout,'short');

	frewind(fpi1);
	frewind(fpi2);
	frewind(fpi3);
	frewind(fpi4);
	frewind(fpi5);
	frewind(fpi6);
	frewind(fpi7);
	frewind(fpi8);
	frewind(fpi9);
	frewind(fpi10);
	frewind(fpi11);
	frewind(fpi12);
	frewind(fpi13);
	frewind(fpi14);
	frewind(fpi15);
	frewind(fpi16);


	fclose(fpo);

endfor
#toc()
#printf("\n");
#printf("\n");

#tic()
#printf("抑圧評価点音圧の計算: ");
%%%%%抑圧評価点音圧の計算%%%%%
for kk=1:num_0

	xx=e_point_0(kk,1);
	yy=e_point_0(kk,2);

dis(1,1)=sqrt((len/2-spdis*7.5-xx)^2 + yy^2);
dis(1,2)=sqrt((len/2-spdis*6.5-xx)^2 + yy^2);
dis(1,3)=sqrt((len/2-spdis*5.5-xx)^2 + yy^2);
dis(1,4)=sqrt((len/2-spdis*4.5-xx)^2 + yy^2);
dis(1,5)=sqrt((len/2-spdis*3.5-xx)^2 + yy^2);
dis(1,6)=sqrt((len/2-spdis*2.5-xx)^2 + yy^2);
dis(1,7)=sqrt((len/2-spdis*1.5-xx)^2 + yy^2);
dis(1,8)=sqrt((len/2-spdis*0.5-xx)^2 + yy^2);

dis(1,9)=sqrt((len/2+spdis*0.5-xx)^2 + (len-yy)^2);
dis(1,10)=sqrt((len/2+spdis*1.5-xx)^2 + (len-yy)^2);
dis(1,11)=sqrt((len/2+spdis*2.5-xx)^2 + (len-yy)^2);
dis(1,12)=sqrt((len/2+spdis*3.5-xx)^2 + (len-yy)^2);
dis(1,13)=sqrt((len/2+spdis*4.5-xx)^2 + (len-yy)^2);
dis(1,14)=sqrt((len/2+spdis*5.5-xx)^2 + (len-yy)^2);
dis(1,15)=sqrt((len/2+spdis*6.5-xx)^2 + (len-yy)^2);
dis(1,16)=sqrt((len/2+spdis*7.5-xx)^2 + (len-yy)^2);


%伝達関数算出
g1=zeros(1,L);
g2=zeros(1,L);
g3=zeros(1,L);
g4=zeros(1,L);
g5=zeros(1,L);
g6=zeros(1,L);
g7=zeros(1,L);
g8=zeros(1,L);
g9=zeros(1,L);
g10=zeros(1,L);
g11=zeros(1,L);
g12=zeros(1,L);
g13=zeros(1,L);
g14=zeros(1,L);
g15=zeros(1,L);
g16=zeros(1,L);


freq=16000/mnw*[1:mnw/2];
for(n=1:256)#制御したい周波数帯域をnで分割

if freq(n)>=min_fs && freq(n) <=max_fs  #設定された周波数帯域内であれば

	#freq=(8000/256)*n;#周波数
	k=2*pi*freq(n)/c;#波数

  %{
		for m=1:spnum
			if(dis(1,m) < 1.0e-5)
			  for n=1:16
				gn(1,n) = 0;
			  endfor
			  break;
			else
			gn(1,m)=(1/(4*pi*dis(1,m)))*exp(-j*k*dis(1,m));#伝達関数（周波数ごと）
			endif
		endfor
%}
      m=1:spnum;
		  gn(1,m)=(1./(4*pi*dis(1,m))).*exp(-j*k*dis(1,m));#伝達関数

	g1(n)=gn(1,1);
	g2(n)=gn(1,2);
	g3(n)=gn(1,3);
	g4(n)=gn(1,4);
	g5(n)=gn(1,5);
	g6(n)=gn(1,6);
	g7(n)=gn(1,7);
	g8(n)=gn(1,8);
	g9(n)=gn(1,9);
	g10(n)=gn(1,10);
	g11(n)=gn(1,11);
	g12(n)=gn(1,12);
	g13(n)=gn(1,13);
	g14(n)=gn(1,14);
	g15(n)=gn(1,15);
	g16(n)=gn(1,16);


else

	g1(n)=0;
	g2(n)=0;
	g3(n)=0;
	g4(n)=0;
	g5(n)=0;
	g6(n)=0;
	g7(n)=0;
	g8(n)=0;
	g9(n)=0;
	g10(n)=0;
	g11(n)=0;
	g12(n)=0;
	g13(n)=0;
	g14(n)=0;
	g15(n)=0;
	g16(n)=0;

endif


endfor

jj=1:L;

  g1=real(ifft([g1 conj(g1(257-jj))]));
  g2=real(ifft([g2 conj(g2(257-jj))]));
  g3=real(ifft([g3 conj(g3(257-jj))]));
  g4=real(ifft([g4 conj(g4(257-jj))]));
  g5=real(ifft([g5 conj(g5(257-jj))]));
  g6=real(ifft([g6 conj(g6(257-jj))]));
  g7=real(ifft([g7 conj(g7(257-jj))]));
  g8=real(ifft([g8 conj(g8(257-jj))]));
  g9=real(ifft([g9 conj(g9(257-jj))]));
  g10=real(ifft([g10 conj(g10(257-jj))]));
  g11=real(ifft([g11 conj(g11(257-jj))]));
  g12=real(ifft([g12 conj(g12(257-jj))]));
  g13=real(ifft([g13 conj(g13(257-jj))]));
  g14=real(ifft([g14 conj(g14(257-jj))]));
  g15=real(ifft([g15 conj(g15(257-jj))]));
  g16=real(ifft([g16 conj(g16(257-jj))]));


	x1buf=zeros(1,mnw);
	x2buf=zeros(1,mnw);
	x3buf=zeros(1,mnw);
	x4buf=zeros(1,mnw);
	x5buf=zeros(1,mnw);
	x6buf=zeros(1,mnw);
	x7buf=zeros(1,mnw);
	x8buf=zeros(1,mnw);
	x9buf=zeros(1,mnw);
	x10buf=zeros(1,mnw);
	x11buf=zeros(1,mnw);
	x12buf=zeros(1,mnw);
	x13buf=zeros(1,mnw);
	x14buf=zeros(1,mnw);
	x15buf=zeros(1,mnw);
	x16buf=zeros(1,mnw);

	y1buf=zeros(1,mnw);
	y2buf=zeros(1,mnw);
	y3buf=zeros(1,mnw);
	y4buf=zeros(1,mnw);
	y5buf=zeros(1,mnw);
	y6buf=zeros(1,mnw);
	y7buf=zeros(1,mnw);
	y8buf=zeros(1,mnw);
	y9buf=zeros(1,mnw);
	y10buf=zeros(1,mnw);
	y11buf=zeros(1,mnw);
	y12buf=zeros(1,mnw);
	y13buf=zeros(1,mnw);
	y14buf=zeros(1,mnw);
	y15buf=zeros(1,mnw);
	y16buf=zeros(1,mnw);


	z1buf=zeros(1,mnw);
	z2buf=zeros(1,mnw);
	z3buf=zeros(1,mnw);
	z4buf=zeros(1,mnw);
	z5buf=zeros(1,mnw);
	z6buf=zeros(1,mnw);
	z7buf=zeros(1,mnw);
	z8buf=zeros(1,mnw);
	z9buf=zeros(1,mnw);
	z10buf=zeros(1,mnw);
	z11buf=zeros(1,mnw);
	z12buf=zeros(1,mnw);
	z13buf=zeros(1,mnw);
	z14buf=zeros(1,mnw);
	z15buf=zeros(1,mnw);
	z16buf=zeros(1,mnw);


	out1=zeros(1,L);
	out2=zeros(1,L);
	out3=zeros(1,L);
	out4=zeros(1,L);
	out5=zeros(1,L);
	out6=zeros(1,L);
	out7=zeros(1,L);
	out8=zeros(1,L);
	out9=zeros(1,L);
	out10=zeros(1,L);
	out11=zeros(1,L);
	out12=zeros(1,L);
	out13=zeros(1,L);
	out14=zeros(1,L);
	out15=zeros(1,L);
	out16=zeros(1,L);


	signal1=zeros(1,L);
	signal2=zeros(1,L);
	signal3=zeros(1,L);
	signal4=zeros(1,L);
	signal5=zeros(1,L);
	signal6=zeros(1,L);
	signal7=zeros(1,L);
	signal8=zeros(1,L);
	signal9=zeros(1,L);
	signal10=zeros(1,L);
	signal11=zeros(1,L);
	signal12=zeros(1,L);
	signal13=zeros(1,L);
	signal14=zeros(1,L);
	signal15=zeros(1,L);
	signal16=zeros(1,L);


	yout=zeros(1,L);

	fname=sprintf("sound/out_%d_%d.p341",int32(xx*1000),int32(yy*1000));
	fpo=fopen(fname,'w');

	signal1=fread(fpi1,inf,'short');
	signal2=fread(fpi2,inf,'short');
	signal3=fread(fpi3,inf,'short');
	signal4=fread(fpi4,inf,'short');
	signal5=fread(fpi5,inf,'short');
	signal6=fread(fpi6,inf,'short');
	signal7=fread(fpi7,inf,'short');
	signal8=fread(fpi8,inf,'short');
	signal9=fread(fpi9,inf,'short');
	signal10=fread(fpi10,inf,'short');
	signal11=fread(fpi11,inf,'short');
	signal12=fread(fpi12,inf,'short');
	signal13=fread(fpi13,inf,'short');
	signal14=fread(fpi14,inf,'short');
	signal15=fread(fpi15,inf,'short');
	signal16=fread(fpi16,inf,'short');


	out1=fftfilt(g1,signal1);
	out2=fftfilt(g2,signal2);
	out3=fftfilt(g3,signal3);
	out4=fftfilt(g4,signal4);
	out5=fftfilt(g5,signal5);
	out6=fftfilt(g6,signal6);
	out7=fftfilt(g7,signal7);
	out8=fftfilt(g8,signal8);
    out9=fftfilt(g9,signal9);
	out10=fftfilt(g10,signal10);
	out11=fftfilt(g11,signal11);
	out12=fftfilt(g12,signal12);
	out13=fftfilt(g13,signal13);
	out14=fftfilt(g14,signal14);
	out15=fftfilt(g15,signal15);
	out16=fftfilt(g16,signal16);


	yout=(out1+out2+out3+out4+out5+out6+out7+out8+out9+out10+out11+out12+out13+out14+out15+out16);
	yout=int32(yout);

	fwrite(fpo,yout,'short');

	frewind(fpi1);
	frewind(fpi2);
	frewind(fpi3);
	frewind(fpi4);
	frewind(fpi5);
	frewind(fpi6);
	frewind(fpi7);
	frewind(fpi8);
	frewind(fpi9);
	frewind(fpi10);
	frewind(fpi11);
	frewind(fpi12);
	frewind(fpi13);
	frewind(fpi14);
	frewind(fpi15);
	frewind(fpi16);


	fclose(fpo);

endfor
#toc()
#printf("\n");
#printf("\n");



	fclose(fpi1);
	fclose(fpi2);
	fclose(fpi3);
	fclose(fpi4);
	fclose(fpi5);
	fclose(fpi6);
	fclose(fpi7);
	fclose(fpi8);
	fclose(fpi9);
	fclose(fpi10);
	fclose(fpi11);
	fclose(fpi12);
	fclose(fpi13);
	fclose(fpi14);
	fclose(fpi15);
	fclose(fpi16);


r_sum=0;
s_sum=0;

#tic()
#printf("calculating SPL & fitness costs ");
for ii=1:num_1

	xx=e_point_1(ii,1);
	yy=e_point_1(ii,2);

	fname=sprintf("sound/out_%d_%d.p341",int32(xx*1000),int32(yy*1000));
	fpi2=fopen(fname,'r');
	signal2=fread(fpi2,inf,'short');
	xbuf = double(signal2);
	x2buf=xbuf'*xbuf;
	r_sum+=10*log10(x2buf);
	fclose(fpi2);

endfor

ave_r=r_sum/num_1;


for jj=1:num_0

	xx=e_point_0(jj,1);
	yy=e_point_0(jj,2);

	fname=sprintf("sound/out_%d_%d.p341",int32(xx*1000),int32(yy*1000));
	fpi2=fopen(fname,'r');
	signal2=fread(fpi2,inf,'short');
	xbuf = double(signal2);
	x2buf=xbuf'*xbuf;
	s_sum+=10*log10(x2buf);
	fclose(fpi2);

endfor

ave_s=s_sum/num_0;
semisin=ave_r/ave_s;  #再生エリアと抑圧エリアとの平均音圧差
#toc()
#printf("\n");
#printf("\n");

#	fclose("all");
#	freport()
