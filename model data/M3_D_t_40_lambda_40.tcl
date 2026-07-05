
wipe
model BasicBuilder -ndm 2 -ndf 3

set Datadir M3_Model_B
file mkdir $Datadir;

#source Get_Rendering.tcl;

puts "directory defined"

# nodes for 8 element
node	1	0		0	0
node	5	965.0	2	0
node	9	1930.0	0	0

puts "node defined"

## Mass
mass 9 1.0 0.0 0.0

puts "mass defined"
                                                  
#Boundary Conditions
fix 1 1 1 0
fix 9 0 1 0

puts "boundary condition defined"

## Material SLModel--------------------------------------------------------------------
set	mat_Tag	2
set	fy0	255.00
set	E0	205000.00
set	b	0.0050
set	eps_buck	0.016
set	b1	-0.037
set b2 0.0025
set	lambda	1.05 ; #367 734 881
set	c	1.00
set	sig_res	154.45


#uniaxialMaterial Steel02 2 $fy0 $E0 $b 24 0.925 0.25 0.02 1.0 0.02 1.0
#Steel05LB $tag $Fy $E0 $b $eps_buck $b1 $lambda $c $sig_res <$R0 $cR1 $cR2> <$a1 $a2 $a3 $a4> <$sigInit>
uniaxialMaterial Steel05LB $mat_Tag $fy0 $E0 $b $eps_buck $b1 $b2 $lambda $c $sig_res 24 0.925 0.25 0.02 1.0 0.02 1.0 


## Pipe Section
#patch circ $matTag $numSubdivCirc $numSubdivRad $yCenter $zCenter $intRad $extRad $startAng $endAng
set SecTagTorsion 200;
set Ubig 1.0e10;  # A large number
uniaxialMaterial Elastic $SecTagTorsion $Ubig

###Circular section------------------
set rext 69.9
set rint 66.4

##Plastic hinge length
set lp1 [expr {0.001 * 2 * $rext}]
set lp2 [expr {0.4 * 2 * $rext}]

# #-------Elastic section-----------------------
# section fiberSec 1 -torsion $SecTagTorsion {
    # patch circ 1 12 4 0.0 0.0 $rint $rext 0.0 360.0 
               # }

#-------------Plastic hinge section---------------------
section fiberSec 2 -torsion $SecTagTorsion {
    patch circ 2 12 4 0.0 0.0 $rint $rext 0.0 360.0 
                }

puts "material defined"

## Transformation
geomTransf Corotational 1

##Model B-----------------------------------------------------------------
#element forceBeamColumn $eleTag $iNode $jNode $transfTag "HingeRadau $secTagI $LpI $secTagJ $LpJ $secTagInterior" <-mass $massDens> <-iter $maxIters $tol>
set tol_e 10.0e-10
element forceBeamColumn 1 1 5 1 "HingeRadau 2 $lp1 2 $lp2 2" -iter 100 $tol_e 
element forceBeamColumn 2 5 9 1 "HingeRadau 2 $lp2 2 $lp1 2" -iter 100 $tol_e 

puts "elements defined"

## Recorder
recorder Node -file $Datadir/LoadDisp.txt -time -node 9 -dof 1 disp;
#recorder Element -file $Datadir/ele_sec_def.txt -time -ele 2 4 section deformation
#recorder Element -file $Datadir/ele_sec_def.txt -time -ele 2 3 4 5 section deformation
#recorder Element -file $Datadir/ele_sec_def.txt -time -ele 2 3 4 5 6 7 8 9 section deformation
#recorder Element -file $Datadir/ele_sec_def.txt -time -ele 2 3 4 5 6 7 8 9 10 11 section deformation
#recorder Element -file $Datadir/ele_sec_def.txt -time -ele 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 section deformation  
puts "recorder defined"

## Apply the nodal Load
pattern Plain 1 Linear { load 9 1.0 0.0 0.0 }

puts "load defined"

## Static Analysis parameters
test EnergyIncr 5.0e-1 2000 5
algorithm KrylovNewton
system UmfPack
numberer RCM
constraints Plain
analysis Static

#increment 0.01
integrator	DisplacementControl	9	1	-0.0100	;	analysis	Static;	analyze	481	;	puts	"	1	"
integrator	DisplacementControl	9	1	0.0100	;	analysis	Static;	analyze	969	;	puts	"	2	"
integrator	DisplacementControl	9	1	-0.0100	;	analysis	Static;	analyze	1466	;	puts	"	3	"
integrator	DisplacementControl	9	1	0.0100	;	analysis	Static;	analyze	1946	;	puts	"	4	"
integrator	DisplacementControl	9	1	-0.0100	;	analysis	Static;	analyze	2419	;	puts	"	5	"
integrator	DisplacementControl	9	1	0.0100	;	analysis	Static;	analyze	2896	;	puts	"	6	"
integrator	DisplacementControl	9	1	-0.0100	;	analysis	Static;	analyze	3367	;	puts	"	7	"
integrator	DisplacementControl	9	1	0.0100	;	analysis	Static;	analyze	3843	;	puts	"	8	"
integrator	DisplacementControl	9	1	-0.0100	;	analysis	Static;	analyze	4366	;	puts	"	9	"
integrator	DisplacementControl	9	1	0.0100	;	analysis	Static;	analyze	4780	;	puts	"	10	"


# integrator	DisplacementControl	9	1	-0.0050	;	analysis	Static;	analyze	962	;	puts	"	1	"
# integrator	DisplacementControl	9	1	0.0050	;	analysis	Static;	analyze	1939	;	puts	"	2	"
# integrator	DisplacementControl	9	1	-0.0050	;	analysis	Static;	analyze	2931	;	puts	"	3	"
# integrator	DisplacementControl	9	1	0.0050	;	analysis	Static;	analyze	3892	;	puts	"	4	"
# integrator	DisplacementControl	9	1	-0.0050	;	analysis	Static;	analyze	4839	;	puts	"	5	"
# integrator	DisplacementControl	9	1	0.0050	;	analysis	Static;	analyze	5791	;	puts	"	6	"
# integrator	DisplacementControl	9	1	-0.0050	;	analysis	Static;	analyze	6735	;	puts	"	7	"
# integrator	DisplacementControl	9	1	0.0050	;	analysis	Static;	analyze	7685	;	puts	"	8	"
# integrator	DisplacementControl	9	1	-0.0050	;	analysis	Static;	analyze	8733	;	puts	"	9	"
# integrator	DisplacementControl	9	1	0.0050	;	analysis	Static;	analyze	9561	;	puts	"	10	"


puts "analysis done"

wipe
