module mCube(x,y,z){
    translate([-x,-y,0]/2)cube([x,y,z]);
}

module thick_rectangle(inner_length, inner_width, border_width, height){
    difference(){
        mCube(inner_length + border_width,inner_width + border_width, height);
        mCube(inner_length,inner_width,height);
    }
}

module prism(l, w, h){
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
}


module square3D(width, length, height, thickness, inner=false){
    if(inner){
        difference(){
            mCube(width+thickness*2,length+thickness*2,height);
            mCube(width, length, height);
            
        }
    }
    else{
        difference(){
            mCube(width,length,height);
            mCube(width-thickness*2, length-thickness*2, height);
            
        }
    }
}


module cropped_triangle(size,center=false){
    
    if(center){
        translate(-size/2)
        difference(){
            cube(size);
            cylinder(h=size[2],r=size[0]);
        }
    }else{
        difference(){
            cube(size);
            cylinder(h=size[2],r=size[0]);
        }
    }
}


module round_rectangle(L,w,h=10){
    
    hull(){
        translate([0,-L/2,0])cylinder(h=h,d=w);
        translate([0,L/2,0])cylinder(h=h,d=w);
    }
}

module u_shape(length,width,thickness,height){
    
    linear_extrude(length-height){
        square([width - height,thickness], center=true);
        
        translate([-width/2+thickness/sqrt(2),-height/2-0.42,0])rotate([0,0,45])square([height/sqrt(2),thickness]);
        mirror([1,0,0])translate([-width/2+thickness/sqrt(2),-height/2-0.42,0])rotate([0,0,45])square([height/sqrt(2),thickness]);
        
        //translate([-width/2,-height+thickness/2,0])square([thickness,height/2]);
        //mirror([1,0,0])translate([-width/2,-height+thickness/2,0])square([thickness,height/2]);
    }
    
}

// Function to create a rectangle with chamfered edges
module chamfered_rectangle(length, width, height, chamfer_size) {
    minkowski() {
        // The base rectangle
        mCube(length, width, height);
        
        // A small cylinder to chamfer the edges
        cylinder(h = chamfer_size, r1 = chamfer_size / 2, r2 = 0, $fn = 32);
    }
}


chamfered_rectangle(100,100,3,3);

// Function to create a chamfered thick rectangular border (empty inside)
module chamfered_thick_rectangle(outer_length, outer_width, border_width, chamfer_size) {
    difference() {
        // Outer rectangle with chamfered edges
        minkowski() {
            cube([outer_length - chamfer_size, outer_width - chamfer_size, border_width]); // Base outer rectangle
            translate([chamfer_size / 2, chamfer_size / 2, 0])
                cube([chamfer_size, chamfer_size, chamfer_size]); // Small cube for chamfering
        }
        
        // Inner cutout to make it an empty rectangle
        translate([border_width/2, border_width/2, -0.1]) // Ensure it fully overlaps
            cube([outer_length - 2*border_width, outer_width - 2*border_width, border_width + 0.2]);
    }
}
