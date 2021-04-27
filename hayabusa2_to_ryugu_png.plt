# You need to get the below txt file before running this program.
# https://www.hayabusa2.jaxa.jp/topics/20180228/data/Trajectory_20180226.txt

# -------------------- Setting ------------------- #
reset
set terminal png size 1280, 720 enhanced
set key box Left left font 'TimesNewRoman, 17' spacing 1.5 width 1 at screen 0.35, 0.13
data_txt = "Trajectory_20180226.txt"

# Calculate UTC using UNIX time
date_0 = "12/03/2014 05:00"								# First date
unix_time = strptime("%m/%d/%Y %H:%M", date_0)			# UNIX time [s]
Date(unix_time) = strftime("%m/%d/%Y %H:%M", unix_time)	# unix_time convert date (UTC)
Time(i) = sprintf("%d [day]", i)  # Total flight time

set label 1 sprintf("(c) JAXA") right font 'TimesNewRoman, 23' at screen 0.96, 0.05
set label 2 sprintf("au : astronomical unit\n       1 au = 149597870700 m") \
    left font 'TimesNewRoman, 17' at screen 0.04, 0.08

# -------------------- Update and draw ------------------- #
do for[i=0:1832]{
    set output sprintf("png/img_%05d.png", i)

	# Date and total flight time (86400 = 24*60*60 [s/day])
    set label 3 sprintf("%s      %s", Date(unix_time + 86400*i), Time(i)) \
        left font 'TimesNewRoman, 20' at screen 0.37, 0.93

	set multiplot
	# Left side: Hayabusa2 orbit, Earth orbit, and Ryugu orbit
        set origin 0.01, 0.04
        set size 0.60, 0.60*1280/720
		set view 65, 300, 1, 1				# set point of view
		set zeroaxis
		set ticslevel 0
		set xlabel "{/TimesNewRoman:Italic=18 x} [au]" font 'TimesNewRoman, 18' offset 0, -1
		set ylabel "{/TimesNewRoman:Italic=18 y} [au]" font 'TimesNewRoman, 18' offset 0, -1.3
		set zlabel "{/TimesNewRoman:Italic=18 z} [au]" font 'TimesNewRoman, 18'
		set xtics offset 0.8, -0.7 font 'TimesNewRoman, 15'
		set ytics offset -1.5, -1 font 'TimesNewRoman, 15'
		set ztics font 'TimesNewRoman, 15'

	    # Plot position of Hayabusa2, Earth, and Ryugu
		splot[-1.5:1.5][-1.5:1.5][-0.15:0.15] \
		    data_txt every ::0::0+i using 3:4:5 w l lw 1.5 lc rgb "orange" notitle ,\
            data_txt every ::0+i::0+i using 3:4:5 w p pt 7 ps 1.5 lc rgb "orange" title "Hayabusa2",\
            data_txt every ::0::0+i using 6:7:8 w l lw 1.5 lc rgb "royalblue" notitle,\
            data_txt every ::0+i::0+i using 6:7:8 w p pt 7 ps 2 lc rgb "royalblue" title "Earth",\
            data_txt every ::0::0+i using 9:10:11 w l lw 1.5 lc rgb "grey" notitle,\
            data_txt every ::0+i::0+i using 9:10:11 w p pt 7 ps 1.5 lc rgb "grey50" title "Ryugu (1999 JU3)"

    # Right side: Distance between Hayabusa2 and Ryugu
        set pm3d map
        set origin 0.58, 0.07
        set size 0.46, 0.46*1280/720*1.1
        set xlabel "Total fligh time [day]" font 'TimesNewRoman, 18' offset 0, 0.2
        set ylabel "Distance between Hayabusa2 and Ryugu [�~10^4km]" font 'TimesNewRoman, 18' offset -1, 0
        unset zl
		set xtics offset 0, 0 font 'TimesNewRoman, 15'
		set ytics offset 0, 0 font 'TimesNewRoman, 15'

        splot[0:2000][0:40000][-0.15:0.15] \
            data_txt every ::0::0+i using 2:14:5 w l lw 1.5 lc rgb "black" notitle

    unset multiplot
}

set out