

tail_length = 30;
base_width = 17;
overhang_width = 10;
tails=2;
chamf = 4;
e = 0.001;
tol= 3;
anchor_length = 12;
step_width = (2*base_width+ 2*overhang_width + 2*tol);


module dove_overhang() {
    points = [
        [0,0],
        [0,tail_length],
        [overhang_width,tail_length],
    ];
    points_chamf  = [
        [overhang_width+e,tail_length+e],
        [overhang_width+e,tail_length-chamf+e],
        [overhang_width-chamf-e,tail_length+e]];
    points_chamf_base= [
        [0,chamf],
        [0,0],
        [chamf,0]];
    difference(){
        polygon(points);
        polygon(points_chamf);
    }  
    polygon(points_chamf_base);
}


module dove_body(){
    polygon([
        [0,0],
        [0,tail_length],
        [base_width,tail_length],
        [base_width,0]
    ]);  
}

module dove_tail(){
    translate([overhang_width,0])
    dove_body();
    translate([overhang_width+base_width,0])
    dove_overhang();

    mirror([1,0,0])
    translate([-overhang_width,0])
    dove_overhang();
}

module dove_tail_end(){
    dove_body();
    translate([base_width,0])
    dove_overhang();
}

module tailrow(inner_tail_count){
    for(i=[0:inner_tail_count-1]){
        translate([i* step_width , 0, 0])
        dove_tail();
    }
}

module side (has_end, has_start, inner_tail_count){
    // todo: depending on "has_end" and "has_start" the total width should vary
    
    total_width = 2*base_width + 1*overhang_width + 1*tol 
                + inner_tail_count*step_width;
    
    if (has_start){
        translate([0,0,0])
        dove_tail_end();
        
        translate([1*overhang_width +2* base_width +2* tol ,0,0])
        tailrow(inner_tail_count);
    }else {
        translate([ base_width + tol ,0,0])
        tailrow(inner_tail_count);
    }
    
    if (has_end){
        translate([ total_width ,0,0])
        mirror([1,0,0])
        dove_tail_end();
    }

    translate([0,-anchor_length])
    square([total_width,anchor_length]);
}

color("green") 
linear_extrude(height = 20)
side(has_end=false, has_start=true, inner_tail_count=tails);;

color("orange", alpha=0.3)
linear_extrude(height = 20)
translate([0 ,tail_length + tol/2,0])
mirror([0,1,0])
side(has_end = true, has_start =false, inner_tail_count=tails);