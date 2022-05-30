clear all

cnum=36;  %抑圧点数
snum=30;  %初期個体数
fpoo=fopen("result.txt",'w');

f=0.0;
g=0.0;

t=0;%runs number
while(t<10)
t++;

  [fitness,gnum]=point_ga(cnum,snum,t)
  f=num2str(fitness)
  g=num2str(gnum)

 fpoo=fopen("result.txt",'a');
 fprintf(fpoo,"%s\t%s\n",f,g);
 fclose(fpoo);

endwhile
