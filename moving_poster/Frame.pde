/*
*  
 * auxiliar PFrame
 */
class Frame extends PApplet {
  private PImage cam, smaller;
  private OpenCV opencv;
  private Rectangle [] faces;
  private ArrayList <PVector> centre = new ArrayList <PVector> ();

  public Frame (PApplet parent) {
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void setup () {
    surface.setSize(640, 360);
    surface.setLocation(0, 0);
    this.opencv = new OpenCV(this, width, height);
    this.smaller = createImage(opencv.width, opencv.height, RGB);
    this.opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }

  public void draw() {
    background (255);
    if (this.getRecordedImage()) {
      image(cam, 0, 0, this.width, this.height);
      this.updateList();
      this.defineRotation ();
      //display mapping grid
      this.displayRects();
      this.displayAxis();
    }
  }

  private void displayRects() {
    for (Rectangle rect : faces) display(rect);
  }

  /*
  *  
   * get capture
   * @return: capture's cam status
   */
  private boolean getRecordedImage() {

    if (cam != null) {
      this.smaller.copy(cam, 0, 0, cam.width, cam.height, 0, 0, smaller.width, smaller.height);
      this.smaller.updatePixels();
      this.opencv.loadImage(smaller);
      this.faces = opencv.detect();
      return true;
    }
    return false;
  }

  public void setCapture (PImage img) {
    this.cam = img;
  }

  /*
  *  
   * display mapping axis
   */
  private void displayAxis() {
    stroke (0, 0, 255);
    strokeWeight(2);
    line(width/2, 0, width/2, height);
    line(0, height/2, width, height/2);
  }

  /*
  *  
   *  show faces' rectangles
   *  @param: Java2D rectangles of detected face
   */
  private void display(Rectangle rect) {
    noFill();
    stroke (255, 0, 0);
    rect(rect.x, rect.y, rect.width, rect.height);
    //centre.add(new PVector(rect.x+rect.width/2, rect.y+rect.height/2));
  }

  private void updateList() {
    centre.clear();
    for (Rectangle rect : faces) 
      centre.add(new PVector(rect.x+rect.width/2, rect.y+rect.height/2));
  }

  /*
  *
   * define the rotation value 
   * global variables rotY and rotX
   */
  private void defineRotation () {
    //SCENARIO 1: FaceList is empty
    if (this.centre == null) return;
    //SCENARIO 2: We have fewer objects than face rectnagles found from OPENCV
    else if (this.centre.size() == 1) {
      //if only one person sees the poster
      rotY = map (centre.get(0).x, 0, width, -TWO_PI, TWO_PI);
      rotX = map (centre.get(0).y, 0, height, -TWO_PI, TWO_PI);
    } 
    //SCENARIO 3: We have more Face objects than Rectangles found
    else if (centre.size() > 1) {
      //if if several people see the poster
      float avx = 0;
      float avy = 0;
      for (PVector pos : centre) {
        avx+= map (pos.x, 0, width, -TWO_PI, TWO_PI);
        avy+= map (pos.y, 0, height, -TWO_PI, TWO_PI);
      }
      rotY = avy/centre.size();
      rotX = avx/centre.size();
    }
  }
}