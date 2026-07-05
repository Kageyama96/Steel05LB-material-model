# Unit: N, mm, sec
# Model to validate; 
wipe
model basic -ndm 2 -ndf 3
set Datadir M4_Model_B;     
file mkdir $Datadir;

#source Get_Rendering.tcl;
puts "directory defined"
#-------------------------------------------------------
#create nodes
#-------------------------------------------------------
node	1	0.0	0.0	0.0
node	5	1503.0	3.0	0.0
node	9	3006.0	0.0	0.0

puts "node defined"

## Mass
mass 9 1.0 0.0 0.0

puts "mass defined"

#fix node
# nodeTag DX DY RZ
fix 1 1 1 0
fix 9 0 1 0
puts "boundary condition defined"
#-----------------------------------------------------
# Fracture Parameters - # karamachi and Lignos
#set E0 0.095;
#set m -0.50;
#define the brace material
#uniaxialMaterial Fatigue 101 1 -E0 $E0 -m $m; 
##-----------------------------------------------------------------------

## Steel05LB-------------------------------------------------------------
set	mat_Tag	2
set	fy0	275.00
set	E0	205000.00
set	b	0.0050
set	eps_buck	0.009
set	b1	-0.056
set b2 -0.0025
set	lambda	0.9  ; #112 675
set	c	1.00
set	sig_res	114.14

#uniaxialMaterial Steel02 1 $fy0 $E0 $b 24 0.925 0.25 0.02 1.0 0.02 1.0
#Steel05LB $tag $Fy $E0 $b $eps_buck $b1 $lambda $c $sig_res <$R0 $cR1 $cR2> <$a1 $a2 $a3 $a4> <$sigInit>
uniaxialMaterial Steel05LB $mat_Tag $fy0 $E0 $b $eps_buck $b1 $b2 $lambda $c $sig_res 24 0.925 0.25 0.02 1.0 0.02 1.0 


set SecTagTorsion 200;
set Ubig 1.0e10;  # A large number
uniaxialMaterial Elastic $SecTagTorsion $Ubig

###Circular section------------------
set rext 51
set rint 49.4

##Plastic hinge length----------------------------------
set lp1 [expr {0.001 * 2 * $rext}]
set lp2 [expr {0.4 * 2 * $rext}]
#-------Elastic section---------------------------------
# section fiberSec 1 -torsion $SecTagTorsion {
    # patch circ 1 12 4 0.0 0.0 $rint $rext 0.0 360.0 
               # }

#-------------Plastic hinge section---------------------
section fiberSec 2 -torsion $SecTagTorsion {
    patch circ 2 12 4 0.0 0.0 $rint $rext 0.0 360.0 
                }

puts "material and section defined"

#define brace elements
#-----------------------------------------------------

#condition of brace elements
geomTransf Corotational 1
##Model B-----------------------------------------------------------------
#element forceBeamColumn $eleTag $iNode $jNode $transfTag "HingeRadau $secTagI $LpI $secTagJ $LpJ $secTagInterior" <-mass $massDens> <-iter $maxIters $tol>
set tol_e 10.0e-10
element forceBeamColumn 1 1 5 1 "HingeRadau 2 $lp1 2 $lp2 2" -iter 100 $tol_e 
element forceBeamColumn 2 5 9 1 "HingeRadau 2 $lp2 2 $lp1 2" -iter 100 $tol_e 

recorder Node -file $Datadir/node9disp.out -time -node 9 -dof 1 disp


## Apply the nodal Load
pattern Plain 1 Linear { load 9 1.0 0.0 0.0 }

## Static Analysis parameters
test NormUnbalance 0.9 2000 5
algorithm KrylovNewton
system UmfPack
numberer RCM
constraints Plain
analysis Static

# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	150	;	puts	"	1	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	290	;	puts	"	2	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	290	;	puts	"	3	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	290	;	puts	"	4	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	440	;	puts	"	5	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	590	;	puts	"	6	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	590	;	puts	"	7	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	610	;	puts	"	8	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	600	;	puts	"	9	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	580	;	puts	"	10	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1040	;	puts	"	11	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1520	;	puts	"	12	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1530	;	puts	"	13	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1530	;	puts	"	14	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1510	;	puts	"	15	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	1510	;	puts	"	16	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	1960	;	puts	"	17	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	2420	;	puts	"	18	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	2440	;	puts	"	19	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	2430	;	puts	"	20	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	2430	;	puts	"	21	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	2440	;	puts	"	22	"
# integrator	DisplacementControl	9	1	-0.01	;	analysis	Static;	analyze	2720	;	puts	"	23	"
# integrator	DisplacementControl	9	1	0.01	;	analysis	Static;	analyze	3020	;	puts	"	24	"

# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	300	;	puts	"	1	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	580	;	puts	"	2	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	580	;	puts	"	3	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	570	;	puts	"	4	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	870	;	puts	"	5	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	1180	;	puts	"	6	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	1180	;	puts	"	7	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	1220	;	puts	"	8	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	1190	;	puts	"	9	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	1170	;	puts	"	10	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	2090	;	puts	"	11	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	3030	;	puts	"	12	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	3060	;	puts	"	13	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	3050	;	puts	"	14	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	3020	;	puts	"	15	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	3020	;	puts	"	16	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	3920	;	puts	"	17	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	4830	;	puts	"	18	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	4870	;	puts	"	19	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	4850	;	puts	"	20	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	4860	;	puts	"	21	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	4870	;	puts	"	22	"
# integrator	DisplacementControl	9	1	-0.005	;	analysis	Static;	analyze	5440	;	puts	"	23	"
# integrator	DisplacementControl	9	1	0.005	;	analysis	Static;	analyze	6030	;	puts	"	24	"

# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	590	;	puts	"	1	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	1150	;	puts	"	2	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	1150	;	puts	"	3	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	1130	;	puts	"	4	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	1740	;	puts	"	5	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	2360	;	puts	"	6	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	2360	;	puts	"	7	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	2440	;	puts	"	8	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	2380	;	puts	"	9	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	2340	;	puts	"	10	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	4180	;	puts	"	11	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	6050	;	puts	"	12	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	6110	;	puts	"	13	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	6090	;	puts	"	14	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	6030	;	puts	"	15	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	6030	;	puts	"	16	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	7830	;	puts	"	17	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	9650	;	puts	"	18	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	9740	;	puts	"	19	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	9700	;	puts	"	20	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	9720	;	puts	"	21	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	9740	;	puts	"	22	"
# integrator	DisplacementControl	9	1	-0.0025	;	analysis	Static;	analyze	10880	;	puts	"	23	"
# integrator	DisplacementControl	9	1	0.0025	;	analysis	Static;	analyze	12050	;	puts	"	24	"


integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	1460	;	puts	"	1	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	2860	;	puts	"	2	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	2860	;	puts	"	3	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	2810	;	puts	"	4	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	4350	;	puts	"	5	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	5880	;	puts	"	6	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	5880	;	puts	"	7	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	6100	;	puts	"	8	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	5940	;	puts	"	9	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	5770	;	puts	"	10	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	10390	;	puts	"	11	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	15110	;	puts	"	12	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	15280	;	puts	"	13	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	15220	;	puts	"	14	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	15060	;	puts	"	15	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	15060	;	puts	"	16	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	19570	;	puts	"	17	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	24130	;	puts	"	18	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	24350	;	puts	"	19	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	24240	;	puts	"	20	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	24290	;	puts	"	21	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	24350	;	puts	"	22	"
integrator	DisplacementControl	9	1	-0.001	;	analysis	Static;	analyze	27200	;	puts	"	23	"
integrator	DisplacementControl	9	1	0.001	;	analysis	Static;	analyze	30110	;	puts	"	24	"








wipe
