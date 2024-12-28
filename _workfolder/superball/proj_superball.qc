// Created by Crowbar 0.71

$modelname "weapons\bloxxers_arsenal\projectiles\superball.mdl"

$scale 3
$bodygroup "projectile"
{
	studio "proj_superball.smd"
}


$surfaceprop "plastic"

$contents "solid"

$cdmaterials "models\weapons\bloxxers_arsenal\superball\"

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0

$sequence "idle" {
	"static_idle.smd"
	activity "ACT_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "proj_superball.smd"
{
	$mass 5
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
