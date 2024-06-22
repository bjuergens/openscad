


tag_text_width  = 90;
tag_text_height = 20;
tag_text = "Poscht";
tag_text_depth = 1.5;

clamp_height1 = 30;
clamp_height2 = 15;
clamp_end_radius = 3;

thickness = 1.5;

edge_width= 15;

e = 0.1;

$fn=20;
//
module text_for_vertical_print(text_to_print, height){

    temp_text_base = 0.5;
    translate([height,height,-1.6*temp_text_base+1*height])
    minkowski()
    {
        rotate([0,0,180])
        linear_extrude(temp_text_base)
        text(text=text_to_print, valign="center",halign="center");
        // height == radius, to get that nicely printable angles, around 45 degrees
        cylinder(h=height,r1=height*1.0,r2=0,$fn=4);
    }
}

module text_plate(my_text, height){
    // the text has a little bit of a recangular base beneath it. Make sure that base sinks into the base-plat.
    text_for_vertical_print(my_text,1);
    translate([0,0,0])
    #cube([tag_text_width,tag_text_height,thickness], center= true);
}



rotate([45,0,0])
text_plate(tag_text, 1);

clamp_distance = sqrt((tag_text_height^2)/2);

// todo: use clamp_height for clamp_height.
//translate([0,tag_text_height/(sqrt(8)),0.5*tag_text_height-tag_text_height/sqrt(2) +0.7*thickness])
translate([0,0.5*clamp_distance,0.5*clamp_distance-0.5*clamp_height1])
rotate([90,0,0])
union(){translate([0,0.5*clamp_distance,0.5*clamp_distance-0.5*clamp_height2])
    cube([tag_text_width,clamp_height2,thickness], center=true);
     
    translate([0,0,-edge_width])
    cube([tag_text_width,clamp_height1,thickness], center=true);
        
    translate([0,0.5*clamp_height1,-0.5*edge_width])
        rotate([90,0,0])
    cube([tag_text_width,edge_width+thickness,thickness], center=true);

        rotate([0,90,0])
    translate([edge_width,-0.5*clamp_height1,0])
    scale([1,2,1])
    cylinder(h=tag_text_width, r1=clamp_end_radius,r2=clamp_end_radius, center=true);
}



//