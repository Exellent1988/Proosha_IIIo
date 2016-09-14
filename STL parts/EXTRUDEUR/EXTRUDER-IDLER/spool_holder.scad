spool_diameter=130;
spool_height=140;

spool_mount_screw_distance=46;
spool_mount_screw_diameter=4.5;
spool_mount_plate_width=60.5;
spool_mount_plate_thickness=5;
spool_mount_corners=4;
spool_mount_reinforcement_width=5;
spool_mount_reinfocement_length=10;

spool_mount_base_length=100;
spool_mount_base_thickness=5;

fudge=0.1;
$fn=32;
support_walls=0.5;

bowden_coupling_diameter=4.4;
bowden_coupling_flange_diameter=10;
bowden_coupling_length=2;

e3d_bowden_coupling_screw_diameter=9.9;
e3d_bowden_coupling_screw_length=10.1;
e3d_bowden_coupling_flange_diameter=15;
e3d_bowden_coupling_flange_length=12;
e3d_bowden_coupling_filament_diameter=2.5;

spool_mount();

module bowden_coupling_screw_cutout(){
translate([(spool_mount_plate_thickness+spool_mount_base_length)/2,-spool_mount_base_length/2+e3d_bowden_coupling_screw_length,spool_mount_base_thickness/2+e3d_bowden_coupling_flange_diameter/2])
	rotate([90,0,0])
		cylinder(r=e3d_bowden_coupling_screw_diameter/2,h=e3d_bowden_coupling_screw_length-support_walls);
}

module bowden_coupling_filament_cutout(){
translate([(spool_mount_plate_thickness+spool_mount_base_length)/2,-spool_mount_base_length/2+e3d_bowden_coupling_flange_length+e3d_bowden_coupling_flange_diameter/2,spool_mount_base_thickness/2+e3d_bowden_coupling_flange_diameter/2])
	rotate([90,0,0])
		cylinder(r=e3d_bowden_coupling_filament_diameter/2,h=e3d_bowden_coupling_flange_length+e3d_bowden_coupling_flange_diameter/2-support_walls);
}

module bowden_coupling_flange_block(){
	translate([(spool_mount_plate_thickness+spool_mount_base_length)/2,-spool_mount_base_length/2,spool_mount_base_thickness/2+e3d_bowden_coupling_flange_diameter/2])
		rotate([-90,0,0])
			cylinder(r=e3d_bowden_coupling_flange_diameter/2,h=e3d_bowden_coupling_flange_length);

	/*
	translate([spool_mount_plate_thickness+spool_mount_base_length/2,-spool_mount_base_length/2+e3d_bowden_coupling_flange_length,spool_mount_base_thickness/2+e3d_bowden_coupling_flange_diameter/2])
		rotate([-90,0,0])
			sphere(r=e3d_bowden_coupling_flange_diameter/2);
	*/
}

module bowden_coupling_flange(){
	difference(){
		bowden_coupling_flange_block();
		bowden_coupling_screw_cutout();
		bowden_coupling_filament_cutout();
	}
}

module spool_mount(){
	bowden_coupling_flange();
	difference(){
		spool_mount_block();
		spool_cutout();
		bowden_coupling_screw_cutout();
		bowden_coupling_filament_cutout();
		spool_mount_screws_cutout();
	}
	
}

module spool_mount_block(){
	hull(){
		spool_mount_plate();
		//spool_mount_plate_base();
		spool_mount_base();
	}
}


module spool_cutout(){
	translate([spool_mount_plate_thickness,0,spool_mount_base_thickness+spool_height])
		rotate([0,90,0])
			cylinder(r=spool_height,h=spool_mount_base_length-spool_mount_plate_thickness+fudge,$fn=4*$fn);
}

module spool_mount_screws_cutout(){
	translate([-fudge,0,spool_mount_base_thickness+spool_height])
		for(y=[-1,1])
			for(z=[-1,1])
				translate([0,y*spool_mount_screw_distance/2,z*spool_mount_screw_distance/2])
					rotate([0,90,0])
						cylinder(r=spool_mount_screw_diameter/2,h=spool_mount_plate_thickness+2*fudge,$fn=4*$fn);
}


module spool_mount_plate(){
	translate([0,0,spool_mount_base_thickness+spool_height]){
		translate([0,-spool_mount_plate_width/2+spool_mount_corners,-spool_mount_plate_width/2])
			cube([spool_mount_plate_thickness,spool_mount_plate_width-2*spool_mount_corners,spool_mount_plate_width]);
		translate([0,-spool_mount_plate_width/2,-spool_mount_plate_width/2+spool_mount_corners])
			cube([spool_mount_plate_thickness,spool_mount_plate_width,spool_mount_plate_width-2*spool_mount_corners]);
	}
}

module spool_mount_plate_base(){
	translate([0,-spool_mount_base_length/2,0])
		cube([spool_mount_plate_thickness,spool_mount_base_length,spool_mount_base_thickness]);
	
}

module spool_mount_base(){
	translate([0,-spool_mount_base_length/2,0])
		cube([spool_mount_base_length,spool_mount_base_length,spool_mount_base_thickness]);
}