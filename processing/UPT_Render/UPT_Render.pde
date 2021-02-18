import gab.opencv.*;
import KinectProjectorToolkit.*;
import controlP5.*;

KinectWrapper kinect;
OpenCV opencv;
KinectProjectorToolkit kpc;
ControlP5 cp5;
ArrayList<ArrayList<ProjectedContour>> allProjectedContours;
ArrayList<Ribbon> ribbons;
boolean renderBody, renderRibbons, ribbonIsCurved, ribbonIsWhite, guiVisible=true;
PGraphics pg, bg;
PShader shade, bgshade;
float blobDilate, ribbonNoiseFactor, ribbonThickness;
int ribbonSpawnRate, ribbonMaxAge, ribbonLength, ribbonSpeed, ribbonSkip, ribbonMargin, ribbonAlpha;
int samplingMode, idxShader, numframes, idxBg;

void setup() {
  fullScreen(P2D); 

  setupSyphon();
  
  // setup Kinect
  kinect = new KinectWrapper(this); 
  kinect.enableDepth();
  kinect.enableUser();
  kinect.alternativeViewPointDepthToImage();
  
  if (kinect.isOffline) {
    //kinect.update(loadStrings("sample/depth_map.txt"), loadImage("sample/depth_image.png"), loadImage("sample/user_image.png"));
    kinect.update(loadStrings("sample/depth_map.txt"), loadImage("sample/depth_image.png"), threshold);
  }
  
  // setup OpenCV
  opencv = new OpenCV(this, kinect.depthWidth(), kinect.depthHeight());
  //opencv = new OpenCV(this, 640, 480);

  // setup Kinect Projector Toolkit
  //kpc = new KinectProjectorToolkit(this, 640, 480);
  kpc = new KinectProjectorToolkit(this, kinect.depthWidth(), kinect.depthHeight());// kinect.depthWidth(), kinect.depthHeight());
  kpc.loadCalibration("calibration.txt");
  kpc.setContourSmoothness(3);  
  
  // initialize ribbons
  ribbons = new ArrayList<Ribbon>();
  
  // shaders and body graphics
  pg = createGraphics(600, 800, P2D);
  bg = createGraphics(width, height, P2D);
  setupShader(idxShader);
  setupBackground(idxBg);
  
  // archive of projected contours
  allProjectedContours = new ArrayList<ArrayList<ProjectedContour>>();
  
  setupGUI();
}

void setupShader(int idxShader) {
  switch (idxShader) {
    case 0: 
      shade = loadShader("white.glsl");
      break;
    case 1: 
      shade = loadShader("black.glsl");
      break;
    case 2: 
      shade = loadShader("blobby.glsl");
      break;
    case 3:
      shade = loadShader("drip.glsl");
      shade.set("intense", 0.5);
      shade.set("speed", 3.0);
      shade.set("c", 0.5, 1.0);
      break;
    case 4:
      shade = loadShader("waterNoise.glsl");
      break;
    case 5: 
      shade = loadShader("waves.glsl");
      break;
  }
  shade.set("resolution", float(pg.width), float(pg.height));
  pg.shader(shade);
}

void setupBackground(int idxBg) {
  switch (idxBg) {
    case 0:
      bg.beginDraw();
      bg.background(0);
      bg.endDraw();
      bg.resetShader();
      break;
    case 1:
      bg.beginDraw();
      bg.background(255);
      bg.endDraw();
      bg.resetShader();
      break;
    case 2:
      bgshade = loadShader("blobby.glsl");
      bgshade.set("resolution", float(bg.width), float(bg.height));
      bg.shader(bgshade);
      break;
    case 3:
      bgshade = loadShader("drip.glsl");
      bgshade.set("intense", 0.5);
      bgshade.set("speed", 3.0);
      bgshade.set("c", 0.5, 1.0);
      bgshade.set("resolution", float(bg.width), float(bg.height));
      bg.shader(bgshade);
      break;
    case 4:
      bgshade = loadShader("waterNoise.glsl");
      bgshade.set("resolution", float(bg.width), float(bg.height));
      bg.shader(bgshade);
      break;
    case 5:
      bgshade = loadShader("waves.glsl");
      bgshade.set("resolution", float(bg.width), float(bg.height));
      bg.shader(bgshade);
      break;
  }
}

void draw() { 
  if (!kinect.isOffline) kinect.update();  
  kpc.setDepthMapRealWorld(kinect.depthMapRealWorld()); 
  kpc.setKinectUserImage(kinect.userImage());
  opencv.loadImage(kpc.getImage());
  
  // get projected contours
  ArrayList<ProjectedContour> projectedContours = new ArrayList<ProjectedContour>();
  
  ArrayList<Contour> contours = opencv.findContours();
  for (Contour contour : contours) {
    if (contour.area() > 2000) {
      ArrayList<PVector> cvContour = contour.getPoints();
      ProjectedContour projectedContour = kpc.getProjectedContour(cvContour, blobDilate);
      projectedContours.add(projectedContour);
    }
  }
     
  // add to running list of projected contours
  allProjectedContours.add(projectedContours);
  while (allProjectedContours.size() > numframes)  allProjectedContours.remove(0);
  
  // get current projected contours depending on strategy
  int t = allProjectedContours.size()-1;
  if (samplingMode == 1) {
    t = (int) map(sin(0.01*frameCount), -1, 1, 0, allProjectedContours.size() - 1);
  } else if (samplingMode == 2) {
    t = (int) map(mouseX, 0, width, 0, allProjectedContours.size() - 1);
  }
  projectedContours = allProjectedContours.get(t);
  
  // draw background
  if (idxBg > 1) {
    bgshade.set("time", millis()/1000.0);
    bg.beginDraw();
    bg.rect(0, 0, bg.width, bg.height);
    bg.endDraw();  
  }
  
  tex.beginDraw();
  tex.image(bg, 0, 0);
  
  // render bodies
  if (renderBody) {
    for (int i=0; i<projectedContours.size(); i++) {
      shade.set("time", millis()/1000.0);
      pg.beginDraw();
      pg.rect(0, 0, pg.width, pg.height);
      pg.endDraw();    
      
      ProjectedContour projectedContour = projectedContours.get(i);
      tex.beginShape();
      tex.texture(pg);
      for (PVector p : projectedContour.getProjectedContours()) {
        PVector pt = projectedContour.getTextureCoordinate(p);
        tex.vertex(p.x, p.y, pg.width * pt.x, pg.height * pt.y);
      }
      tex.endShape();
    }
  }
  
  // render ribbons
  if (renderRibbons) {
    if (projectedContours.size() > 0) addNewRibbons(t, ribbonSpawnRate);
    ArrayList<Ribbon> nextRibbons = new ArrayList<Ribbon>();
    for (Ribbon r : ribbons) {
      r.update();
      r.draw();
      if (r.age < r.maxAge)  nextRibbons.add(r);
    }
    ribbons = nextRibbons;
  } 
  tex.endDraw();

  image(tex, 0, 0);
  updateSyphon();

  // for gui
  if (guiVisible) {
    fill(0, 100);
    rect(36, 24, 500, 640);

    if (debugDraw && kinect.isOffline) {
      pushMatrix();
      scale(1,-1);
      translate(width/2, -kinect.contourImg.height);
      image(kinect.contourImg, 0, 0);
      popMatrix();
    }
  }
     
  surface.setTitle("" + frameRate);
}

void addNewRibbons(int t, int n) {
  ArrayList<ProjectedContour> projectedContours = allProjectedContours.get(t);
  for (int i=0; i<n; i++) {
    int p = (int) random(projectedContours.size());
    ArrayList<PVector> contourPoints = projectedContours.get(p).getProjectedContours();
    Ribbon newRibbon = new Ribbon(contourPoints);
    ribbons.add(newRibbon); 
  }
}
