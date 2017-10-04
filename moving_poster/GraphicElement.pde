abstract class GraphicElement implements Comparable <GraphicElement> {
  protected PVector pos;
  protected boolean isSelected = false;
  protected int id;
  protected color [] c;
  protected float currentNormTemperature=0;

  public GraphicElement (PVector pos) {
    this.pos = pos;
  };

  //public abstract void draw(Picker picker);
  public abstract void draw();

  protected abstract void update();
  protected abstract boolean mousePressed();

  /**
   *
   * shapes sorting
   */
  public int compareTo(GraphicElement ge) {
    if (pos.z > ge.pos.z) {
      return -1;
    } else {
      return 1;
    }
  }

  public String tooString() {
    return ""+isSelected;
  }
  
  public void setTemperature( float currentNormTemp) {
    this.currentNormTemperature = currentNormTemp;
  }
  
  public color getColor () {
    int currentPos = floor(currentNormTemperature);
    if (currentPos !=c.length-1) {
      float amt = currentNormTemperature-currentPos;
      return lerpColor (c[currentPos], c[currentPos+1], amt);
    }
    return c[c.length-1];
  }
  
  
}

/*
*
 * Class circle 
 */

class Circle extends GraphicElement {
  private float radius, rX=0, rY=1;
  private int inc=10;

  public Circle (PVector pos, float radius, color [] c, int id) {
    super (pos);
    this.radius = radius;
    super.c = c;
    super.isSelected = false;
    super.id = id;
  }

  public void draw() {
    pushMatrix();
    translate (super.pos.x+10*cos(rX), super.pos.y+10*sin(rY), super.pos.z);
    fill (super.getColor());
    if (super.isSelected) {
      this.update();
    }
    sphere (this.radius);
    popMatrix();
  }

  protected void update () {
    rY = rotX;
    rX = rotY;
  }

  public boolean mousePressed () {
    PVector mouse = new PVector (mouseX, mouseY);
    if (new PVector (super.pos.x, super.pos.y).dist(mouse) < this.radius) {
      super.isSelected = !super.isSelected;
      println ("circle #"+super.id+" is selected —> "+super.isSelected);
      return true;
    } else return false;
  }
}

/*
*
 * Box
 */
class Box extends GraphicElement {
  protected float width=0, height=0;
  private float rAngle=0; //rotation angle;
  private boolean rDir=false; //rotation direction 
  private float rY=0, rX=0; //rotation increments

  public Box (PVector pos, float width, float height, float rAngle, color [] c, int id) {
    super (pos);
    super.c = c;
    super.isSelected = false;
    super.id = id;
    this.width = width;
    this.height = height;
    this.rAngle = rAngle;
    this.rDir = (random(0, 1) < .5) ? true : false;
  }

  public void draw() {
    noStroke();
    if (super.isSelected) {
      this.update();
    }
    pushMatrix();
    translate (this.pos.x, this.pos.y, this.pos.z);
    fill (super.getColor());
    rotate (radians(rAngle));
    /*!!!!!!!!*/
    if (rDir) rotateY(rY); 
    else rotateX(rX);
    picker.start(super.id);
    box(width, height, width);
    //noLights();
    popMatrix();
  }

  public void update() {
    this.rX = rotY;
    this.rY = rotX;
  }

  public boolean mousePressed () {
    if (picker.get(mouseX, mouseY) == super.id) {
      super.isSelected = !super.isSelected;
      println ("box #"+super.id+" is selected —> "+super.isSelected+" /pickerCode: "+picker.get(mouseX, mouseY));
      return true;
    }
    return false;
  }
}

/*
*
 * Rotation Letter
 */
class RotationLetter extends GraphicElement {
  protected PShape shape;
  protected float rAngle=0; //rotation angle;
  protected boolean rDir=false;
  private float rY=0, rX=0; //rotation increments

  public RotationLetter (PVector pos, PShape shape, float rAngle, int id) {
    super(pos);
    this.shape = shape;
    this.rAngle = rAngle;
    this.rDir = (random(0, 1) < .5) ? true : false;
    super.isSelected = false;
    super.id = id;
    this.shape.setFill(color(0));
  }

  public void draw() { 
    shapeMode(CENTER);
    if (super.isSelected) {
      this.update();
    }
    pushMatrix();
    translate (super.pos.x, super.pos.y, super.pos.z);
    rotate(this.rAngle);
    if (rDir) rotate(rX);
    else rotate(rY);
    shape (this.shape, 0, 0);
    popMatrix();
  }

  public void update() {
    rX = map(rotX, 0, TWO_PI, 0, PI);
    rY = map(rotY, 0, TWO_PI, 0, PI);
  }

  public boolean mousePressed() {
    PShape patch = this.shape.getChild(0);
    PVector reboundMouse = new PVector (mouseX, mouseY);
    reboundMouse.sub((super.pos.x), (super.pos.y));   
    reboundMouse.rotate(-this.rAngle);
    reboundMouse.sub(-53, -71); //!!!! SHAPE MODE CENTER
    if (patch.contains(reboundMouse.x, reboundMouse.y)) {
      super.isSelected = !super.isSelected;
      println ("RotationLetter #"+super.id+" is selected —> "+super.isSelected);
      return true;
    }
    return false;
  }
}

class TranslationLetter extends GraphicElement {
  protected PShape shape;
  private PVector start, inc;
  protected float rAngle=0; //rotation angle;
  private boolean rDir=false;
  private float rY=0, rX=0; //rotation increments
  private int nDrags = 0;

  /** TranslateLetter constructor
   * @param: pos > position (upper right corner)
   * @param: shape > shape
   * @param: animation type >
   */
  public TranslationLetter (PVector pos, PVector start, PShape shape, float rAngle, int nDrags, int id) {
    super(pos);
    this.start = start;
    this.shape = shape;
    this.nDrags = nDrags;
    this.rAngle = radians(rAngle);
    super.id = id;
    super.isSelected=false;
    this.inc = this.calculateInc();
  }

  public void draw() { 
    pushMatrix();
    shapeMode(RIGHT);
    shape.setStroke(color(0));
    shape.setFill(backcolor);
    if (super.isSelected) {
      this.update();
    }
    this.dragTranslate();
    popMatrix();
  }


  public void update() {
    rX = map(rotX, 0, TWO_PI, 0, PI);
    rY = map(rotY, 0, TWO_PI, 0, PI);
  }


  public boolean mousePressed() {
    // Temporary soluction
    PShape patch = this.shape.getChild(0);
    PVector reboundMouse = new PVector ((mouseX-super.pos.x), (mouseY-super.pos.y));
    reboundMouse.rotate(-this.rAngle);
    if (patch.contains(reboundMouse.x, reboundMouse.y)) {
      super.isSelected = !super.isSelected;
      println ("TranslationLetter #"+super.id+" is selected —> "+super.isSelected);
      return true;
    }
    return false;
  }

  private PVector calculateInc() {
    float valuex = map (rX, 0, PI, 0, 150);
    float valuey = map (rX, 0, PI, 0, 150);
    PVector currentPos = new PVector (pos.x+valuex, pos.y+valuey);
    PVector dif = currentPos.copy().sub(this.start);
    PVector inc = dif.copy().div(nDrags); 
    return inc;
  }

  private void dragTranslate() {
    this.inc= this.calculateInc();
    translate (this.start.x, this.start.y, this.start.z);
    rotate (this.rAngle);
    for (int i=nDrags; i>0; i--) {
      shape (shape, 0, 0);
      translate(inc.x, inc.y, abs(inc.z));
    }
    shape.setFill(color(0));
    shape (shape, 0, 0);
  }
}


class RotationDragLetter extends GraphicElement {
  private PShape shape;
  //private PVector o; //shape's centre
  private float rAngle;
  private int nDrags = 4;
  private boolean isFixed = false; //fixed mode (on/off)
  private boolean rDir=false;
  private float rY=0, rX=0; //rotation increments
  private float incDrag = radians(15); //increment for the defenition of drags —> non fixed mode


  public RotationDragLetter(PVector pos, PShape shape, float rAngle, int nDrags, boolean isFixed, int id) {
    super(pos);
    this.shape = shape;
    this.rAngle = radians(rAngle);
    this.nDrags = nDrags;
    this.isFixed = isFixed;
    super.id = id;
    this.shape.setStrokeWeight(1);
  }

  public void update() {
    rX = map(rotX, 0, TWO_PI, 0, PI);
    rY = map(rotY, 0, TWO_PI, 0, PI);
  }

  public void draw() {
    shapeMode(RIGHT);
    pushMatrix();
    if (this.isSelected) {
      this.update();
    }
    shape.setFill(backcolor);
    this.dragRotate ();
    popMatrix();
    return;
  }

  public boolean mousePressed () {
    PShape patch = this.shape.getChild(0);
    PVector reboundMouse = new PVector ((mouseX-super.pos.x), (mouseY-super.pos.y));
    reboundMouse.rotate(-this.rAngle);
    if (patch.contains(reboundMouse.x, reboundMouse.y)) {
      super.isSelected = !super.isSelected;
      println ("RotationDragLetter #"+super.id+" is selected —> "+super.isSelected);
      return true;
    }
    return false;
  }

  private void dragRotate() {
    translate (pos.x, pos.y, pos.z);
    float userValue = (rDir) ? rY: rX;
    float rValue = userValue + this.rAngle;
    if (!this.isFixed) {
      this.nDrags = abs(round(userValue/this.incDrag));
    }
    for (int i=nDrags; i>0; i--) {
      pushMatrix();
      float currentRotation = (rValue/nDrags)*i;
      translate (0, 0, -10*i);
      rotate (this.rAngle+currentRotation);
      line(0, 0, 0, 200);
      //shape.setFill(color(255/nDrags*i));
      shape (shape, 0, 0);
      popMatrix();
    }
    rotate(this.rAngle);
    this.shape.setFill(color(0));
    shape (this.shape, 0, 0);
  }
}