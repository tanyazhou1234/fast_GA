function newgene = opt_roulette(semisin1,set_num)

f=semisin1;    

ii=1:set_num;
f_d(ii)=f(ii)-(mean(f)-1.5*std(f,1)); #シグマスケーリング

#シグマスケーリングを行った後、適合度が0以下のものは0に
for ii=1:set_num
if f_d(ii)<0
  f_d(ii)=0;
endif
endfor


f_avg=mean(f_d(find(f_d)));   #0以外の適合度の平均
f_max=max(f_d);               #適合度の最大
A=[f_avg 1 ; f_max 1];
B=[f_avg ; 2.0*f_avg];
f_cal=(inv(A)*B)';            #係数a,bの算出、C=2.0

f_dd=zeros(1,ii);
jj=find(f_d);                     
f_dd(jj)=f_cal(1)*f_d(jj)+f_cal(2);   #線形スケーリング

#線形スケーリングを行った後、適合度が0以下のものは0に
for ii=1:set_num
if f_dd(ii)<0
  f_dd(ii)=0;
endif
endfor

#（ルーレット選択プログラム等で検索するのがおすすめ）
#各適合度/適合度の合計で求まる選択確率を作成
#各選択確率の合計は1となる
sum_semisin=sum(f_dd);              
ii=1:set_num;
roulette(ii)=f_dd(ii)/sum_semisin;

#出力用％に直すため*100
roulette100=roulette*100;
print_prob(:,1)=f;
print_prob(:,2)=roulette100;
print_prob'; #適合度とルーレット確率の出力



for jj=1:set_num    #個体数個選択される
break_num=rand(1);  #ランダムな0~1の値を決定
dsum=0;
#各個体の選択確率をbreak_numまで足していき、超えた個体が選択される
for ii=1:set_num
  dsum+=roulette(ii);
  if dsum>break_num 
    newgene(jj)=ii;
    break;
  endif 
endfor
endfor







