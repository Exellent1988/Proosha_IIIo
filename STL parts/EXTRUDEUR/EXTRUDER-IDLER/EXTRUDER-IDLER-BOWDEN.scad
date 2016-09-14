fudge=0.1;
neglectable=0.01;

$fn=32;

idler_width=26;
idler_length=36.72;
idler_height=12;

idler_hinge_y=10;
idler_hinge_z=20;
idler_hinge_screw_diameter=3.4;
idler_hinge_diameter=10.6;
idler_hinge_position=[idler_width/2,36.72,10];
idler_hinge_angle=60;
idler_hinge_cutout_diameter=11.6;
idler_hinge_cutout_width=13;
idler_hinge_cutout_angle=-30;

idler_rod_diameter=8.49;
idler_rod_length=20;
idler_rod_position=[idler_width/2,20.425,10];

idler_bearing_diameter=23.9;
idler_bearing_width=9;

idler_bearing_rim_diameter_1=12;
idler_bearing_rim_diameter_2=14.1;
idler_bearing_rim_width=1.05;

corner_radius=4;


idler_screw_hole_distance=16;
idler_screw_hole_y=4.92;
idler_screw_hole_length=4.9;
idler_screw_hole_diameter=3.9;

idler_guide_height=8.8;
idler_guide_width=8;
idler_guide_length=10;
idler_guide_hole_z=20.8;
idler_guide_hole_diameter=4.4;
idler_guide_ring_diameter=11;
idler_guide_max_z=23.8;


idler();
//idler_hinge_block();
//vanilla_idler();

module idler_guide_max_z_cutout(){
	translate([idler_width/2-idler_guide_ring_diameter/2-fudge,-fudge,idler_guide_max_z])
		cube([idler_guide_ring_diameter+2*fudge,idler_guide_length+2*fudge,idler_guide_ring_diameter+fudge]);
}

module idler_guide(){
	difference(){
		idler_guide_block();
		idler_guide_hole_cutout();
	}	
}

module idler_guide_hole_cutout(){
	translate([idler_width/2,0,idler_guide_hole_z])
		rotate([-90,0,0])
			translate([0,0,-fudge])
				cylinder(r=idler_guide_hole_diameter/2,h=idler_guide_length+2*fudge);
}

module idler_guide_block(){
	translate([(idler_width-idler_guide_width)/2,0,idler_height-fudge])
		cube([idler_guide_width,idler_guide_length,idler_guide_height+fudge]);
	translate([idler_width/2,0,idler_guide_hole_z])
		rotate([-90,0,0])
			cylinder(r=idler_guide_ring_diameter/2,h=idler_guide_length);
}

module idler(){
	difference(){
		idler_block();
		idler_hinge_angle_cutout();	
		idler_hinge_cutout();
		idler_hinge_screw_cutout();
		idler_bearing_cutout();
		idler_rod_cutout();
		idler_screw_holes();
		idler_guide_hole_cutout();
		idler_guide_max_z_cutout();
	}	
}

module idler_block(){
	idler_body();
	idler_guide_block();
	idler_hinge_block();	
}


module idler_screw_holes(){
	translate([idler_width/2,idler_screw_hole_y,-fudge])
		for(x=[-1,1])
			translate([x*idler_screw_hole_distance/2,0,0])
				hull(){
					for(y=[-1,1])
						translate([0,y*(idler_screw_hole_length-idler_screw_hole_diameter)/2,0])
							cylinder(r=idler_screw_hole_diameter/2,h=idler_height+2*fudge);
				}
}


//idler_body();

module idler_body(){
	hull(){
		translate([corner_radius,corner_radius,0])
			cylinder(r=corner_radius,h=idler_height);
		translate([idler_width-corner_radius,corner_radius,0])
			cylinder(r=corner_radius,h=idler_height);
		translate([0,corner_radius,0])
			cube([idler_width,idler_length-corner_radius,idler_height]);
	}
}


module idler_bearing_rim(){
	translate(idler_rod_position+[(idler_bearing_width-idler_bearing_rim_width)/2+neglectable/2,0,0])
		rotate([0,90,0])
			cylinder(r1=idler_bearing_rim_diameter_1/2,r2=idler_bearing_rim_diameter_2/2,h=idler_bearing_rim_width+neglectable,center=true,$fn=2*$fn);	
	translate(idler_rod_position-[(idler_bearing_width-idler_bearing_rim_width)/2+neglectable/2,0,0])
		rotate([0,90,0])
			cylinder(r1=idler_bearing_rim_diameter_2/2,r2=idler_bearing_rim_diameter_1/2,h=idler_bearing_rim_width+neglectable,center=true,$fn=2*$fn);	
}

module idler_bearing_cutout_block(){
	translate(idler_rod_position)
		rotate([0,90,0])
			cylinder(r=idler_bearing_diameter/2,h=idler_bearing_width,center=true,$fn=2*$fn);	
}

module idler_bearing_cutout(){
	difference(){
		idler_bearing_cutout_block();
		idler_bearing_rim();
	}
}


module idler_rod_cutout(){
	translate(idler_rod_position)
		rotate([0,90,0])
			cylinder(r=idler_rod_diameter/2,h=idler_rod_length,center=true);	
}

module idler_hinge_screw_cutout(){
	translate(idler_hinge_position)
		rotate([0,90,0])
			cylinder(r=idler_hinge_screw_diameter/2,h=idler_width+2*fudge,center=true);
}


module idler_hinge_block(){
	hull(){
		translate(idler_hinge_position)
			rotate([0,90,0])
				cylinder(r=idler_hinge_diameter/2,h=idler_width,center=true,$fn=2*$fn);
	
		//translate(idler_hinge_position+[0,(idler_hinge_position[2]-idler_hinge_diameter/2)*cos(180+idler_hinge_angle),(idler_hinge_position[2]-idler_hinge_diameter/2)*sin(180+idler_hinge_angle)])
		//translate(idler_hinge_position+[0,0,-idler_hinge_position[2]+idler_hinge_diameter/2])
			//rotate([0,90,0])
				//cylinder(r=idler_hinge_diameter/2,h=idler_width,center=true,$fn=2*$fn);
		translate([idler_hinge_position[0],idler_hinge_position[1]+(idler_hinge_position[2]-idler_hinge_diameter/2)*cos(180+idler_hinge_angle),0])
			cube([idler_width,idler_hinge_diameter,neglectable],center=true);
	}
}

module idler_hinge_angle_cutout(){
	translate(idler_hinge_position)
		rotate([idler_hinge_angle-90,0,0])
			translate([0,idler_hinge_diameter,0])
				cube([idler_width+2*fudge,idler_hinge_diameter,idler_length],center=true);
}


module idler_hinge_cutout(){
	hull(){
		translate(idler_hinge_position)
			rotate([0,90,0])
				cylinder(r=idler_hinge_cutout_diameter/2,h=idler_hinge_cutout_width,center=true,$fn=2*$fn);
	
		translate(idler_hinge_position+[0,idler_length*cos(idler_hinge_cutout_angle),idler_length*sin(idler_hinge_cutout_angle)])
			rotate([0,90,0])
				cylinder(r=idler_hinge_cutout_diameter/2,h=idler_hinge_cutout_width,center=true,$fn=2*$fn);
	}
}

module vanilla_idler(){
	translate([-1,-1.5749,-0.0445])
		import("EXTRUDER-IDLER-GUIDE.stl");
}