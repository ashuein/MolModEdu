# The idea is to calculate RMSF of arginines inserted in helices
# resname ARG and segname CHA CHE and resid 83 63
# resname ARG and segname CHB CHF and resid 45
# resname ARG and segname CHC CHG and resid 42 77
# resname ARG and segname CHD CHH and resid 30

#(resname ARG and segname CHA CHE and resid 49)

mol load psf ../analysis_data/only_nucl_init.psf

mol addfile ../analysis_data/only_nucl_init.pdb waitfor all
mol addfile ../analysis_data/md_nucl.dcd step 1 waitfor all
# mol addfile ../analysis_data/only_nucl_average.pdb waitfor all



set all [atomselect top "all"]

set rmsf [measure rmsf $all first 2500 last 10000]
$all frame 10001
$all set beta $rmsf
# $all writepdb ../analysis_data/arg_rmsf.pdb

#let's do some file output
set args [list "segname CHE and resid 49" "segname CHC and resid 77" "segname CHD and resid 30" "segname CHC and resid 42" "segname CHA and resid 83" "segname CHA and resid 63" "segname CHB and resid 45" "segname CHF and resid 45" "segname CHE and resid 63" "segname CHE and resid 83" "segname CHG and resid 42" "segname CHH and resid 30" "segname CHG and resid 77" "segname CHA and resid 49"]
set args_SHL [list -6.5 -5.5 -4.5 -3.5 -2.5 -1.5 -0.5 0.5 1.5 2.5 3.5 4.5 5.5 6.5]


set outfile [open ../analysis_data/rmsf_arg.dat w]
puts $outfile "RMSF of key arginines in nucleosome"
puts $outfile "Generated by VMD rmsf"
puts $outfile "SHL of ARG"
puts $outfile "RMSF, A"



puts $outfile "SHL\tARG_sidechain_average_RMSF"


foreach seldef  $args  shl  $args_SHL {
# set sel [atomselect top "segname $seg and (not backbone) and resid '$i' and noh"]
set sel [atomselect top "$seldef and (not backbone)"]
if {[$sel num] == 0} { set mean 0
} else {
set  beta [$sel get beta]
set bl [llength $beta]
set mean 0
for {set j 0} { $j<$bl } { incr j } {
set mean [expr $mean + [lindex $beta $j]]
}
set mean [expr $mean / $bl]
}

set ds "$shl"
append ds "\t$mean"
puts $outfile $ds

}

close $outfile 

exec python2.7 myplot.py ../analysis_data/rmsf_arg.dat --x_r -7 7 --legend "upper right" --bar 1


exit


