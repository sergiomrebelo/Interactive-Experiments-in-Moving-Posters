import picking.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

/**
 *  temperature range
 *  based in the official absolute extreme temerature recorded in mainland portugal by IPMA. 
 *  min: -16.º C in Penas da Saude/Miranda do Douro (4, February 1954); 
 *  max: 47,4.º C in Amareleja, Alentejo (1, August 2003)
 */
float min = -16, max = 47.4;
float rotX=0, rotY=0; //rotation angle
Frame img; //capture frame
Capture cam; //capture
Picker picker; //picking
Poster poster;
color backcolor = color(250);
Venue currentVenue;


public void setup () {
  size (594, 842, P3D);
  picker = new Picker(this);
  currentVenue = new Venue();
  //this.setup();
  if (!this.startRecord()) exit();
  img = new Frame (this);
  poster = new Poster ();
}

void draw() {
  ortho();
  noStroke();
  background(backcolor);
  this.setCaptureImage ();
  poster.draw();
  //picker need to add a null picker to when we select the last not select everything
  picker.start(poster.graphics.size()); 
  picker.stop();
  poster.setTemperature();
}

void mousePressed() {
  poster.mousePressed();
}


protected boolean setCaptureImage () {
  if (cam.available()) {
    cam.read();
    img.setCapture(cam.get());
  }
  return false;
}

/*
*
 * start record
 * @return: if camera's capture is available. 
 */
protected boolean startRecord() {
  String[] cameras = Capture.list();
  if (cameras.length != 0) {
    //println ("Available cameras:");
    println ("Capture started");
    cam = new Capture (this, cameras[0]);
    cam.start();
    return true;
  }
  println ("There are no cameras available for capture.");
  exit();
  return false;
  //exit();
}