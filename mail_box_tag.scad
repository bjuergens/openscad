

tag_dim = [85,48,2];

text1 = "Vorname Name";
text2 = "Vorname Name";
text3 = "Vorname Name";

pad = [14,33];
font_size = 6;
line_height =  1.7;

module multiLine(){
  union(){
    for (i = [0 : $children-1])
      translate([0 , -i * font_size * line_height, 0 ]) children(i);
  }
}


color("darkgray")
translate([pad.x,pad.y,0])
linear_extrude(0.9)
multiLine(){
  text(text1, size=font_size);
  text(text2, size=font_size);
  text(text3, size=font_size);
}


color("silver")
translate([0,0,-tag_dim.z])
cube(tag_dim);
