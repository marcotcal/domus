$fn=100;

module roundedbox(xx, yy, zz, radius, ct) {
    
    x = xx - radius * 2;
    y = yy - radius * 2; 
    z = zz;

    if(ct == false) {
        
        translate([xx/2,yy/2, zz/2])
            
        intersection() {
            minkowski() {
                cube([x, y, z],true);
                cylinder(r=radius ,h=z);
            }    
            cube([xx, yy, zz],true);
        }
        
    } else {
        
        intersection() {
            minkowski() {
                cube([x, y, z],true);
                cylinder(r=radius ,h=z);
            }    
            cube([xx, yy, zz],true);
        }
        
    }
    
}
   
module RP_Pico_Fundo() {

    h_base = 0.5;
    h_pino = 3;
    r_pino = 3/2;
    r_para = 2/2;

    corr = 0.30;

    $fn=100;
    difference() {
        union()  {
            difference() {
                translate([0, 0, 1.5]) roundedbox(55, 25, 4 , 1, true);
                translate([0, 0, 2]) roundedbox(53, 23, 5, 1, true);
            }
            
            cube([53,23,h_base], center=true);
            translate([51/2-2+corr, 11.4/2, h_base/2 + h_pino/2]) cylinder(h=h_pino,r=r_pino, center = true, $fn=100);  
            translate([51/2-corr*0.75, 11.4/2, h_base/2 + h_pino/2]) cube([3,3,3], center = true);  
           
            translate([51/2-2+corr, -11.4/2, h_base/2 + h_pino/2]) cylinder(h=h_pino,r=r_pino, center = true, $fn=100); 
            translate([51/2-corr*0.75, -11.4/2, h_base/2 + h_pino/2]) cube([3,3,3], center = true);  
            
            translate([-51/2+2-corr, 11.4/2, h_base/2 + h_pino/2]) cylinder(h=h_pino,r=r_pino, center = true, $fn=100);  
            translate([-51/2+corr*0.75, 11.4/2, h_base/2 + h_pino/2]) cube([3,3,3], center = true); 
           
            translate([-51/2+2-corr, -11.4/2, h_base/2 + h_pino/2]) cylinder(h=h_pino,r=r_pino, center = true, $fn=100);  
            translate([-51/2+corr*0.75, -11.4/2, h_base/2 + h_pino/2]) cube([3,3,3], center = true); 
                   
        }
       
        // furo led
        translate([51/2-4.5, -11.4/2, 0]) cylinder(h=10,r=1, center = true, $fn=100);
        translate([51/2-5, -11.4/2, 0]) cube([1,2,10], center = true);
        translate([51/2-5.5, -11.4/2, 0]) cylinder(h=10,r=1, center = true, $fn=100);
        
        translate([51/2-11, -21/2+7.2, 0]) cylinder(h=10,r=1.25, center = true, $fn=100);
        translate([51/2-12, -21/2+7.2, 0]) cube([2,2.5,10], center = true);
        translate([51/2-13, -21/2+7.2, 0]) cylinder(h=10,r=1.25, center = true, $fn=100);
        
        // usb
        translate([51/2, 0, 2.25]) cube([7, 8.4, 4] , true);
       
        // furos
        translate([51/2-2+corr, 11.4/2, 0]) cylinder(h=10,r=r_para, center = true, $fn=100);  
        translate([51/2-2+corr, -11.4/2, 0]) cylinder(h=10,r=r_para, center = true, $fn=100);  
        translate([-51/2+2-corr, 11.4/2, 0]) cylinder(h=10,r=r_para, center = true, $fn=100);  
        translate([-51/2+2-corr, -11.4/2, 0]) cylinder(h=10,r=r_para, center = true, $fn=100);  
    }
    
}   
     
module TesteFurosRelayVallemann4() {
    
    difference() { 
        union() {
            translate([((77/2-2-3.4/2)), (36.5/2+3.5/2), 0]) cylinder(h=1,r=3.5,center=true); 
            translate([((77/2-2-3.4/2)), -(36.5/2+3.5/2), 0]) cylinder(h=1,r=3.5,center=true); 
            translate([-((77/2-2-3.4/2)), -(36.5/2+3.5/2), 0]) cylinder(h=1,r=3.5,center=true); 
            translate([-((77/2-2-3.4/2)), (36.5/2+3.5/2), 0]) cylinder(h=1,r=3.5,center=true); 
            
            translate([((77/2-2-3.4/2+3)), (36.5/2+3.5/2), 0]) cube([6,7,1], center=true); 
            translate([((77/2-2-3.4/2+3)), -(36.5/2+3.5/2), 0]) cube([6,7,1], center=true); 
            translate([-((77/2-2-3.4/2+3)), -(36.5/2+3.5/2), 0]) cube([6,7,1], center=true); 
            translate([-((77/2-2-3.4/2+3)), (36.5/2+3.5/2), 0]) cube([6,7,1], center=true); 

            difference() {
                translate([0,2,0]) roundedbox(83,61,1,2,true);
                translate([0,2,0]) roundedbox(79,57,1,2,true);                
            }
        }    
        translate([((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), 0]) cylinder(h=1,r=3.5/2,center=true); 
        translate([((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), 0]) cylinder(h=1,r=3.5/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), 0]) cylinder(h=1,r=3.5/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), 0]) cylinder(h=1,r=3.5/2,center=true); 
        
        translate([((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), -2]) cylinder(h=5,r=5.8/2,center=true); 
        translate([((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), -2]) cylinder(h=5,r=5.8/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), -2]) cylinder(h=5,r=5.8/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), -2]) cylinder(h=5,r=5.8/2,center=true); 
    }    

}

 
module BaseRelayVallemann4() {
    
    difference() { 
        union() {
            translate([((77/2-2-3.4/2)), (36.5/2+3.5/2), -1]) cylinder(h=5,r=3.5,center=true); 
            translate([((77/2-2-3.4/2)), -(36.5/2+3.5/2), -1]) cylinder(h=5,r=3.5,center=true); 
            translate([-((77/2-2-3.4/2)), -(36.5/2+3.5/2), -1]) cylinder(h=5,r=3.5,center=true); 
            translate([-((77/2-2-3.4/2)), (36.5/2+3.5/2), -1]) cylinder(h=5,r=3.5,center=true); 
            
            translate([((77/2-2-3.4/2+3)), (36.5/2+3.5/2), -1]) cube([6,7,5], center=true); 
            translate([((77/2-2-3.4/2+3)), -(36.5/2+3.5/2), -1]) cube([6,7,5], center=true); 
            translate([-((77/2-2-3.4/2+3)), -(36.5/2+3.5/2), -1]) cube([6,7,5], center=true); 
            translate([-((77/2-2-3.4/2+3)), (36.5/2+3.5/2), -1]) cube([6,7,5], center=true); 

            difference() {
                union() {
                    translate([88/2, 0, -2]) cube([5, 10, 3], center=true);
                    translate([93/2, 0, -2]) cylinder(h=3,r=5, center = true);
                }
                translate([93/2, 0, -2]) cylinder(h=5,r=2.5, center = true);
            }
            rotate([0,0,180])
            difference() {
                union() {
                    translate([88/2, 0, -2]) cube([5, 10, 3], center=true);
                    translate([93/2, 0, -2]) cylinder(h=3,r=5, center = true);
                }
                translate([93/2, 0, -2]) cylinder(h=5,r=2.5, center = true);
            }
            
            difference() {
                translate([0,2,0]) roundedbox(83,61,7,2,true);
                translate([0,2,1]) roundedbox(79,57,8,2,true);                
            }
        }    
        translate([((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), 0]) cylinder(h=10,r=3.5/2,center=true); 
        translate([((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), 0]) cylinder(h=10,r=3.5/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), 0]) cylinder(h=10,r=3.5/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), 0]) cylinder(h=10,r=3.5/2,center=true); 
        
        translate([((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), -2]) cylinder(h=5,r=5.8/2,center=true); 
        translate([((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), -2]) cylinder(h=5,r=5.8/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), -2]) cylinder(h=5,r=5.8/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), -2]) cylinder(h=5,r=5.8/2,center=true); 
    }    

}

module TampaRelayVallemann4() {
    
    h_base = 1;
    h_pino = 3;
    r_pino = 3/2;
    r_para = 2/2;

    corr = 0.15;
    
    difference() { 
        union() {
            //translate([((77/2-2-3.4/2)), (36.5/2+3.5/2), 10/2]) cylinder(h=25,r=3.5,center=true); 
            //translate([((77/2-2-3.4/2)), -(36.5/2+3.5/2), 10/2]) cylinder(h=25,r=3.5,center=true); 
            //translate([-((77/2-2-3.4/2)), -(36.5/2+3.5/2), 10/2]) cylinder(h=25,r=3.5,center=true); 
            //translate([-((77/2-2-3.4/2)), (36.5/2+3.5/2), 10/2]) cylinder(h=25,r=3.5,center=true); 
            
            translate([((77/2-2-3.4/2+1.5)), (36.5/2+3.5/2), 20/2]) cube([9,7,5], center=true); 
            translate([((77/2-2-3.4/2+1.5)), -(36.5/2+3.5/2), 20/2]) cube([9,7,5], center=true); 
            translate([-((77/2-2-3.4/2+1.5)), -(36.5/2+3.5/2), 20/2]) cube([9,7,5], center=true); 
            translate([-((77/2-2-3.4/2+1.5)), (36.5/2+3.5/2), 20/2]) cube([9,7,5], center=true); 
            
            difference() {
                translate([0,2,0]) roundedbox(83,61,25,2,true);
                translate([0,2,1]) roundedbox(81,59,26,2,true);                
            }
        }   
               
        translate([((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), 10/2+1]) cylinder(h=25,r=3.15/2,center=true); 
        translate([((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), 10/2+1]) cylinder(h=25,r=3.15/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), -(36.5/2+3.5/2), 10/2+1]) cylinder(h=25,r=3.15/2,center=true); 
        translate([-((77/2-2-3.4/2+0.12)), (36.5/2+3.5/2), 10/2+1]) cylinder(h=25,r=3.15/2,center=true); 
                
        translate([0, 60/2, 10]) cube([63,30,60], center=true);
        
        
        translate([13,-9,-33.5/2]) {
            // furo led
            translate([51/2-4.5, -11.4/2, 0]) cylinder(h=100,r=1, center = true, $fn=100);
            translate([51/2-5, -11.4/2, 0]) cube([1,2,100], center = true);
            translate([51/2-5.5, -11.4/2, 0]) cylinder(h=100,r=1, center = true, $fn=100);
            // botao
            translate([51/2-11, -21/2+7.2, 0]) cylinder(h=100,r=1.25, center = true, $fn=100);
            translate([51/2-12, -21/2+7.2, 0]) cube([2,2.5,100], center = true);
            translate([51/2-13, -21/2+7.2, 0]) cylinder(h=100,r=1.25, center = true, $fn=100);
            
            // usb
            translate([51/2, 0, 7 ]) cube([10, 8.4, 4] , true);
            
            translate([51/2-2+corr, 11.4/2, 0]) cylinder(h=10,r=r_para, center = true, $fn=100);  
            translate([51/2-2+corr, -11.4/2, 0]) cylinder(h=10,r=r_para, center = true, $fn=100);  
            translate([-51/2+2-corr, 11.4/2, 0]) cylinder(h=10,r=r_para, center = true, $fn=100);  
            translate([-51/2+2-corr, -11.4/2, 0]) cylinder(h=10,r=r_para, center = true, $fn=100);
        }    
        
        
    }   
    
    translate([0, 15, -4]) cube([64,1,35-18], center=true);
    translate([64/2, 23, 0]) cube([0.6,17,25], center=true);
    translate([-64/2, 23, 0]) cube([0.6,17,25], center=true);
    
    //color("#ff0000") {
        //translate([13,-9,-23/2-0.5]) RP_Pico_Fundo();
        translate([13,-9,-12]) RP_Pico_Fundo();
    //}
    
}


//TesteFurosRelayVallemann4();
translate([0, 0, 25/2]) TampaRelayVallemann4();
translate([0, 65, 3.5]) BaseRelayVallemann4();
