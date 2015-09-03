function imagelabel(imdat)
imdat(isnan(imdat))=0;
[x,y,v] = find(imdat);
imagesc(imdat);
text(y,x,num2str(v,2));
colorbar;
end