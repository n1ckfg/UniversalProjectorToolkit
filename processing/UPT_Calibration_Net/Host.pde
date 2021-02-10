class Host {

  Frame[] frames;
  int currentFrame = 0;  
  String name;
  int w, h;
  PGraphics depth, rgb;
  PVector[] depthMap;
  
  Host(int _w, int _h, String _name) {
    w = _w;
    h = _h;
    name = _name;
    
    frames = new Frame[1];       
    frames[0] = new Frame(w, h);   
    
    depthMap = new PVector[w * h];
    rgb = createGraphics(w, h);
    depth = createGraphics(w, h);
  }
    
  void update() {
    rgb = frames[currentFrame].updateRgb();
    depthMap = frames[currentFrame].depthMap;
  }

}
