# Unit: N, mm, sec
# Model to validate; 
wipe
model basic -ndm 2 -ndf 3
set Datadir M1_Model_B;      # set up name of data directory
file mkdir $Datadir;

#source Get_Rendering.tcl;
puts "directory defined"
#-------------------------------------------------------
#create nodes
#-------------------------------------------------------

##------Model B---------------------------
##Using beam with hinges element
node	1	0.00	0.00	0.00
node	5	768.50	1.5		0.00
node	9	1537.00	0.00	0.00

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
#-----------------------------------------------------
## Parameters are provided by karamanci
#uniaxialMaterial Steel02 1 $fyb $E $b1 24 0.925 0.25 0.02 1.0 0.02 1.0
#uniaxialMaterial Fatigue 101 1 -E0 $E0 -m $m; 
##-----------------------------------------------------------------------

set rext 69.9
set rint 66.4

### Steel05LB parameters###
set	mat_Tag	2
set	fy0	360.00
set	E0	205000.00
set	b	0.0050
set	eps_buck	0.015
set	b1	-0.048
set	b2	0.0025
set	lambda	2.7 ;#400 1000 800 960
set	c	1.00
set	sig_res	178.86
set lp1 [expr {0.8 * 2 * $rext}]
set lp2 [expr {0.4 * 2 * $rext}]

#uniaxialMaterial Elastic 1 $E0
#uniaxialMaterial Steel02 2 $fy0 $E0 $b 24 0.925 0.25 0.02 1.0 0.02 1.0
#Steel05LB $tag $Fy $E0 $b $eps_buck $b1 $b2 $lambda $c $sig_res <$R0 $cR1 $cR2> <$a1 $a2 $a3 $a4> <$sigInit>
uniaxialMaterial Steel05LB $mat_Tag $fy0 $E0 $b $eps_buck $b1 $b2 $lambda $c $sig_res 24 0.925 0.25 0.02 1.0 0.02 1.0 


set SecTagTorsion 200;
set Ubig 1.0e10;  # A large number
uniaxialMaterial Elastic $SecTagTorsion $Ubig
###Circular section------------------
# section fiberSec 1 -torsion $SecTagTorsion {
    # patch circ 1 12 4 0.0 0.0 $rint $rext 0.0 360.0 
               # }

section fiberSec 2 -torsion $SecTagTorsion {
    patch circ 2 12 4 0.0 0.0 $rint $rext 0.0 360.0 
               }
			  		   
#define brace elements
#-----------------------------------------------------
#condition of brace elements
geomTransf Corotational 1

##Model C-----------------------------------------------------------------
#element forceBeamColumn $eleTag $iNode $jNode $transfTag "HingeRadau $secTagI $LpI $secTagJ $LpJ $secTagInterior" <-mass $massDens> <-iter $maxIters $tol>
set tol_e 10.0e-10
# all fiber provided with Steel05LB--------------------------------------------
element forceBeamColumn 1 1 5 1 "HingeRadau 2 $lp1 2 $lp2 2" -iter 150 $tol_e 
element forceBeamColumn 2 5 9 1 "HingeRadau 2 $lp2 2 $lp1 2" -iter 150 $tol_e 

recorder Node -file $Datadir/node9disp.out -time -node 9 -dof 1 disp
#recorder Element -file $Datadir/ele_sec_def.out -time -ele 1 2 3 4 5 6 7 8 section deformation 
# recorder Element -file $Datadir/ele4sec_StressStrain1.out -time -ele 2 section 1 fiber 69.9 0 stressStrain
# recorder Element -file $Datadir/ele4sec_StressStrain2.out -time -ele 2 section 1 fiber -69.9 0 stressStrain
# recorder Element -file $Datadir/ele4sec_StressStrain3.out -time -ele 2 section 1 fiber 0 -69.9 stressStrain
# recorder Element -file $Datadir/ele4sec_StressStrain4.out -time -ele 2 section 1 fiber 0 69.9 stressStrain


## Apply the nodal Load
pattern Plain 1 Linear { load 9 1.0 0.0 0.0 }

## Static Analysis parameters
test NormUnbalance 9.0e-1 2000 5
algorithm KrylovNewton
system UmfPack
numberer RCM
constraints Plain
analysis Static

##Monotonic compressive
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	3065	;	puts	"	1	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	6163	;	puts	"	2	"


integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	150	;	puts	"	1	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	368	;	puts	"	2	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	368	;	puts	"	3	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	368	;	puts	"	4	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	368	;	puts	"	5	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	400	;	puts	"	6	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	1102	;	puts	"	7	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	1804	;	puts	"	8	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	1870	;	puts	"	9	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	1904	;	puts	"	10	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	1904	;	puts	"	11	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	1870	;	puts	"	12	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	2138	;	puts	"	13	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	2438	;	puts	"	14	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	2504	;	puts	"	15	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	2538	;	puts	"	16	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	2506	;	puts	"	17	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	2540	;	puts	"	18	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	3140	;	puts	"	19	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	3708	;	puts	"	20	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	3708	;	puts	"	21	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	3708	;	puts	"	22	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	3708	;	puts	"	23	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	3740	;	puts	"	24	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	4208	;	puts	"	25	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	4710	;	puts	"	26	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	4710	;	puts	"	27	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	4676	;	puts	"	28	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	5410	;	puts	"	29	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	6178	;	puts	"	30	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	6178	;	puts	"	31	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	6112	;	puts	"	32	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	7716	;	puts	"	33	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	9286	;	puts	"	34	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	9286	;	puts	"	35	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	9320	;	puts	"	36	"
integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	10824	;	puts	"	37	"
integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	12326	;	puts	"	38	"


wipe
