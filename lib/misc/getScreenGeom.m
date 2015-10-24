function render = getScreenGeom(w)
  % get screen geometry, mostly pix/cm
  render.cx = render.wsize(3)/2; %center x
  render.cy = render.wsize(4)/2; %center y
  [render.screenWidthMm,render.screenHeightMm]=Screen('DisplaySize',w);
  render.screenRect=Screen('Rect',w,1);
  render.screenWidthPix=RectWidth(screenRect);
  render.pixPerCm=render.screenWidthPix/(0.1*render.screenWidthMm);
  render.resolution=Screen('Resolution',w);
end
