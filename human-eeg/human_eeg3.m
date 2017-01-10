tmin = 10;
tmax = 40;

dt = .5;
ch_indx = 1:10;

first_time = true;

f1 = incr_fig_indx;
f2 = incr_fig_indx;

for time= min(t) + (tmin:dt:tmax)
  figure(f1);
  clf
  
  [~, indx] = min(abs(t - time));
  nearest_time = t(indx);
  
  figure(f1)
  clf
  plot_hand(hand, indx)
  title(sprintf('t = %g s', nearest_time))
  
  if first_time
    first_time = false;
    xl = xlim;
    yl = ylim;
    zl = zlim;
  else
    xl_ = xlim;
    yl_ = ylim;
    zl_ = zlim;
    
    xl(1) = min(xl(1), xl_(1));
    xl(2) = max(xl(2), xl_(2));
    yl(1) = min(yl(1), yl_(1));
    yl(2) = max(yl(2), yl_(2));
    zl(1) = min(zl(1), zl_(1));
    zl(2) = max(zl(2), zl_(2));
    
    xlim(xl);
    ylim(yl);
    zlim(zl);
  end
  
  figure(f2)
  clf
  hold on
  y = 0;
  ind = t>=tmin+t(1) & t<=tmax+t(1);
  
  for i=1:1:length(ch_indx)%size(eeg,2)
    eegch = ch_indx(i);
    y = eeg(ind,eegch) - min(eeg(ind,eegch)) + max(y) + 2*(max(y)-min(y));
    plot(t(ind), y);
  end
  
  xlim(t(1) + [tmin tmax])
  ylim([0 max(y)])
  plot(nearest_time*[1 1], ylim)
  
  
  pause%(.5)
  
end


