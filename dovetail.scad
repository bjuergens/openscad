

tail_length = 30;
base_width = 17;
overhang_width = 10;
chamf = 4;
e = 0.001;
tol= 3;

inner_tail_count = 2;
anchor_length = 12;

step_width = (2*base_width+ 2*overhang_width + 2*tol);

total_width = 2*base_width + overhang_width + tol 
            + inner_tail_count*step_width;


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

module side_a ()
{
    for(i=[0:inner_tail_count-1]){
        translate([base_width + tol + i*step_width , 0, 0])
        dove_tail();
    }
    
  translate([ total_width ,0,0])
  mirror([1,0,0])
  dove_tail_end();

  translate([0,-anchor_length])
  square([total_width,anchor_length]);
};
  
module side_b(){
  for(i=[0:inner_tail_count-1]){
    translate([2*base_width + 2*tol + overhang_width + i*step_width, tail_length, 0])
    mirror([0,1,0])
    dove_tail();
  }
  
  translate([0,tail_length,0])
  mirror([0,1,0])
  dove_tail_end();
 
  translate([0,tail_length])
  square([total_width,anchor_length]);
}

// todo: side_a and side_b can be merged, probably

color("green") 
linear_extrude(height = 20)
side_a();

color("orange")
linear_extrude(height = 20)
translate([0,tol/2,0])
side_b();