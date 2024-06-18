//use <dovetails.scad>;
use <dovetail.scad>;

e = 0.01;
e2 = 0.02;
outer_width = 20;
outer_depth = 54;
outer_height= 29.5;
thickness = 4;
chamf_size = 2;

arm_length= 80;
arm_width =18;

dove_base = 1;
$fn=30;

module chamf(width, length, height){
    rotate([0,45,0])
    translate([e-width/2,-e,e-height/2])
    cube([width, length+e2, height+e2]);
}
module chamf4(depth, height, width){
    
    translate([0,0,0])
        chamf(chamf_size, depth,chamf_size);
      
    translate([width,0,0])
        chamf(chamf_size, depth,chamf_size);
      
    translate([0,0,height])
        chamf(chamf_size, depth,chamf_size);
    
    translate([width,0,height])
        chamf(chamf_size, depth,chamf_size);
    
}

module clamp(width, depth, height){
    
    
    inner_width = width-2*e;
    inner_depth = depth - 3*thickness;
    inner_height= height- 1*thickness;
    
    hole_diam = 0.75*inner_width;
    
    translate([0,0,thickness])
  difference(){
    translate([e,-thickness,-thickness])
    cube([inner_width, depth, height+2*thickness]);
    cube([width, inner_depth, height]);
        
    translate([-e,-thickness-e,-0])
      cube([inner_width+3*e, 2*thickness, height]);
            
    translate([hole_diam/4 ,inner_depth+2.5*thickness,0.5*height])
    rotate([90,90,0])
      long_hole(hole_diam,3*thickness,height);
    
      translate([0,-thickness,-thickness])
      chamf4(depth,height+2*thickness, width);
      
      translate([width,-thickness,-thickness])
      rotate([0,0,90])
      chamf4(width,height+2*thickness, depth);
      
      translate([0,+1*depth-thickness,-1*thickness])
      rotate([90,0,00])
      chamf4(height+2*thickness,depth, width);
  };
  translate([width/2-4.5,-0.75*thickness,thickness-e2])
  #cube([5.5,3,7]);    
  
  translate([width/2-4.5,-0.75*thickness,inner_height+0.25*thickness+e2])
  #cube([5.5,3,7]);    
}


module long_hole(width, height, length){
    radius = 0.5*width;
    difference(){
        union(){
    translate([0,radius,0])
        cylinder(height,radius,radius);
    translate([-radius,radius,0])
        cube([width,length-width,height]);
        }
    }
    
    
    
}

 

module dove_tails(tailcount = 2, tail_length=5, tail_width=3){
   rotate([0,0,-90])
   union(){
color("green") 
linear_extrude(height = 20)
side(has_end=false, has_start=true, inner_tail_count=tails);;

color("orange", alpha=0.3)
linear_extrude(height = 20)
translate([0 ,tail_length + tol/2,0])
mirror([0,1,0])
side(has_end = true, has_start =false, inner_tail_count=tails);
   }

}

module dove_pins(tailcount = 2, tail_length=5, tail_width=3){
   translate([-tail_length,0,0])
   rotate([90,0,90])
    dovetail_pins(
        pin_length=thickness- dove_base, 
        pin_width=6, 
        pin_thickness=tail_length, 
        pin_count=tailcount+1, 
        angle=15, 
        tail_width=3);
    
}
module arm (){
    
    difference(){
    union(){
        dove_pins();
        
        multmatrix(m =[[ 1, 0, 0, 0],
                       [ 0.4, 1, 0, 0],
                       [ 0, 0, 1, 0],
                       [ 0, 0, 0, 1]
                  ])
        cube([arm_length,arm_width,thickness]);
        }
        
    translate([arm_length-10,arm_length*0.4+arm_width/4,-e])
    cylinder(10,3,3);
    }
  
}


module reference(){
    
rotate([0,0,90])
%import("C:/Users/chef/Documents/print3d/stl/done/ender-3-v3-se-c270-camera-mount-model_files/ender-3-v3-se-cam-mount-ver2-bracket.stl");

}

!rotate([0,270,0])
union(){
    rotate([0,180,0])
translate([0,0,-0])
clamp(outer_width,outer_depth,outer_height);
    
translate([0,outer_depth-thickness,-outer_height-2*thickness+dove_base])
dove_tails();
}
translate([35,-10,0])

arm();


color("green") 
linear_extrude(height = 20)
side(has_end=false, has_start=true, inner_tail_count=tails);;

color("orange", alpha=0.3)
linear_extrude(height = 20)
translate([0 ,tail_length + tol/2,0])
mirror([0,1,0])
side(has_end = true, has_start =false, inner_tail_count=tails);

