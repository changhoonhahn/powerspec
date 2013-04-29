pro red_hist, fname

dir="/mount/chichipio2/hahn/data/manera_mock/"

readcol,dir+fname,ra,dec,az,ipoly,wb,wcp,wred,redtru,flag,m1,m2

azhist=histogram(az,binsize=0.1,min=0.0,max=1.0)

redtruhist=histogram(az,binsize=0.1,min=0.0,max=1.0)
