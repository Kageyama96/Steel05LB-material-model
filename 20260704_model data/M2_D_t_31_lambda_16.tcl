# Unit: N, mm, sec
# Model to validate; 
wipe
model basic -ndm 2 -ndf 3
set Datadir M2_Model_B;      # set up name of data directory
file mkdir $Datadir;

#source Get_Rendering.tcl;
puts "directory defined"
#-------------------------------------------------------
#create nodes

#--Model B----------------------------------------------
node	1	0.0	0.0	0.0
node	5	770.0	1.5	0.0
node	9	1540.0	0.0	0.0

puts "node defined"

## Mass
mass 9 1.0 0.0 0.0

puts "mass defined"

#fix node
# nodeTag DX DY RZ
fix 1 1 1 1
fix 9 0 1 1
puts "boundary condition defined"
#-----------------------------------------------------
# Fracture Parameters - # karamachi and Lignos
#set E0 0.095;
#set m -0.50;
#define the brace material     
## Parameters are provided by karamanci
#uniaxialMaterial Fatigue 101 1 -E0 $E0 -m $m; 
##-----------------------------------------------------------------------

#Steel05LB#----------------------------------------------------------
set	mat_Tag	2
set	fy0	360.00
set	E0	205000.00
set	b	0.005
set	eps_buck	0.020
set	b1	-0.040
set	b2	0.0025
set	gama	2.0  ;#244 800 960
set	c	1.00
set	sig_res	208.71

#uniaxialMaterial Elastic 1 $E0
#uniaxialMaterial Steel02 1 $fy0 $E0 $b 24 0.925 0.25 0.02 1.0 0.02 1.0
#Steel05LB $tag $Fy $E0 $b $eps_buck $b1 $gama $c $sig_res <$R0 $cR1 $cR2> <$a1 $a2 $a3 $a4> <$sigInit>
uniaxialMaterial Steel05LB $mat_Tag $fy0 $E0 $b $eps_buck $b1 $b2 $gama $c $sig_res 24 0.925 0.25 0.02 1.0 0.02 1.0 

set SecTagTorsion 200;
set Ubig 1.0e10;  # A large number
uniaxialMaterial Elastic $SecTagTorsion $Ubig

###Circular section------------------
set rext 69.9
set rint 65.4

##Plastic hinge length
set lp1 [expr {0.8 * 2 * $rext}]
set lp2 [expr {0.4 * 2 * $rext}]

#-------Elastic section-----------------------
# section fiberSec 1 -torsion $SecTagTorsion {
    # patch circ 1 12 4 0.0 0.0 $rint $rext 0.0 360.0 
               # }

#-------------Plastic hinge section---------------------
section fiberSec 2 -torsion $SecTagTorsion {
    patch circ 2 12 4 0.0 0.0 $rint $rext 0.0 360.0 
                }

#define brace elements
#-----------------------------------------------------

#condition of brace elements
geomTransf Corotational 1

##Model B-----------------------------------------------------------------
#element forceBeamColumn $eleTag $iNode $jNode $transfTag "HingeRadau $secTagI $LpI $secTagJ $LpJ $secTagInterior" <-mass $massDens> <-iter $maxIters $tol>
element forceBeamColumn 1 1 5 1 "HingeRadau 2 $lp1 2 $lp2 2" -iter 100 $tol_e 
element forceBeamColumn 2 5 9 1 "HingeRadau 2 $lp2 2 $lp1 2" -iter 100 $tol_e 


recorder Node -file $Datadir/node9disp.out -time -node 9 -dof 1 disp

## Apply the nodal Load
pattern Plain 1 Linear { load 9 1.0 0.0 0.0 }

## Static Analysis parameters
test NormUnbalance 5.0e-1 2000 5
algorithm KrylovNewton
system UmfPack
numberer RCM
constraints Plain
analysis Static

integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	150	;	puts	"	1	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	280	;	puts	"	2	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	290	;	puts	"	3	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	300	;	puts	"	4	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	300	;	puts	"	5	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	310	;	puts	"	6	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	720	;	puts	"	7	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1080	;	puts	"	8	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1040	;	puts	"	9	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1000	;	puts	"	10	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	990	;	puts	"	11	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	960	;	puts	"	12	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1080	;	puts	"	13	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1220	;	puts	"	14	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1220	;	puts	"	15	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1230	;	puts	"	16	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1250	;	puts	"	17	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1260	;	puts	"	18	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1560	;	puts	"	19	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1860	;	puts	"	20	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1880	;	puts	"	21	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1910	;	puts	"	22	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1950	;	puts	"	23	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1940	;	puts	"	24	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	2110	;	puts	"	25	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	2360	;	puts	"	26	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	2380	;	puts	"	27	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	2380	;	puts	"	28	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	2780	;	puts	"	29	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	3130	;	puts	"	30	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	3140	;	puts	"	31	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	3160	;	puts	"	32	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	3930	;	puts	"	33	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	4710	;	puts	"	34	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	4720	;	puts	"	35	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	4740	;	puts	"	36	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	5490	;	puts	"	37	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	6230	;	puts	"	38	"
integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	6250	;	puts	"	39	"
integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	5780	;	puts	"	40	"


wipe
