# Steel05LB
Steel05LB is a uniaxial material model which can capture local buckling-induced degradation in Structural steel section.
The material model is based on Steel02. The local buckling-induced degradation is based on rules proposed by Denavit and Hajjar (2014) and cyclic degradation is captured using energy based rule proposed by Rahnama and Krawinkler (1993).

# Syntax:
Steel05LB $tag $Fy $E0 $b $eps_buck $b1 $b2 $gama $c $sig_res <$R0 $cR1 $cR2> <$a1 $a2 $a3 $a4> <$sigInit>\
$tag - Material Tag.\
$Fy - Yield stress.\
$E0 - Young's modulus.\
$b - Strain hardening ratio.\
$eps_buck - Local buckling strian.\
$b1 - Softening ratio 1, b1\*E0.\
$b2 - Reduced softening ratio 2, b2\*E0.\
$gama - Reference cumulative strain capacity at the fibre level.\
$c - Defines the rate of cyclic deterioration, c = 1.0.\
$sig_res - Post-buckling residual stress.\
$R0 -  Initial value of the GMP curvature parameter R. Default 15.\
$cR1 - GMP R-degradation coefficient 1. Default 0.925.\
$cR2 -  GMP R-degradation coefficient 2. Default 0.15.\
$a1 - Isotropic hardening, compression side magnitude. Default 0.\
$a2 - Isotropic hardening, compression side reference strain scale. Default 1.\
$a3 - Isotropic hardening, tension side magnitude. Default 0.\
$a4 - Isotropic hardening, tension side reference strain scale. Default 1.\
$sigInit -  Initial stress (e.g. residual stress). Default 0.

