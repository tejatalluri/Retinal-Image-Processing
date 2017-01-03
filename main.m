clc;
clear all;
close all;
run_function;
warning off all;

[Fn Pn]=uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...'*.*','All Files'},'mytitle',...'Input File Location');

Cn=strcat(Pn,Fn);
R=imread(Cn);
figure,imshow(R)
I=R;
G=R(:,:,2);
figure,imshow(G)

IM2=imcomplement(G);
figure,imshow(IM2)

J=adapthisteq(IM2)
figure,imshow(J)

se=strel('ball'15,5);
J1=imtophat(J,se);
figure,imshow(J1)

level=graythresh(J1);
BW=im2bw(J1,level);
figure,imshow(BW)

K=medfilt2(BW,[3 3]);
figure,imshow(K)

[L,N]=bwlabel(K);

stats=regionprops(L,'area','perimeter');

areas=[stats.Area];

too_small=find(areas<500);
img_mask=L;
for i=1:length(too_small)
    img_mask(L==too_small(i))=0;
end

figure,
subplot(1,2,1),imshow(R)
subplot(1,2,2),imshow(img_mask)

%%

Last=im2bw(img_mask);

Result=zeros(size(I));

[m n d]=size(Result);

for x=1:m
    for y+1:n
        if Last(x,y)==1
            Result(x,y,1)=0;
            Result(x,y,2)=255;
            Result(x,y,3)=0;
        else
            Result(x,y,:)=I(x,y,:);
        end
    end
end
img1=rgb2gray(I);

a=img1;
[m,n]=size(a);
a=im2double(a);
exp_a=(a*a')/256;
k=0;
sum=0;
for i+1:m
    k=k+1;
    for j=1:n
        sum=sum+a(k,j);
        s(i,l)=sum;
    end
end
xbar=s/n;
cov_a=exp_a-((xbar*xbar'));
[v,d]=eig(cov_a);

y=v*a;

xa=v'y;

A=adapthisteq(xa);

BB=inpaint(A,4);

sel=strel('disk',5);
erodedBW=imerode(BB,sel);

se3=strel('disk',15);
bw2=imdilate(erodeBW,se3);

BB=bw2;

[I4,gradmag,Io,Iobr]=watershed_od(BB);

BB=I4;

figure,
maximize
subplot(1,3,1)imshow(I),title('Input Image')

[r,c,rad]=circlefinder(BB,[],[],[],[],I);
