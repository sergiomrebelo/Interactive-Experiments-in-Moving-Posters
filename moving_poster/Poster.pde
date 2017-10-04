import java.util.Arrays; //<>//
import java.util.*;

class Poster {
  protected ArrayList<GraphicElement> graphics = new ArrayList <GraphicElement> (); 
  protected float currentNormTemperature; 

  //colors arrays
  private color [] red = {color (230, 105, 105), color (230, 80, 80), color(230, 55, 55), color (250, 50, 50), color (255, 50, 0)}; //reversed
  private color [] yellow = {color(255, 225, 115), color (255, 220, 90), color (255, 210, 40), color (255, 215, 0), color(225, 225, 0) };
  private color [] green = {color (0, 230, 220), color (20, 205, 205), color (20, 180, 165), color (20, 180, 145), color (20, 205, 130)};
  private color [] blue = {color (110, 165, 215), color(30, 115, 190), color(0, 110, 190), color(0, 95, 190), color(0, 80, 190)};
  //Temporary soluction
  private int boxFirstId = 0;
  private int updateDuration = 300000; //5minutes
  private int start; //timer

  public Poster () {
    this.initLayout();
    //Collections.sort(graphics);
    this.setTemperature();
    start = millis();
  }

  public void draw() {
    //!!!!! Temporary soluction
    //lights();
    lightSpecular(0,200,0);
    for (int i=0; i<graphics.size(); i++) {
      GraphicElement g = graphics.get(i);
      //if (i==this.boxFirstId) lights();
      g.draw();
    }
    //noLights();
    
    if (millis()-start>updateDuration) {
      this.setTemperature();
      start = millis();
    }
    
    

    /*lights();
     for (GraphicElement g : graphics) {
     if (!(g instanceof Box)) noLights();
     g.draw();
     }*/
  }
  
  public void setTemperature() {
    float currentNormTemperature = currentVenue.getTemperature (red.length-1);
    currentNormTemperature  = 4;
    for (GraphicElement g : graphics) {
      g.setTemperature(currentNormTemperature);
    }
  }

  public void mousePressed() {
    for (GraphicElement g : graphics) {
      g.mousePressed();
    }
  }


  /*public color getColor (color[] cArray, float temperaturePos) {
    int currentPos = floor(temperaturePos);
    println (currentPos+" "+temperaturePos);
    if (currentPos !=cArray.length-1) {
      float amt = temperaturePos-currentPos;
      return lerpColor (cArray[currentPos], cArray[currentPos+1], amt);
      //return cArray[currentPos];
      //return color (0,0,0);
    }
    return cArray[cArray.length-1];
  }*/

  /****** !!!!! */
  void initLayout() {
    /*color red = this.getColor (red, currentNormTemperature), 
      yellow = this.getColor (yellow, currentNormTemperature), 
      green = this.getColor (green, currentNormTemperature), 
      blue = this.getColor (blue, currentNormTemperature);*/
    int id=0;
    //cicles
    PVector pos1 = new PVector (0, 100, 0);
    graphics.add(new Circle (pos1, 180/2, red, id));
    pos1 = new PVector (418, 355, 0);
    id+=1;
    graphics.add(new Circle (pos1, 120/2, yellow, id));
    pos1 = new PVector (0, 600, 0);
    id+=1;
    graphics.add(new Circle (pos1, 100/2, yellow, id));
    id+=1;
    pos1 = new PVector (360, 820, -50);
    graphics.add(new Circle (pos1, 100/2, red, id));
    id+=1;
    pos1 = new PVector (555, 740, 0);
    graphics.add(new Circle (pos1, 180/2, green, id));
    //letters
    id+=1;
    pos1= new PVector (140, 100, 0);
    graphics.add(new RotationLetter (pos1, loadShape("shapes/letter_s.svg"), 0, id));
    id+=1;
    pos1= new PVector (460, 250, 100);
    graphics.add(new RotationLetter (pos1, loadShape("shapes/letter_p.svg"), 20, id));
    id+=1;

    //translate Letter
    pos1= new PVector (300, 30, 200);
    PVector spos = new PVector (300, 65, 100);  
    graphics.add(new TranslationLetter(pos1, spos, loadShape("shapes/letter_a4.svg"), -35, 3, id));
    pos1 = new PVector (90, 470, 300);
    spos = new PVector (150, 440, 100);
    id+=1;
    graphics.add(new TranslationLetter(pos1, spos, loadShape ("shapes/letter_m.svg"), 30, 4, id));
    //Rotate with Dragging letter
    id+=1;
    pos1 = new PVector (455, 380, -50);
    graphics.add(new RotationDragLetter(pos1, loadShape("shapes/letter_e2.svg"), 15, 2, true, id));
    id+=1;
    pos1= new PVector (300, 660, 0);
    graphics.add(new RotationDragLetter(pos1, loadShape("shapes/letter_e2.svg"), -25, 4, false, id));
    id+=1;
    pos1= new PVector (230, 125, 0);
    graphics.add(new RotationDragLetter(pos1, loadShape("shapes/letter_h3.svg"), 30, 6, false, id));
    
    ///boxes
    id+=1;
    this.boxFirstId = id;
    pos1 = new PVector (280, 25, 0);
    graphics.add(new Box (pos1, 135, 135, 30, green, id));
    id+=1;
    pos1 = new PVector (500, 15, 0);
    graphics.add(new Box (pos1, 125, 125, 20, green, id));
    id+=1;
    pos1 = new PVector (580, 185, 0);
    graphics.add(new Box (pos1, 130, 130, 25, blue, id));
    id+=1;
    pos1 = new PVector (80, 300, -300);
    graphics.add(new Box (pos1, 230, 230, 25, yellow, id));
    id+=1;
    pos1 = new PVector (210, 390, 0);
    graphics.add(new Box (pos1, 60, 390, 45, red, id));
    id+=1;
    pos1 = new PVector (370, 495, -300);
    graphics.add(new Box(pos1, 230, 230, 25, green, id));
    id+=1;
    pos1 = new PVector (370, 495, -300);
    graphics.add(new Box (pos1, 230, 230, 25, blue, id));
    id+=1;
    pos1 = new PVector (450, 545, 0);
    graphics.add(new Box (pos1, 80, 95, 25, red, id));
    id+=1;
    pos1 = new PVector (95, 750, 0);
    graphics.add(new Box (pos1, 130, 130, 25, red, id));
    id+=1;
    pos1 = new PVector (215, 760, 100);
    graphics.add(new Box (pos1, 60, 340, 45, green, id));
  }
}