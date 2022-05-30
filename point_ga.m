function [value,generation]=point_ga(cnum,snum,tnum)

trynum=tnum;

cpoint=cnum;    #抑圧制御点数
set_num=snum;  #初期個体数（偶数のみ）

min_fs=100;   #周波数帯域
max_fs=7000;  #周波数帯域
G=cell(set_num,1); #親の箱
C=cell(set_num,1);       #子の箱
bix=-100;        #適合度の最大値
count=0;      #終了条件のためのカウント変数

mkdir("log");

tic()
printf("initial G:");
############初期集団作成#####################
g=zeros(cpoint,3);		#ｘ座標、y座標、重み係数
ii=-0.5:0.02:0.5;   #抑圧制御点のx軸範囲
xx_ini(:,1)=ii;
ii=1:0.02:2;      #抑圧制御点のy軸範囲
yy_ini(:,1)=ii;
x_size=length(xx_ini);
y_size=length(yy_ini);

for ii=1:set_num
g(:,1)=xx_ini(floor(rand(cpoint,1)*x_size)+1,1);   #制御点x軸設定
g(:,2)=yy_ini(floor(rand(cpoint,1)*y_size)+1,1);   #制御点y軸設定
#g(:,3)=randi(10,1,cpoint);  #重み係数0-10まで
g(:,3)=randi(1,1,cpoint); #重み係数1固定
G{ii}=g;
endfor
toc()
printf("\n");

gnum=1; #世代数の変数
semisin=0;

################第一世代評価###################

for cnt=1:set_num
if gnum==1
	xx=G{cnt}(:,[1]);       #x軸
	yy=G{cnt}(:,[2]);       #y軸
	weight=G{cnt}(:,[3]);   #重み係数
	tic()
	printf("MPCM %d: ",cnt );
	mpcm(xx,yy,min_fs,max_fs,cpoint,weight);    #多点制御法フィルタ関数
	toc()

	tic()	
	semisin=hyouka_zone(min_fs,max_fs);       #評価関数
	printf("hyouka %d: ",cnt);
	toc()
	printf("\n");

	semisin1_db(cnt)=semisin;           #評価関数からの返り値を収納
	semisin1(cnt)=semisin;
endif
endfor



[x, ix] = max (semisin1);   #その世代の最大適合度を保存
max_ev=semisin1(ix);
max_db=semisin1_db(ix);

################ループ開始?##################
while(1)
gnum;

#save semisin1.dat semisin1 semisin1_db
###############ルーレット選択##################
tic()
printf("opt_roulette: ");
newgene=opt_roulette(semisin1,set_num);       #semisin1の値に応じてルーレット選択
toc()
printf("\n");
printf("\n");

###############交叉と突然変異　##################
tic()
printf("corssover & mutation for 40 chromosome (20 pairs): ");
semisin1_temp=zeros(1,set_num);
semisin1_db_temp=zeros(1,set_num);

for jj=1:2:set_num
	c1=G{newgene(jj)};
	c2=G{newgene(jj+1)};
	prob1=randperm(10);      #交叉確率設定の変数
	prob2=randperm(10);    #突然変異設定の変数

	p1=6;	#Crossover Probability/100
	p2=4;	#Mutation Probability/100

#	prob_temp(jj,1)=prob1(1);
#	prob_temp(jj,2)=prob2(1);

	if prob1(1)>p1 && prob2(1)>p2 #Without any Crossover or Mutation
		semisin1_temp(jj)=semisin1(newgene(jj));
		semisin1_temp(jj+1)=semisin1(newgene(jj+1));

		semisin1_db_temp(jj)=semisin1_db(newgene(jj));
		semisin1_db_temp(jj+1)=semisin1_db(newgene(jj+1));
	endif

	if prob1(1)<=p1  #交叉確率5分の3=0.6
	###############一様交叉##################
		for ii=1:cpoint
			mask(ii)=floor(rand*2);    #マスク値の作成,1は交叉、０は一様、確率５０％
			if mask(ii)==1
				c1_c(ii,:)=c2(ii,:);
				c2_c(ii,:)=c1(ii,:);
			else
				c1_c(ii,:)=c1(ii,:);
				c2_c(ii,:)=c2(ii,:);
			endif
		endfor
		C{jj} = c1_c;
		C{jj+1} = c2_c;
	else				#prob１は４，５にの場合、交叉しない（確率４０％）
		C{jj} = c1;
		C{jj+1} = c2;
	endif
	#########################################



	###############突然変異(2個体）##################
	if  prob2(1)<=p2     #突然変異確率4/10
	    h1=C{jj};
		h2=C{jj+1};

		b=randperm (cpoint);  #1つ目の個体(h1)の突然変異する列の決定
		#新たなxy軸重み係数
		xx=xx_ini(floor(rand(1,1)*x_size)+1,1);
		yy=yy_ini(floor(rand(1,1)*y_size)+1,1);
		#weight1=randi(10,1,1);
		weight1=randi(1,1,1);

		#入れ替え
		h1(b(1),1)=xx;
		h1(b(1),2)=yy;
		h1(b(1),3)=weight1;


		b=randperm (cpoint);  #h2の突然変異する行の決定
		xx=xx_ini(floor(rand(1,1)*x_size)+1,1);
		yy=yy_ini(floor(rand(1,1)*y_size)+1,1);
		#weight1=randi(10,1,1);
		weight1=randi(1,1,1);

		h2(b(1),1)=xx;
		h2(b(1),2)=yy;
		h2(b(1),3)=weight1;

		C{jj} = h1;
		C{jj+1} = h2;
	endif
endfor
toc()
printf("\n");
printf("\n");
#save semisin_temp.dat prob_temp semisin1_temp semisin1_db_temp

################次世代評価###################
%{
tic()
for cnt=1:set_num
#tic()
	if semisin1_temp(cnt)!=0
		semisin1(cnt)=semisin1_temp(cnt);
		semisin1_db(cnt)=semisin1_db_temp(cnt);
	else
		xx=C{cnt}(:,[1]);
		yy=C{cnt}(:,[2]);
	  	weight=C{cnt}(:,[3]);

		mpcm(xx,yy,min_fs,max_fs,cpoint,weight);
		semisin=hyouka_zone(min_fs,max_fs);

		semisin1_db(cnt)=semisin;
		semisin1(cnt)=semisin;
	endif
#toc()
endfor
toc()
#save new_semisin.dat semisin1 semisin1_db
%}
[x, ix] = max (semisin1);   #その世代の最大適合度を保存
max_ev=[max_ev,semisin1(ix)];
max_db=[max_db,semisin1_db(ix)];

if x > bix
max_p=C{ix};

bix=x;      #適合度の最大値
count=0;    #最大値が更新されたため、終了のためのカウント変数を0に
endif


maximum=max (semisin1)   #その世代での適合度最大値
avg=mean(semisin1)       #平均値
med=median(semisin1)     #中央値

g_maximum(gnum)=maximum;
g_avg(gnum)=avg;
g_med(gnum)=med;
g_gnum(gnum)=gnum;

G=C;
#ログにファイルに変数出力
cd log
fname=sprintf("%d_G_%d.txt",trynum,gnum);
eval(['save ', fname, ' G ',' g_maximum ',' g_avg ',' g_med '])
cd ..

count
#if  count==15 || maximum==med #終了条件
if gnum==1
 break
endif


gnum++;
printf("\n");
#freport()
fclose("all");

count=count+1;
endwhile

value=maximum;
generation=gnum;

#終了した後の出力
fname=sprintf("%d_G_%d.txt",trynum,gnum+1);
eval(['save ', fname, ' G ',' maximum ',' avg ',' med ',' ix '])

fname=sprintf("%d_G_%d_result.txt",trynum,gnum+1);
eval(['save ', fname, ' max_ev ',' max_db ',' max_p '])

#xx=max_p(:,[1]);
#yy=max_p(:,[2]);
#weight=max_p(:,[3]);
#mpcm(xx,yy,min_fs,max_fs,cpoint,weight);

endfunction
