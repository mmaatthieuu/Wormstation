/*
 * Wormstation
 * by Matthieu Schmidt - https://github.com/mmaatthieuu/Wormstation
 * created 2021-03-15
 * updated 2025-01-09
 * version v1.0
 *
 * Changelog
 * --------------
 * v1.0:
 *      - Massive clean
 *      - Improved customizer
 * v0.6.2:
 *      - New basement floor for new PCB
 *      - New basement
 *      - Remove side wall on cam plate
 *      - Remove old modules
 *      - Multi_LED_bar_v3 (more space between legs for N=3)
 * v0.6.1:
 *      - remove unused modules
 *      - wheels, breadboard, windshield
 * v0.6:
 *      - add screw holes in Led bars
 *      - add PCB cover
 *      - one single big foot
 *      - add chemotaxis mode
 *      - remove unused parts in the code
 * --------------
 *
 * This work is licensed under the MIT License.
 */


 // Parameter Section //
//-------------------//

/* [Global display settings] */


// Enable Draft Mode to ignore shape details and speed up rendering. It also shows non-pritable parts as lenses or perti dishes.
DRAFT_MODE = true;


// Choose between a setup for microwell plates or 5cm petri plates
SETUP_VERSION = "Microwell"; // [Microwell, Petri]

// Render all parts
SHOW_ALL = false;

// Show light emitted by the LEDs
Show_light_rays = false;

/* [Main parts display settings] */

Multi_LED_bar = false;
Multi_LED_bar_size= 5; // [3,4,5]

Multiwell_holder = false;
Large_plate_holder = false;
Leg=false;


Camera_plate_A = false;
Camera_plate_B = false;

Central_pillar=false;
Basement=false;
Basement_floor=false;



/* [Secondary parts display settings] */

Petri_adapter = false;
Spacers = false;

Filter_adapter=false;
Filter_adapter_HQ_long=false;
Filter_adapter_HQ_short=false;

Led_solder_mold=false;







/* [Custom Settings] */





//____________ VARIABLES ______________

tolerance = 0.2;

width = 2;
width_cam_plate = 2; //same as width

leg_space = 50.0;


LED_insert_width = 9;


LED_angle = 137;
LED_height = 250;
LED_shift = 90;
LED_viewing_angle = 20;



petri_filler_thickness = 12;

Leg_length=150; // [80:220]


middle_floor_thickness = 4;

pillar_position_1 = [-30,3.65,0];
//pillar_position_2 = 


 // Import Section //
//-------------------//


module mount(){
    
    import("lib/lens_mount.stl");
    
}
// EXTERNAL FILES

use <lib/threads.scad> 
use <lib/basic_shapes.scad>
use <lib/hex-grid.scad>




//____________ PHYSICAL PARAMETERS ______________


large_d = 88.1+tolerance;   // Main petri dish
small_d = 36+tolerance;   // Small petri dishes

large_d_in = 86.8-tolerance;  // Inside diameter main petri dish

external_size = 89;
o = external_size*0.5*0.8;


camera_hole = 9.2+tolerance; // 8mm square
camera_x = 30.0;
camera_screw_centre_offset = 0.0;
camera_screw_x = 12.5;
camera_screw_y = 21.0; // 21mm screw spacing
camera_screw_r = 1.5; // m2
camera_cable_y = 20.0;
camera_cable_h = 1.0;



//____________ GLOBAL VALUES ______________


R_ext = large_d/2;
r = small_d/2+0.1;

R_in = large_d_in/2;


imbrications_size = 1;

space_between_plates = 1.8;

//wall = 2;


sep = 10;

feet_height=40;
feet_width = 6;
feet_center_pos = external_size/2-feet_width/2;

fcp = feet_center_pos;





L=R_in-r;
alpha=(asin(r/L)-45)*2;



//////////////////////////////////////////

if(SHOW_ALL){
    DRAFT_MODE = true;
    show_all();
}
module show_all(){
    

   
  if(SETUP_VERSION == "Petri"){
      translate([0,0,135])large_plate_holder_v2();
      
    translate([0,31.5,0])multi_LED_bar_v3(4);
    mirror([0,1,0])translate([0,31.5,0])multi_LED_bar_v3(4);
    translate([-31.5,0,0])rotate([0,0,90])multi_LED_bar_v3(4);
      
      
  }
  else{
      translate([0,0,135])multiwell_holder();
      
      translate([0,31.5,0])multi_LED_bar_v3(5);
      mirror([0,1,0])translate([0,31.5,0])multi_LED_bar_v3(5);
      translate([-31.5,0,0])rotate([0,0,90])multi_LED_bar_v3(3);
  }
    
  camera_plate();
  rotate([0,0,90]){
    translate([0,0,-90])basement_v2();
    translate([0,0,-110])basement_floor_v2();
  }

    

    
}





module LED_bar_foot(h, shift){
    translate([0,shift,h])mCube(6-tolerance/2,5,95);
    
    // Corners for robustness
    translate([-3,shift-16,h+5])prism(6,15,20);
    
    translate([0,shift-19+12,h])mCube(6,15,6-tolerance/2);
    
    difference(){
        union(){
            translate([0,shift-19-0,h])mCube(6-tolerance*1.5,20,6-tolerance*1.5);
            translate([0,shift-19-2*4-1,h])rotate([0,0,0])cylinder(h=6-tolerance/2,d=10);
        }
        translate([0,shift-19-2*4-1,h])rotate([0,0,0])cylinder(h=200,d=5.4);
    }
}

module LED_bar_foot_rotation(h, shift){

    leg_offset = 12;
    
    translate([leg_offset,shift,h])mCube(6-tolerance/2,5,95);
    
    // Corners for robustness
    translate([5.93,2.95,0])translate([-3,shift-16,h+5])rotate([0,0,-28])prism(5.7,15,20);
    
    //translate([0,shift-19+12,h])mCube(6,15,6-tolerance/2);
    
    difference(){
        union(){
            translate([5.443,shift-19+4.6,h])rotate([0,0,-28])mCube(6-tolerance*1.5,30,6-tolerance*1.5);
            translate([0,shift-19-2*4-1,h])rotate([0,0,0])cylinder(h=6-tolerance/2,d=10);
        }
        translate([0,shift-19-2*4-1,h])rotate([0,0,0])cylinder(h=200,d=5.4);
    }
    
}

module crop_LED_bar(L,width){
    difference(){
        mCube(L,width,13);
        for(m=[0,1]){
            mirror([m,0,0])translate([leg_space,-4,13])rotate([65,0,0])cube(10,10,10);
        }
    }
}

module multi_LED_bar_v3(N, rotate_feet=false){
    
    //bool_64 = -(N-4)*0.5; // 0 si N==6, 1 si N==4
    bool_64 = 0;
    
    //shift = 85+ bool_64*(127.2-85.1)/2;
    //echo(str(shift));
    shift = 74.5+1;
    //x_shift = -bool_64 * 1;
    x_shift = 0;
    width = 5;
    h=135+3+tolerance/2;
    y_space = leg_space;
    
    //angle_0 = 142 - (bool_64*4.5);
    angle_0 = 143;
    
    echo(N);
    echo(angle_0);
    
    pcb_holes_space = 123;
    
    $fn=25;
    
    difference(){
        union(){
            // Main bar
            if(N==5){
                translate([x_shift,shift,230])crop_LED_bar(130,width);
            }
            else{
                translate([x_shift,shift,230])mCube(130,width,13);
            }
            
            
            //LED tubes
            translate([x_shift,shift+5,240])rotate([0,-angle_0+8,90])LED_bar(N);
            
            
            for(m=[0,1]){
                if(N==3){
                    mirror([m,0,0])translate([y_space,-0,0])LED_bar_foot_rotation(h, shift);
                }
                else{
                    mirror([m,0,0])translate([y_space,-0,0])LED_bar_foot(h, shift);
                }
            }
           
            
        }
        
        union(){
        //translate([x_shift,shift,260])rotate([0,-angle_0,90])LED_bar_negative(N);
        translate([x_shift,shift+5,240])rotate([0,-angle_0+8,90])LED_bar_negative(N);
        //translate([x_shift,shift+5,220])rotate([0,-angle_0+13,90])LED_bar_negative(N);
        translate([x_shift,shift+width+width/2,210])mCube(300,width*2,55);
        
        // PCB screw hole
         if(N==3){
             pcb_holes_space = 73;   // if N==3
             translate([pcb_holes_space/2,-31.5+150.25-43,h+95-3])cylinder(h=13, d=1.85);
             mirror([1,0,0])translate([pcb_holes_space/2,-31.5+150.25-43,h+95-3])cylinder(h=13, d=1.8);
         }
         else{  // N==4 or 5
            pcb_holes_space = 123;
            translate([pcb_holes_space/2,-31.5+150.25-43,h+95-3])cylinder(h=13, d=1.85);
            mirror([1,0,0])translate([pcb_holes_space/2,-31.5+150.25-43,h+95-3])cylinder(h=13, d=1.8);
          }
        
        }
    
             
    }
    
    
}
if(Multi_LED_bar){
    translate([0,0,85])
    //for(i=[0,1]){
    for(i=[0]){
mirror([i,0,0])rotate([0,0,90])translate([0,31.5,-86])multi_LED_bar_v3(Multi_LED_bar_size);
    }
}

module LED_bar(N){
    
    if(N==6){
        for(i=[-2.6:2.6]){
            translate([0,i*19,0])
            difference(){
                LED_insert(0);
                LED_insert_negative(0);
            }
        }
    }
    if(N==5){
        for(i=[-1.6:2.6]){
            //translate([0,i*19,0])
            translate([0,-12+i*28,0])
            difference(){
                LED_insert(0);
                LED_insert_negative(0);
            }
        }
    }
    if(N==4){
        for(i=[-1.6:1.6]){
            //translate([0,i*19,0])
            translate([0,i*30,0])
            difference(){
                LED_insert(0);
                LED_insert_negative(0);
            }
        }
    }
    if(N==3){
        for(i=[-0.6:1.6]){
            //translate([0,i*19,0])
            translate([0,-12+i*30,0])
            difference(){
                LED_insert(0);
                LED_insert_negative(0);
            }
        }
    }
    if(N==2){
        for(i=[-0.6:0.6]){
            translate([0,i*19*3.2,0])
            difference(){
                LED_insert(0);
                LED_insert_negative(0);
            }
        }
    }
}
module LED_bar_negative(N){
    
    if(N==6){
        for(i=[-2.6:2.6]){
            translate([0,i*19,0])
                LED_insert_negative(0);
            
        }
    }
    if(N==5){
        for(i=[-1.6:2.6]){
            //translate([0,i*19,0])
            translate([0,-12+i*28,0])
                LED_insert_negative(0);
            
        }
    }
    if(N==4){
        for(i=[-1.6:1.6]){
            translate([0,i*30,0])
                LED_insert_negative(0);
            
        }
    }
    if(N==3){
        for(i=[-0.6:1.6]){
            //translate([0,i*19,0])
            translate([0,-12+i*30,0])
                LED_insert_negative(-8);
            
        }
    }
    if(N==2){
        for(i=[-0.6:0.6]){
            translate([0,i*19*3.2,0])
                LED_insert_negative(0);
            
        }
    }
}

module multiwell_plate(l,w){
    difference(){
        mCube(l,w,21);
        union(){
            for(j=[0:3]){
                for(i=[0:5]){
                    translate([-l/2+14+i*19,-29+j*19,0])cylinder(d=15.5,h=24);
                }
            }
        }
        
    }
    
}

module petri_adapter(){   
    
    mw_length = 127.1;
    mw_width = 85.1;
    $fn=200;
    interspace = 59.5;
    H = 1.5;
    his = interspace/2;
    difference(){
        
        mCube(mw_length,mw_width,H);
        j=1;
        for(i=[-1,1]){
                    translate([his*i,12*i,0])cylinder(d=54.8,h=H);
                    translate([his*i,12*i,0.8])cylinder(d=58,h=H+1);
        }
    }
    
    
    
}if(Petri_adapter){petri_adapter();}




module multiwell_holder() {
    // Base dimensions for microwell plate
    mw_length = 127.1;           // Base length for microwell plates
    mw_width = 85.1;             // Base width for microwell plates
    tolerance = 0.5;             // Tolerance to accommodate different plate sizes

    // Holder dimensions
    holder_width = 3;            // Thickness of the holder walls
    holder_thickness = 2;        // Thickness of the holder base
    inside_width = 4;            // Inner width adjustment
    ext_border_width = 52;       // Width of the external border
    side_width = 23;             // Width for the side sections
    width_walls_holder = 8;
    height_walls_holder = 2;

    // Adjust dimensions based on tolerance
    mw_length_tol = mw_length + 2 * tolerance + 1.0;
    mw_width_tol = mw_width + 2 * tolerance + 0.5;

    if (DRAFT_MODE) {
        rotate([0, 0, 180]) multiwell_plate(mw_length_tol, mw_width_tol);
    }

    difference() {
        union() {
            // Middle part of the holder with adjusted dimensions
            translate([0, 0, holder_thickness])
                thick_rectangle(mw_length_tol, mw_width_tol, holder_width, 3);

            thick_rectangle(mw_length_tol - inside_width, mw_width_tol - inside_width, holder_width + inside_width, 1);

            difference() {
                // Outer border with holes
                thick_rectangle(mw_length_tol, mw_width_tol, ext_border_width, holder_thickness);
                for (i = [0]) {
                    for (j = [0]) {
                        coef = 4;
                        translate([coef * i, coef * j, 0]) multiwell_holes_circle();
                    }
                }
            }
        }

        union() {
            // Side holders using mCube
            for (m1 = [0, 1]) {
                mirror([m1, 0, 0])
                    translate([33, 0, 0]) 
                        mCube(42, mw_width_tol, holder_width);
                mirror([0, m1, 0])
                    translate([0, 20, 0]) 
                        mCube(mw_length_tol, 26, holder_width);

                for (m2 = [0, 1]) {
                    mirror([0, m1, 0]) 
                        mirror([m2, 0, 0])
                            translate([-(mw_length_tol + ext_border_width) / 2, (mw_width_tol + ext_border_width) / 2 - 15, 4])
                            rotate([0, 90, 0]) 
                            prism(10, 15, 20);
                }
            }

            // Text for labeling
            translate([-42, mw_width_tol / 2 + 8, holder_thickness - 0.6])
                linear_extrude(5) text("WormStation", font = "Helvetica:style=Bold");

            translate([-33.5, -(mw_width_tol / 2 + 8 + 9.5), holder_thickness - 0.4])
                linear_extrude(5) text("LPBS - EPFL", font = "Helvetica:style=Bold", size = 8);
        }
    }
}
if(Multiwell_holder){translate([0,0,50]){
        intersection(){
            multiwell_holder();
            //translate([0,0,0])mCube(134,92,10);
        }
    }
}




module large_plate_holder_v2(){
    
    $fn=250;
    
    position_camera = [external_size/2-27.9,-external_size/2 + 18.1,0];
    
    mw_length = 120.6 + 2*tolerance;
    mw_width = 120.6 + 2*tolerance;
    
    holder_width = 3;
    
    holder_thickness = 2;
    inside_width = 4;
    
    ext_border_width = 56;
    
    side_length = mw_width + holder_width;
    side_width = 23;
    
    width_walls_holder = 8;
    height_walls_holder = 2;
    
    if(DRAFT_MODE){
        //rotate([0,0,180])multiwell_plate(mw_length,mw_width);
        //mCube(120,120,1);
        //translate(position_camera)cylinder(d=55,h=10);
        for(i=[0,1],j=[0,1]){
            mirror([i,0,0])mirror([0,j,0])
            translate([28.8,30,0])
            difference(){
                    cylinder(d=55,h=10);
                    cylinder(d=2,h=10);
            }
        }
    }
    
    
    
    
    difference(){
        union(){
            // middle part
            //translate([0,0,holder_thickness])thick_rectangle(mw_length, mw_width, holder_width, 3);
            thick_rectangle(mw_length-inside_width, mw_width-inside_width, holder_width+inside_width, holder_thickness);
            difference(){
                //mCube(mw_length, mw_width+ext_border_width, ext_border_width+ext_border_width, holder_thickness);
                //thick_rectangle(mw_length, mw_width, ext_border_width, holder_thickness);
                mCube(mw_length+ext_border_width, mw_width+ext_border_width, holder_thickness);
                for(i=[0]){
                    for(j=[0]){
                        coef = 4;
                        translate([coef*i,coef*j,0])large_plate_holes_circle();
                    }
                }
            }
            
            // little side barriers
            for(i=[0,1],j=[0,1]){
                mirror([i,0,0])mirror([0,j,0])
                translate([30,30,0])
                {
                        translate([0,0,2])rotate([0,0,-60])rotate_extrude(angle=360)translate([58/2,0,0])square([1,1]);
                    
                    //translate([0,0,2])rotate([0,0,210])rotate_extrude(angle=50)translate([58/2,0,0])square([1,1]);
                }
            }
             

        }
        union(){
            
            
            // petri holes
            for(i=[0,1],j=[0,1]){
                mirror([i,0,0])mirror([0,j,0])
                
                // /!\ Slightly off axis with camera !!
                // move by 1.2mm along x-axis to center
                
                translate([30,30,0])
                {
                        translate([0,0,1])cylinder(d=58.6,h=10);
                        cylinder(d=55,h=10);
                }
            }
           
            
            for(m1=[0,1]){
                //mirror([m1,0,0])translate([41.3,0,0])mCube(8.5,mw_width,holder_width);
                //mirror([0,m1,0])translate([0,22.3,0])mCube(mw_length,8.5,holder_width);
                
                for(m2=[0,1]){
                    mirror([0,m1,0])mirror([m2,0,0])translate([-(mw_length+ext_border_width)/2,(mw_width+ext_border_width)/2-15,4])rotate([0,90,0])prism(10,15,20);
                }
            }
            
            translate([-42,mw_width/2+8,holder_thickness-0.6])linear_extrude(5)text("WormStation",font="Helvetica:style=Bold");
            
            translate([-33.5,-(mw_width/2+8+9.5),holder_thickness-0.4])linear_extrude(5)text("LPBS - EPFL",font="Helvetica:style=Bold", size=8);
            
        }
    }
    
}if(Large_plate_holder){translate([0,0,50]){
    intersection(){
        large_plate_holder_v2();
        //mCube(166,166,100);
    }
    }
}

//leg();
//$fn=50;
//cylinder(d=5.1,h=150);

module leg(H=150){
    // currently 150 + 130    
    $fn=6;
    difference(){
        cylinder(d=8.5,h=H);
        cylinder(d=6.2,h=H);
    }
    
}if(Leg){leg(Leg_length);}

/*
pillarX1 = 30;
pillarY1 = 3.65;

pillarX2 = 45;
pillarY2 = 18;
*/

pillarX1 = 33.5;
pillarY1 = -9.5-leg_space+55;

pillarX2 = 24 -leg_space + 55;
pillarY2 = 3.1-leg_space+55;

pillarY2_chemotx = 3.1-leg_space+55+21;



module multiwell_holes_circle(offset=0){
    $fn=25;
    D = 5.4;
    for(i=[0,1]){
        position_hole = [external_size/2+space_between_plates/2,external_size/2+space_between_plates/2+offset/2,0]-[-pillarX1,pillarY1,0]+[-pillarX2,pillarY2,0]*i;
        translate(position_hole)cylinder(d=D,h=5);
        mirror([1,0,0])translate(position_hole)cylinder(d=D,h=5);
        mirror([0,1,0]){
            translate(position_hole)cylinder(d=D,h=5);
            mirror([1,0,0])translate(position_hole)cylinder(d=D,h=5);
        }
    }
}

module large_plate_holes_circle(offset=0){
    $fn=25;
    D = 5.4;
    
    translate([0,0,0])
    for(i=[0,1]){
        position_hole = [external_size/2+space_between_plates/2,external_size/2+space_between_plates/2+offset/2,0]-[-pillarX1,pillarY1,0]+[-pillarX2,pillarY2_chemotx,0]*i;
        translate(position_hole)cylinder(d=D,h=5);
        mirror([1,0,0])translate(position_hole)cylinder(d=D,h=5);
        mirror([0,1,0]){
            translate(position_hole)cylinder(d=D,h=5);
            mirror([1,0,0])translate(position_hole)cylinder(d=D,h=5);
        }
    }
}

module camera_plate_HQ(orientation){
    position_camera = [external_size/2-27.9,-external_size/2 + 18.1,0];
    //position_camera = [0,0,0];
    
    rotation_servo = [0,0,90];
    
    width_side_walls = 1;
    
    
    difference(){
        union(){
            // Base
            mCube(external_size,external_size,width);
            
            
            // lil legs for cam
            translate(position_camera + [0,0,width_cam_plate])
            rotate([0,0,90])
            mirror([orientation,0,0])
                camera_mount_HQ();
            
        }
        union(){
            translate([-pillarX1,-pillarY1,0])rotate([0,0,90])pillar_hole();
            translate([-pillarX1,-pillarY1,0]+[pillarX2,pillarY2,0])rotate([0,0,0])pillar_hole();
            
            
            translate(position_camera)mirror([orientation,0,0]){
                //rotate([0,0,90])camera_mount_holes();
                //rotate([0,0,-90])camera_mount_holes();
                camera_mount_holes_HQ();
            }
            
            
            // hole for the camera cable
            translate(position_camera)translate([0,30,0])mCube(20,5,3);

            
            cam_plate_feet_holes();
            
        }
    }
}

module camera_plate_camV2(orientation){
    position_camera = [external_size/2-27.9,-external_size/2 + 18.1,0];
    //position_camera = [0,0,0];
    
    rotation_servo = [0,0,90];
    
    width_side_walls = 1;
    
    difference(){
        union(){
            // Base
            mCube(external_size,external_size,width);
            
            
            translate(position_camera + [0,0,width_cam_plate])
            rotate([0,0,90])
            mirror([orientation,0,0]){
                camera_mount();
                //cylinder(d=28,h=100);
            }
            if(DRAFT_MODE){
                translate(position_camera + [0,0,width_cam_plate+13])
                cylinder(h=27,d=28);
            }
            
            //translate(position_camera)cam_stab();
        }
        union(){
            translate(position_camera)mirror([orientation,0,0]){
                
                rotate([0,0,90])camera_mount_holes();
                rotate([0,0,-90])camera_mount_holes();
            }
            
            
            // Pillars holes
            translate([-pillarX1,-pillarY1-11,0])rotate([0,0,90])pillar_hole();
            translate([-pillarX1,-pillarY1-11,0]+[pillarX2,pillarY2_chemotx,0])rotate([0,0,0])pillar_hole();
            
            
            cam_plate_feet_holes();
            
        }
    }
    
}


module pillar_hole(){
    $fn=25;
    color("plum")cylinder(d=5.4,h=170);
}


module camera_plate(){
    
    
      if(SETUP_VERSION == "Petri"){
      
      
      
          translate([0,external_size/2+space_between_plates/2,0]){
        
        translate([-external_size/2-space_between_plates/2,11,0]){
            camera_plate_A();
            //translate([0,0,-feet_height])feet_v4();
        }
        rotate([0,0,180])translate([-external_size/2-space_between_plates/2,external_size+space_between_plates+11,0]){
            camera_plate_A();
            //translate([0,0,-feet_height])feet_v4();
        }
        translate([external_size/2+space_between_plates/2,11,0]){
            camera_plate_B();
            //translate([0,0,-feet_height])feet_v4();
        }
        rotate([0,0,180])translate([-external_size/2-space_between_plates/2+(external_size+space_between_plates),external_size+space_between_plates+11,0]){
            camera_plate_B();
            //translate([0,0,-feet_height])feet_v4();
        }
        
    }


      
      
  }
  else{      
      
          translate([0,external_size/2+space_between_plates/2,0]){
        
        translate([-external_size/2-space_between_plates/2,0,0]){
            camera_plate_A();
            //translate([0,0,-feet_height])feet_v4();
        }
        rotate([0,0,180])translate([-external_size/2-space_between_plates/2,external_size+space_between_plates,0]){
            camera_plate_A();
            //translate([0,0,-feet_height])feet_v4();
        }
        translate([external_size/2+space_between_plates/2,0,0]){
            camera_plate_B();
            //translate([0,0,-feet_height])feet_v4();
        }
        rotate([0,0,180])translate([-external_size/2-space_between_plates/2+(external_size+space_between_plates),external_size+space_between_plates,0]){
            camera_plate_B();
            //translate([0,0,-feet_height])feet_v4();
        }
        
    }
    

    
  }
  
    
}


module camera_plate_A(){
    //position_raspberry = [-26,-9.5,0];    // no HQ
    position_raspberry = [-23,-10.5,0];      // HQ
    difference(){
        if(SETUP_VERSION == "Petri"){
            camera_plate_camV2(orientation = 0);  // plate A
        }
        else{
            camera_plate_HQ(orientation = 0);  // plate A
        }
        rotate([0,0,90])
            translate(position_raspberry)
                raspberry_holes();
        translate([-40,20,width-0.6])linear_extrude(0.6)text("A", size=20);
    }
    
}if (Camera_plate_A){
    //translate([-external_size/2-space_between_plates/2,0,0])camera_plate_A();
    translate([-external_size/2-space_between_plates/2,+external_size/2+space_between_plates/2,0])camera_plate_A();
    
    }


module camera_plate_B(){
    position_raspberry = [-26,-9.5,0];
    difference(){
        if(SETUP_VERSION == "Petri"){
            mirror([1,0,0])camera_plate_camV2(orientation = 1); // plate B
        }
        else{
            mirror([1,0,0])camera_plate_HQ(orientation = 1); // plate B
        }
        
        rotate([0,0,00])
            translate(position_raspberry)
                raspberry_holes();
        
        translate([20,20,width-0.6])linear_extrude(0.6)text("B", size=20);
    }
    

}if (Camera_plate_B){
    //translate([external_size/2+space_between_plates/2,0,0])camera_plate_B();
    translate([external_size/2+space_between_plates/2,external_size/2+space_between_plates/2,0])camera_plate_B();
    }


   
//camera_mount_holes();


module camera_mount(){
    $fn=20;
    translate([-11.9,0,0])mCube(11,28,4.5);
    translate([11.9,0,0])mCube(11,28,4.5);
    cylinder(h=3.5,d=16);
    rotate([0,0,90])mount();
}

module camera_mount_HQ(){
    l= 38/2-4;
    $fn=25;
    //translate([-11.9,0,0])mCube(11,28,3.5);
    //translate([11.9,0,0])mCube(11,28,3.5);
    //cylinder(h=3.5,d=16);
    d_in = 3;
    d_out=6;
    h=6;
    difference(){
        union(){
            translate([l,l,0])cylinder(d=d_out,h=h);
            translate([l,-l,0])cylinder(d=d_out,h=h);
            translate([-l,l,0])cylinder(d=d_out,h=h);
            translate([-l,-l,0])cylinder(d=d_out,h=h);
        }
        union(){
            translate([l,l,0])cylinder(d=d_in,h=h);
            translate([l,-l,0])cylinder(d=d_in,h=h);
            translate([-l,l,0])cylinder(d=d_in,h=h);
            translate([-l,-l,0])cylinder(d=d_in,h=h);
        }
    }
}

module camera_mount_holes_HQ(_width=width_cam_plate){
    
    l= 38/2-4;
    //translate([0,0,1])mCube(38,38,1);
    $fn=25;
    translate([l,l,0])cylinder(d=3,h=_width);
    translate([l,-l,0])cylinder(d=3,h=_width);
    translate([-l,l,0])cylinder(d=3,h=_width);
    translate([-l,-l,0])cylinder(d=3,h=_width);
}


module camera_mount_holes(_width=width_cam_plate){
    $fn=150;
    if(DRAFT_MODE){
        $fn=20;
    }
    
    l = 6.4;
    
    rotate([0,0,0])union(){

        translate([-8.8/2-8/2,0,0])mCube(8,8.6,2);
        translate([-8.8/2-8+5.6/2,-9+7.6,0])mCube(5.6,9,2);
        
        
        translate([0,0,0])cylinder(d=7.5,h=10);
        intersection(){
            rotate([0,0,45])mCube(7.5,7.5,10);
            mCube(9.4,9.4,10);
        }
        translate([-camera_hole/2,-camera_hole/2,])union(){
            cube([camera_hole,camera_hole,2.6]);
            

            translate([camera_hole/2,-((camera_screw_y/2)-(camera_hole/2)),0])
            {

                    cylinder(d=1.8,h=l);
                    translate([0,camera_screw_y,0])cylinder(d=1.8,h=l);
                
            }
            
            translate([camera_hole/2-12.5,-((camera_screw_y/2)-(camera_hole/2)),0])
            {

                    cylinder(d=1.8,h=l);
                    translate([0,camera_screw_y,0])cylinder(d=2,h=l);
               
            }
        
    }
        
    }
    
    
     
}
module cam_plate_feet_holes(){
    $fn=20;
    translate([ external_size, external_size,0]*0.5-[3,3,0])cylinder(d=2.4,h=10);
    translate([ external_size,-external_size,0]*0.5-[3,-3,0])cylinder(d=2.4,h=10);
    translate([-external_size, external_size,0]*0.5-[-3,3,0])cylinder(d=2.4,h=10);
    translate([-external_size,-external_size,0]*0.5-[-3,-3,0])cylinder(d=2.4,h=10);
}

module raspberry_holes(){
    $fn=20;
    translate([external_size/2,49/2,0])cylinder(d=2.9,h=width);
    translate([external_size/2,-49/2,0])cylinder(d=2.9,h=width);

    translate([external_size/2-58,49/2,0])cylinder(d=2.9,h=width);
    translate([external_size/2-58,-49/2,0])cylinder(d=2.9,h=width);
}




module LED_insert(LED_angle=LED_angle, c = "plum"){
    HH=100;
    //difference(){
        union(){
            translate([-LED_insert_width*sin(LED_angle),0,-LED_insert_width/2*sin(LED_angle)])rotate([0,LED_angle,0])translate([0,0,0]){
                if(Show_light_rays){
                color(c,0.1){
                translate([0,0,8])cylinder(r1=0,r2=HH*sin(LED_viewing_angle),h=HH);
                }}
                difference(){
                
                
                    $fn=25;
                    
                    cylinder(d=LED_insert_width,h=12.5);
                    
                    //translate([0,0,0])cylinder(d=5.8+tolerance,h=8);
                    //translate([0,0,0])cylinder(d=5.0+tolerance,h=100);
                }
                //translate([0,0,-5])LED_holes(20);
            }
        }
            //translate([0,0,-10])cylinder(d=100,h=10);
    //}
    //translate([0,0,-5])LED_holes(20);
}
//LED_insert_v2_negative();
module LED_insert_negative(LED_angle=LED_angle){
    
    //difference()
    {
        union(){
            translate([-LED_insert_width*sin(LED_angle),0,-LED_insert_width/2*sin(LED_angle)])rotate([0,LED_angle,0])translate([0,0,0])difference(){
                union(){
                    $fn=25;
                    translate([0,0,-10])cylinder(d=6+tolerance,h=8+10);
                    
                translate([0,0,0])cylinder(d=4.9+tolerance,h=100);
                    
                }
                //cylinder(d=LED_insert_width,h=17);
                
                //translate([0,0,-5])LED_holes(20);
            }
        }
            //translate([0,0,-10])cylinder(d=100,h=10);
    }
    //translate([0,0,-5])LED_holes(20);
} 







module filter_adapter(){
    
    $fn=200;
    
    d_out=28;
    d_in=25;
    h=8;
    h_filter=0;
    width=1.5;
    
    difference(){
        cylinder(d=d_out+width*2,h=h);
        
        cylinder(d=d_out+0.2,h=h-h_filter);
        //cylinder(d=d_in-0.4,h=h-2);
        translate([0,0,h-h_filter])cylinder(d=d_in+0.5,h=h_filter);
    }
    
    translate([0,0,h-0.4])difference(){
        cylinder(d=d_out+width*2,h=0.4);
        cylinder(d=d_in-0.6,h=0.4);
    }
}if(Filter_adapter){rotate([0,180,0])filter_adapter();}




module filter_adapter_HQ_long(){
    
    $fn=150;
    h=5;
    
    outer_d=32.1;
    filter_d=25.4;
    
    difference(){
        union(){
            cylinder(d=outer_d,h=h);
            translate([0,14,5])rotate([90,0,0])cylinder(d=6,h=28);
        }
        
        translate([0,0,1])cylinder(d=filter_d+0.6,h=10);
        cylinder(d=filter_d-0.5,h=10);
        
    }
    
    
    
    
}if(Filter_adapter_HQ_long){rotate([0,0,0])filter_adapter_HQ_long();}


module filter_adapter_HQ_short(){
    
    $fn=150;
    h=4;
    
    outer_d=30-0.4;
    filter_d=25.4;
    
    difference(){
        union(){
            cylinder(d=outer_d,h=h);
            translate([0,14,h])rotate([90,0,0])cylinder(d=6,h=28);
        }
        
        translate([0,0,1])cylinder(d=filter_d+0.6,h=10);
        cylinder(d=filter_d-0.4,h=10);
        
    }
    
    
    
    
}if(Filter_adapter_HQ_short){rotate([0,0,0])filter_adapter_HQ_short();}




module camera_holes(_width){
    
    
   // translate([(base_length+((wall+tol)*2))/2-tol-wall,1.7*base_width,2])
       //     rotate([0,0,90]) cs_mount();
    l = _width+3;
    
    rotate([0,0,0])union(){
        /*
         translate([-camera_hole/2-8.4/2,0,0])mCube(9,9,2.4);
        translate([-camera_hole/2-9+4.8/2,-9+7.6,0])mCube(4.8,9.2,2.4);
        */
        translate([-8.8/2-8/2,0,0])mCube(8,8.6,2);
        translate([-8.8/2-8+5.6/2,-9+7.6,0])mCube(5.6,9,2);
        
        translate([-camera_hole/2,-camera_hole/2,])union(){
            cube([camera_hole,camera_hole,2.4]);

            translate([camera_hole/2,-((camera_screw_y/2)-(camera_hole/2)),0])
            {
                //cylinder(_width,camera_screw_r,camera_screw_r);
                //translate([0,camera_screw_y,0]) cylinder(_width,camera_screw_r,camera_screw_r);
                if(!DRAFT_MODE){
                    metric_thread(diameter=2, pitch=0.4,length=l,internal=true);
                    translate([0,camera_screw_y,0])metric_thread(diameter=2, pitch=0.4,length=l,internal=true);
                }
                else{
                    cylinder(d=2,h=l);
                    translate([0,camera_screw_y,0])cylinder(d=2,h=l);
                }
            }
            
            translate([camera_hole/2-12.5,-((camera_screw_y/2)-(camera_hole/2)),0])
            {
                //cylinder(_width,camera_screw_r,camera_screw_r);
                //translate([0,camera_screw_y,0]) cylinder(_width,camera_screw_r,camera_screw_r);
                if(!DRAFT_MODE){
                    translate([0,camera_screw_y,0])metric_thread(diameter=2, pitch=0.4,length=l,internal=true);
                    metric_thread(diameter=2, pitch=0.4,length=l,internal=true);
                }
                else{
                    cylinder(d=2,h=l);
                    translate([0,camera_screw_y,0])cylinder(d=2,h=l);
                }
            }
        
    }
        
    }
    
    
     
}








module feet_rect(x,y){
    translate([-y/2,0,0])foot_side(x);
    translate([y/2,0,0])rotate([0,0,180])foot_side(x);
    translate([0,-x/2,0])rotate([0,0,90])foot_side(y);
    translate([0,x/2,0])mCube(x,width*2,width*2);//rotate([0,0,-90])foot_side(y);
}
module feet(x){
    feet_rect(x,x);
}





module switch(w){
    // LS1005G
    
    
    //mCube(76,4,w);
    
    for(i=[0,1]){
        
        difference(){
            union(){
        
                translate([0,57.5*i,0])mCube(86,6,w);
                mirror([i,0,0]){
                    translate([-75/2-0.4-0.5,2.5+10+0.2,w]){
                        rotate([0,0,90])pcb_clip(5,3);
                        translate([-1.25,0,-w])mCube(4,5,w);
                    }
                    translate([82/2,63/2-1.5,0])mCube(4,59,w);
                    translate([70/2,57.5,0]){
                            mCube(6,6,w+2);
                            //translate([0,0,w-6])cylinder(d=1.8,h=8);
                        
                        

                    }
                }
            }
            union(){
                mirror([i,0,0]){
                    translate([70/2,57.5,0]){

                            translate([0,0,w-6])cylinder(d=1.8,h=8);
                        
                    }
                }
            }
        }
 
        
    }
    
    //translate([-75/2-0.2,2.25+9+0.2,w])rotate([0,0,90])pcb_clip(4.5,1);
    
}

module pcb_clip(l,pcb_h){
    $fn=20;
    
    thickness=1.5;
    
    prism_size=0.5;
    
    pcb_h=pcb_h+0.3;
    translate([-l/2,-thickness/2-prism_size,pcb_h+1]){
        prism(l,prism_size,1);
        mirror([0,0,1])prism(l,prism_size,1);
        translate([0,prism_size+thickness,1])rotate([-90,0,0])prism(l,pcb_h+2,3);
        
    }
    translate([-0,0,0])mCube(l,thickness,pcb_h+2);
    //translate([-l/2,-0.5,pcb_h+1])rotate([0,90,0])cylinder(d=2,h=l);
}

module c14_inlet(w,l=14){
    
    translate([-20,0,0])c14_inlet_single_side(w,l);
    mirror([1,0,0])translate([-20,0,0])c14_inlet_single_side(w,l);
    
}

//c14_inlet_single_side(w=6,l=14);
module c14_inlet_single_side(w,l){
    
    $fn=25;
    translate([3,2,-w])mCube(16,l,w);
    difference(){
        translate([0,(l-10)/2,0])mCube(10,l,22.5);
        translate([-2,1+(l-10)/2,0])mCube(10,l-2,20);
        translate([0,5,9.5])rotate([90,0,0])cylinder(d=3.5,h=30);
        translate([0,1,0])cylinder(d=2.7,h=40);


    }
    
    translate([-5,-5,20])rotate([180,0,90])prism(l,8,8);
    translate([11,-5,0])rotate([0,0,90])prism(l,6,6);
}



//back_wall(180,60,6,10,6,true,50,30);
module back_wall(length,height,thickness, grid_size, pillar_width,fan_holes=false, fan_size=50,fan_height=0){
    
    tolerance=0.25;
    fan_size=fan_size+tolerance;
    
    diff=fan_height/2+height/2-1.5;
    
    fan_position=[height/2-fan_size/2-fan_height,length/4,0];
    
    texts=["EPFL - LPBS", "Wormstation"];
    
    rotate([0,90,90]){
        if(fan_holes){
            difference(){
                translate([0,0,thickness/2])create_grid(size=[height,length,thickness],SW=grid_size,wall=2,ext_walls=pillar_width);
                for(i=[0,1]){
                    mirror([0,i,0])translate(fan_position)mCube(fan_size,fan_size,thickness);
                }
                
            }
            for(i=[0,1]){
                mirror([0,i,0])translate(fan_position){
                    fan_mount(fan_size,fan_height, texts[i],i);

                }
            }
        }
        else{
            create_grid(size=[height,length,thickness],SW=grid_size,wall=2,ext_walls=6);
        }
       
        
    }
    
}

//fan_mount(50,30, "Wormstation",1);

module fan_mount(fan_size, fan_height, base_text, text_orientation){
    
    hole_dist = fan_size-10-0.2;
    hole_shift = hole_dist/2;
    
    fan_width=13.5;
    back_width=3;
    ext_wall_thickness=3;
    
    // Just to measure how much the fan goes under the rpi (shouldn't more than 12mm)
    //translate([-24,-200,-15])mCube(10,20,20);
    
    square3D(fan_size,fan_size,fan_width,ext_wall_thickness,inner=true);
    
    difference(){
        translate([fan_size/2+fan_height/2,0,0])mCube(fan_height,fan_size+ext_wall_thickness*2,fan_width);
        
        
        
        mirror([0,text_orientation,0])translate([fan_size/2+fan_height/2,0,fan_width-1])rotate([0,0,90])linear_extrude(1)text(base_text,size=6,halign="center",valign="center");
    }
    
    
    //translate([fan_size/2,hole_shift-5,0])mCube(15,6,100);
    
    
    difference(){
        union(){
            translate([0,0,fan_width-0.5])create_grid(size=[fan_size,fan_size,1],SW=6,wall=1.5,ext_walls=1);
            
            translate([0,0,fan_width-back_width])
            difference(){
                mCube(fan_size,fan_size,back_width);
                cylinder(d=51,h=back_width);
            }
        }
        
        union(){
            for(i=[0,1]){
                for(j=[0,1]){
                    mirror([i,0,0])mirror([0,j,0])
                    translate([hole_shift,hole_shift,0])cylinder(d=3.1,h=fan_width);
                    //translate([15,0,0])mCube(6,3,1);
                }
            }
        }
    }
    
}

//central_pillar(60);
module central_pillar(height){
    
    
    
    difference(){
        translate([0,0,6])mCube(9,9,height-6);
        translate([0,0,height-6])cylinder(d=1.8,h=6);
        translate([0,0,6])cylinder(d=1.8,h=10);
    }
    for(i=[0:3]){
        rotate([0,0,90*i])translate([-4.5-25,0,height-21])
        difference(){
            rotate([90,0,0])cropped_triangle([50,42,9],center=true);
            translate([25+4.5-14,0,height/2-15])cylinder(d=1.8,h=6);
            translate([6,0,height/2-18])mCube(9,9,9);
            
        }
        
    

    }
}if(Central_pillar){central_pillar(60);}

//translate([10,-300,-46])mCube(5,5,11+4);

module basement_floor_v2_no_holes(L,l,width,pillar_width,height, grid_size, power_supply_vertical_offset,power_supply_horizontal_offset,screw_pos,pcb_height,pcb_pillars_positions, fan=true, fan_height){
    

    
    // Floor
    translate([0,0,width/2])create_grid(size=[l,L,width],SW=grid_size,wall=2);
    square3D(l,L,width,pillar_width, inner=false);
    
    // Central pillar
    cylinder(d=14,h=width, $fn=6);
    //mCube(9,9,height);
    //central_pillar(height);
    

    
    // External walls (sides)
    translate([l/2-pillar_width/2,0,height/2])rotate([0,90,0])create_grid(size=[height,L,pillar_width],SW=grid_size,wall=2, ext_walls=pillar_width);
    
    mirror([1,0,0])translate([l/2-pillar_width/2,0,height/2])rotate([0,90,0])create_grid(size=[height,L,pillar_width],SW=grid_size,wall=2,ext_walls=pillar_width);
    
    // hole to access c14 screw
    hole_width=30;
    translate([-l/2,-L/2+hole_width/3+pillar_width,pillar_width+hole_width/2-4])rotate([0,90,0])
    difference(){
        cylinder(h=pillar_width, d=hole_width,$fn=6);
        cylinder(h=pillar_width, d=hole_width-6,$fn=6);
        
    }
    
    // back wall
    translate([0,L/2-pillar_width,height/2])back_wall(l,height,pillar_width, grid_size, pillar_width,fan ,fan_height=fan_height);
    
    
    // Stage for power supply (UHP-200A-5)
    translate(power_supply_horizontal_offset){
        translate([0,0,power_supply_vertical_offset/2+width/2])
        create_grid(size=[55,167,power_supply_vertical_offset+width],SW=grid_size,wall=2, x_offset=-6.375,y_offset=3);
        
        // screw cylinder & holes
        for(i=[0,1]){
            for(j=[0,1]){
                mirror([i,0,0])
                mirror([0,j,0])
                translate(screw_pos){
                    cylinder(d=10,h=power_supply_vertical_offset+width);
                }
            }
        }
        
        translate([0,-L/2+8,width])c14_inlet(w=width);
        
    }
    
    // switch holder
    if(width<7){        
        translate([14,-L/2+6,0])switch(7);
    }
    else{
        translate([14,-L/2+6,0])switch(width);
    }
    

    
    // pcb_pillars
    translate([13,-34.25,0])
    translate([80,177.25,0]){
        for(i=[0:3]){
            translate(pcb_pillars_positions[i]){
                //mCube(6,6,pcb_height);
                
                cylinder(d=14,h=pillar_width, $fn=6);
                difference(){
                    cylinder(d=8,h=pcb_height, $fn=6);
                    translate([0,0,pcb_height-9])cylinder(d=1.8,h=9);
                }
                //cylinder(d=2.7,pcb_height+4);
            }
        }
    }
    
    
    
}

module basement_floor_v2_holes(L,l,width,pillar_width,height, grid_size, power_supply_vertical_offset,power_supply_horizontal_offset,screw_pos,pcb_height,pcb_pillars_positions,fan_height){
    
        $fn=20;
    
        // Holes for screws
        // Power supply screws
        translate(power_supply_horizontal_offset)
        for(i=[0,1]){
            for(j=[0,1]){
                mirror([i,0,0])
                mirror([0,j,0])
                translate(screw_pos){
                    
                    cylinder(d=3.5,h=power_supply_vertical_offset+width);
                    
                    cylinder(d=6.5,h=power_supply_vertical_offset+width-2);
                }
                
                
            }
        }
        cylinder(d=2.1,h=pillar_width);
        cylinder(d=5,h=pillar_width-2);
        
        // hole to access c14 screw
        hole_width=30;
        translate([-l/2,-L/2+hole_width/3+pillar_width,pillar_width+hole_width/2-4])rotate([0,90,0])cylinder(h=pillar_width, d=hole_width-6, $fn=6);
        
        //translate([l/4,L/2+7.5,fan_height/2])rotate([90,0,180])linear_extrude(1)text("Wormstation",size=6,halign="center",valign="center");
        //translate([-l/4,L/2+7.5,fan_height/2])rotate([90,0,180])linear_extrude(1)text("LPBS - EPFL",size=6,halign="center",valign="center");
    
        
}



module basement_floor_v2(){
    
    
    L=210;
    l=180;
    width=5;
    pillar_width = 5;
    
    height=60;
    
    grid_size=10;
    
    pcb_pillar_temp_shift = 1.5;
    pcb_pillars_positions=-[[18,50+1.5,0],[17,240.5+1.5,0],[115,159+1.5,0],[115,101+1.5,0]];
    
    power_supply_vertical_offset=15-6+0.8;
    
    power_supply_horizontal_offset=[-56,-2.8,0];
    
    pcb_height=power_supply_vertical_offset+16;
    
    // power supply relative screw positions
    screw_pos=[21,79.25,0];
    
    fan_height=20;
    
    
    difference(){
        
        basement_floor_v2_no_holes(L,l,width,pillar_width,height, grid_size, power_supply_vertical_offset,power_supply_horizontal_offset,screw_pos,pcb_height,pcb_pillars_positions, fan=true,fan_height=fan_height);
        
        basement_floor_v2_holes(L,l,width,pillar_width,height, grid_size, power_supply_vertical_offset,power_supply_horizontal_offset,screw_pos,pcb_height,pcb_pillars_positions,fan_height);
        
        translate([0,0,height-10])screw_holes_basement(L,l,pillar_width);
        
    }
    
    
    
    
    //translate([-84,-l/2+50,100])cube([0.5,100,10]);
    
    
}if(Basement_floor){
    /*
    if(SETUP_VERSION == "Petri"){
        translate([0,0,-100])basement_floor(200,180,4, 6);
    }
    else{
        translate([0,0,-100])basement_floor(200,180,4, 6);
    }
    */
    translate([0,0,-105.5])basement_floor_v2();
}



module screw_holes_basement(L,l,w){
    
    h=12;
    
    positions=[[l/2-w/2,L/4,0],[l/2-w/2,L/2-w/2,0],[0,L/2-w/2,0]];
    
    for(p=positions){
        for(i=[0,1]){
            for(j=[0,1]){
                mirror([i,0,0])
                mirror([0,j,0])
                translate(p){
                    cylinder(d=1.8,h=h);
                    translate([0,0,h-1])cylinder(d=4.2,h=1);
                }
            }
        }
    }
    
}

//translate([0,0,-150])central_pillar(60);

module basement_no_holes_v2(L,l,width,pillar_width, grid_size){
    // Single big foot
    
    space_1st_layer=30+width+0.5+5+5;
    
    //basement_floor(L,l,width, pillar_width);

    translate([0,0,space_1st_layer]){
        
        // Middle grid
        translate([0,0,middle_floor_thickness/2])middle_floor(L,l,pillar_width);    
        
        
        
        for(i=[-1,1]){
            for(j=[-1,1]){
                
                if(SETUP_VERSION == "Petri"){
                translate([i*(external_size/2+space_between_plates/2),j*(external_size/2+11),0])feet_v6();
                }
                else{
                    translate([i*(external_size/2+space_between_plates/2),j*(external_size/2+1),0])feet_v6();
                }
                

            }
        }
        for(k=[0,1],l=[0,1]){
            if(SETUP_VERSION == "Petri"){
                mirror([0,l,0])translate([0,14+k*(external_size-6),0])mCube(4,6,feet_height);
            }
            else{
                mirror([0,l,0])translate([0,4+k*(external_size-6),0])mCube(4,6,feet_height);
                rotate([0,0,90])mirror([0,l,0])translate([0,4+k*(external_size-6),0])mCube(4,6,feet_height);
            }
           
            
        }
        
        
        
    }
    
    
}
module basement_v2(){
    
    width = 4;
    pillar_width = 5;
    $fn=25;
    
    grid_size=10;
    
    L=210;
    l=180;
    
    fan_width_with_borders = 50+6;
    

    
    difference(){
        basement_no_holes_v2(L,l,width,pillar_width,grid_size);
        translate([0,0,37.5-1])screw_holes_basement(L,l,pillar_width);
        
        // fan holes
        for(i=[0,1]){
            mirror([i,0,0])translate([-l/4,L/2-1,20])mCube(fan_width_with_borders+2,11,fan_width_with_borders+2);
        }
    }
    
    // To fill useless screw hole
    translate([0,-L/2+3,44.5])mCube(10,6,width);
    
    // space for fans
    for(i=[0,1]){
        mirror([i,0,0])
        translate([-l/4,L/2-9.5,44.5]){
            mCube(fan_width_with_borders+6*2+2,6,middle_floor_thickness);
            translate([fan_width_with_borders/2+6/2+1,4,0])mCube(6,11,middle_floor_thickness);
            translate([-(fan_width_with_borders/2+6/2+1),4,0])mCube(6,11,middle_floor_thickness);
        }
    }
    
    
}if(Basement){
    translate([0,0,-90]){
        basement_v2();
    }
}

//translate([0,0,200])mirror([1,0,0])cube([22,42,1]);
//translate([0,0,200])mCube(15,15,1);

//middle_floor(210,180,4);

module middle_floor(L,l,width){
    
    rpi_cable_hole_position=[l/4,L/7,-middle_floor_thickness/2];
    
    // Contour
    contour_width=middle_floor_thickness;
    
    
    difference(){
        union(){
            create_grid(size=[l,L,contour_width],SW=14,wall=2);
            
            // cube to have the middle pillar holes
            for(i=[0,1]){
                rotate([0,0,90*i])translate([0,0,-middle_floor_thickness/2])mCube(40,9,middle_floor_thickness);
            }
        }
        union(){
            
            translate(rpi_cable_hole_position)mCube(62,12,middle_floor_thickness);
            
            // holes to screw the middle pillar
            for(k=[0,1],i=[-1,0,1]){
                rotate([0,0,90*k])translate([14*i,0,-middle_floor_thickness/2])cylinder(d=2,h=middle_floor_thickness);
            }
        }
        
    }
    // External border
    translate([0,0,-contour_width/2])square3D(l,L,contour_width,6);
    
    translate(rpi_cable_hole_position)square3D(62,12,middle_floor_thickness,3,inner=true);
    
        

    
    /*
    for(i=[0,1]){
        mirror([i,0,0])translate([l/2-width/2,0,contour_width])mCube(width,L,contour_width);
        mirror([0,i,0])translate([0,-L/2+width/2,contour_width])mCube(l,width,contour_width);
    }
    */
    
}

module feet_v6(short_side=fcp){
    
    w=feet_width;
    
        
    feet_columns(h=feet_height, short_side=short_side);
    
   
    
    for(i=[-1,1]){
        
        translate([i*fcp,-0,0])mCube(w,2*short_side,middle_floor_thickness);
        translate([-0,i*short_side,0])mCube(2*fcp,w,middle_floor_thickness);
        
        
        
        for(j=[-1,1]){
            //translate([i*fcp-w/2,j*(short_side-w/2-3),4])prism(w,j*3,4);
            
            
            for(k=[0,1]){
                rotate([0,0,90*k])translate([i*fcp-w/2,j*(fcp-w/2-3),middle_floor_thickness])prism(w,j*3,5);
                //rotate([0,0,90*k])translate([i*(fcp+space_between_plates/2),j*fcp,0])mCube(w,w,feet_height-8.6);
            }
        }
    }
    
    // fan spot
    //fan_spot();
    
    
}

module fan_spot(){
        difference(){
        union(){
            mCube(34,34,6);
            
        }
        union(){
            //translate([-20,0,5])rotate([0,90,0])cylinder(d=1.95,h=40);
            cylinder(d=28.5,h=10);
            translate([0,0,3])mCube(30+tolerance,30+tolerance,7);
            translate([15-4-6/2,15,3])mCube(6,6,10);
            rotate([0,0,180])translate([15-4-6/2,15,3])mCube(6,6,10);
            
            for(i=[0,1],j=[0,1]){
                mirror([i,0,0])mirror([0,j,0])translate([15-1.1-3.3/2,15-1.1-3.3/2,0])cylinder(d=3.3, h=500);
            }
            
        }
    }
}

module power_supply_print(width){
    
    L = 129;
    W= 97;
    translate([0,0,width-0.2])mCube(W,L,0.2);
    translate([W/2-6.5,L/2-2,0])screw_head_hole(d=3.5,h=width);
    translate([-W/2+(W-85-6.5),-L/2+4.5,0])screw_head_hole(d=3.5,h=width);
    translate([W/2-34,-L/2+78,0])screw_head_hole(d=3.5,h=width);
    translate([W/2-34-33,-L/2+78,0])screw_head_hole(d=3.5,h=width);
}

module switch_print(width){
    W=83.75;
    L=61.6;
    
    translate([-66.375,-86.8,0]){
        translate([0,0,width-0.2])mCube(W,L,0.2);
        translate([W/2-17-1.5,L/2-2.5-1.5,0])screw_head_hole(d=3.5,h=width);
        translate([W/2-1-1.5,L/2-21.45-1.5,0])screw_head_hole(d=3.5,h=width);
        translate([-W/2+2+1.5,L/2-27.35-1.5,0])screw_head_hole(d=3.5,h=width);
    }
    
    
}

module screw_head_hole(d,h){
    cylinder(d=d+2.5,h=2);
    cylinder(d=d,h=h);
}



module feet_columns(h, short_side, w=feet_width){
    translate([ fcp,short_side,0]){single_foot_v3(w);
        }
    translate([ -fcp,short_side,0]){single_foot_v3(w);
        }
    translate([ fcp,-short_side,0]){single_foot_v3(w);
        }
    translate([ -fcp,-short_side,0]){single_foot_v3(w);
        }    
}



module single_foot_v3(w){
    l=16-width+tolerance;
    difference(){
        mCube(w,w,feet_height);
        /*
        if(!DRAFT_MODE){
            translate([0,0,feet_height-l])metric_thread(diameter=2, pitch=0.4,length=l,internal=true);
        }
        */
        //else{
            $fn=20;
            translate([0,0,feet_height-l])cylinder(d=1.8,h=l+20);
        //}
    }

}

module foot_side(inside_length){
    outside_length = inside_length+2*width;
    translate([0,0,0])difference(){
        union(){
            mCube(width*2,outside_length,feet_height);
        }
        union(){
            translate([0,0,width*2])mCube(width*2,inside_length-4*width,feet_height);
            translate([width,0,feet_height-width])mCube(width*2+tolerance,outside_length,width);
        }
    }
    
}

module spacer(h){
    $fn=20;
    difference(){
        cylinder(d=6,h=h);
        cylinder(d=2.9,h=h);
    }
}

module spacers(h){
    sep=4.5;
    translate([-sep,-sep,0])spacer(h);
    translate([-sep, sep,0])spacer(h);
    translate([ sep,-sep,0])spacer(h);
    translate([ sep, sep,0])spacer(h);
    //translate([ sep*3, sep,0])spacer();
    //translate([ sep*3, -sep,0])spacer();
    
}

if(Spacers){
    //translate([0,-external_size-sep,0])
    spacers(h=6);
}

module led_solder_mold(){
    
    difference(){
        
        $fn=50;
        h=12;
        
        cube([92,128,h]);
        
        translate([5,5,0])
        for(i=[0:9]){
            for(j=[0:13]){
                //translate([i*9,j*9,3.5])sphere(d=5.5);
                translate([i*9,j*9,2])cylinder(d=5.5,h=h);  
            }
        }
        translate([5+4.5,5+4.5,0])
        for(i=[0:8]){
            for(j=[0:12]){
                //translate([i*9,j*9,3.5])sphere(d=5.5); 
                translate([i*9,j*9,2])cylinder(d=5.5,h=h);   
            }
        }
    }
}if(Led_solder_mold){led_solder_mold();}


if(DRAFT_MODE){
    echo("\n\n!! DRAFT MODE ON !!\n\n");

}
