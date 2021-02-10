public class ChessboardFrame extends JFrame {
  public ChessboardFrame() {
    ca = new ChessboardApplet();
    String[] args = {"Chessboard"};
    PApplet.runSketch(args,ca);
    
    removeNotify(); 
    setUndecorated(true); 
    setAlwaysOnTop(false); 
    setResizable(false);  
    addNotify();     
    show();
  }
}

public class ChessboardApplet extends PApplet {
  public void setup() {
    noLoop();
  }
  //@ADD START
  public void settings() {
    fullScreen(2);
  }
  public void draw() {
    int cheight = (int)(cwidth * 0.8);
    background(255);
    fill(0);
    for (int j=0; j<4; j++) {
      for (int i=0; i<5; i++) {
        int x = int(cx + map(i, 0, 5, 0, cwidth));
        int y = int(cy + map(j, 0, 4, 0, cheight));
        
        if (i>0 && j>0)  projPoints.add(new PVector((float)x/pWidth, (float)y/pHeight));
        if ((i+j)%2==0)  rect(x, y, cwidth/5, cheight/4);
      }
    }  
    fill(0, 255, 0);
    if (calibrated)  
      ellipse(testPointP.x, testPointP.y, 20, 20);  
  }
}

void saveCalibration(String filename) {
  String[] coeffs = getCalibrationString();
  saveStrings(dataPath(filename), coeffs);
}

void loadCalibration(String filename) {
  String[] s = loadStrings(dataPath(filename));
  x = new Jama.Matrix(11, 1);
  for (int i=0; i<s.length; i++)
    x.set(i, 0, Float.parseFloat(s[i]));
  calibrated = true;
  println("done loading");
}