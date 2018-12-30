function tFiltered = filtTriggerTimes(t, tmin, tmax)

tFiltered = t(t>=tmin & t<=tmax);

end