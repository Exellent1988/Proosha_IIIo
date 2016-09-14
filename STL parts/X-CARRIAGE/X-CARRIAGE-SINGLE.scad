plate_dimensions=[35,68,5];
plate_corner_radius=4;
plate_elevation=6;

bushing_outer_diameter=15;
bushing_inner_diameter=8;
bushing_length=24;
bushing_clearances=[0.2,0,0];
interaxial_distance=45;

bushing_center_to_center=26.5;
bushing_plate_offset=11;

mounting_hole_distance=23;
mounting_hole_diameter=4.2;
mounting_hole_length=14;

belt_hole_distance=14;
belt_hole_offset=-6.4; // = radius of 20 teeth GT2 pulley
belt_hole_diameter=4.2;
belt_hole_length=14;


bushing_slot_height=2*sqrt(pow(bushing_outer_diameter/2,2)-pow(bushing_plate_offset-plate_elevation,2));

overlap=0.1;


module mounting_holes(){
	translate([mounting_hole_distance/2,-mounting_hole_distance/2,-overlap])
		cylinder(r=mounting_hole_diameter/2,h=mounting_hole_length+2*overlap,$fn=32);
	translate([-mounting_hole_distance/2,-mounting_hole_distance/2,-overlap])
		cylinder(r=mounting_hole_diameter/2,h=mounting_hole_length+2*overlap,$fn=32);
	translate([mounting_hole_distance/2,mounting_hole_distance/2,-overlap])
		cylinder(r=mounting_hole_diameter/2,h=mounting_hole_length+2*overlap,$fn=32);
	translate([-mounting_hole_distance/2,mounting_hole_distance/2,-overlap])
		cylinder(r=mounting_hole_diameter/2,h=mounting_hole_length+2*overlap,$fn=32);
}

module belt_holes(){
	translate([belt_hole_distance/2,belt_hole_offset,-overlap])
		cylinder(r=mounting_hole_diameter/2,h=mounting_hole_length+2*overlap,$fn=32);
	translate([-belt_hole_distance/2,belt_hole_offset,-overlap])
		cylinder(r=mounting_hole_diameter/2,h=mounting_hole_length+2*overlap,$fn=32);
}

module vanilla_carriage(){
	import("X-CARRIAGE.stl");
}

module plate(){
	/*
	translate([-plate_dimensions[0]/2,-plate_dimensions[1]/2,0])
		cube(plate_dimensions);
	*/
	translate([0,0,plate_elevation-plate_dimensions[2]])
		hull(){
			translate([plate_dimensions[0]/2-plate_corner_radius,-plate_dimensions[1]/2+plate_corner_radius,0])
				cylinder(r=plate_corner_radius,h=plate_dimensions[2],$fn=32);
			translate([-plate_dimensions[0]/2+plate_corner_radius,-plate_dimensions[1]/2+plate_corner_radius,0])
				cylinder(r=plate_corner_radius,h=plate_dimensions[2],$fn=32);
			translate([plate_dimensions[0]/2-plate_corner_radius,plate_dimensions[1]/2-plate_corner_radius,0])
				cylinder(r=plate_corner_radius,h=plate_dimensions[2],$fn=32);
			translate([-plate_dimensions[0]/2+plate_corner_radius,plate_dimensions[1]/2-plate_corner_radius,0])
				cylinder(r=plate_corner_radius,h=plate_dimensions[2],$fn=32);
		}
}

module carriage_legacy(){
	difference(){
		vanilla_carriage();
		
		mounting_holes();
		belt_holes();
		translate([-bushing_center_to_center/2,interaxial_distance/2,bushing_plate_offset])
			rotate([0,90,0])
				cylinder(h=bushing_length+2*bushing_clearances[0],r=bushing_outer_diameter/2+bushing_clearances[1],center=true, $fn=32);
		translate([bushing_center_to_center/2,interaxial_distance/2,bushing_plate_offset])
			rotate([0,90,0])
				cylinder(h=bushing_length+2*bushing_clearances[0],r=bushing_outer_diameter/2+bushing_clearances[1],center=true, $fn=32);
		translate([-bushing_center_to_center/2,-interaxial_distance/2,bushing_plate_offset])
			rotate([0,90,0])
				cylinder(h=bushing_length+2*bushing_clearances[0],r=bushing_outer_diameter/2+bushing_clearances[1],center=true, $fn=32);
		translate([bushing_center_to_center/2,-interaxial_distance/2,bushing_plate_offset])
			rotate([0,90,0])
				cylinder(h=bushing_length+2*bushing_clearances[0],r=bushing_outer_diameter/2+bushing_clearances[1],center=true, $fn=32);	
	}
	
}
module bushings_slim(){
		translate([0,interaxial_distance/2,bushing_plate_offset])
			rotate([0,90,0])
				bushing();

		translate([0,-interaxial_distance/2,bushing_plate_offset])
			rotate([0,90,0])
				bushing();
}

module bushing(){
	difference(){
		cylinder(h=bushing_length+2*bushing_clearances[0],r=bushing_outer_diameter/2,center=true, $fn=64);
		translate([0,0,-overlap])
			cylinder(h=bushing_length+2*bushing_clearances[0]+2*overlap,r=bushing_inner_diameter/2,center=true, $fn=64);
	}
}

module carriage_slim(){
	difference(){
		plate();
		mounting_holes();
		belt_holes();
		
		translate([-bushing_length/2-bushing_clearances[0],interaxial_distance/2-bushing_slot_height/2,plate_elevation-plate_dimensions[2]-overlap])
			cube([bushing_length+2*bushing_clearances[0],bushing_slot_height,plate_dimensions[2]+2*overlap]);

		translate([-bushing_length/2-bushing_clearances[0],-interaxial_distance/2-bushing_slot_height/2,plate_elevation-plate_dimensions[2]-overlap])
			cube([bushing_length+2*bushing_clearances[0],bushing_slot_height,plate_dimensions[2]+2*overlap]);
	}
	
}



//vanilla_carriage();
//bushings_slim();
projection()
	carriage_slim();
