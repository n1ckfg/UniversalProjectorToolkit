int kinectLookupTableSize = 10000;
float kinectDepthScale = 10;
float[] kinectLookupTable = new float[kinectLookupTableSize];

void setupKinectLookupTable() {
  for (int i=0; i<kinectLookupTable.length; i++) {
    kinectLookupTable[i] = map(i, 0, kinectLookupTableSize, 0, 255) * kinectDepthScale;
  }
}

float getGrayDepthValue(int val) {
  return kinectLookupTable[val];
}

static final int gray(color value) { 
  return max((value >> 16) & 0xff, (value >> 8 ) & 0xff, value & 0xff);
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ 

int getLoc(float x, float y, int w) {
  return int(x) + int(y) * w;
}

color getColor(color[] px, float x, float y, int w) {
  return px[getLoc(x, y, w)];
}

float getZ(color[] px, float x, float y, int w) {
  return red(px[getLoc(x, y, w)]) * 2;
}

PVector getPos(PVector[] points, float x, float y, int w) {
  return points[getLoc(x, y, w)];
}

float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0;
}

int depth2rgb(short depth) {
  int r,g,b;

  float v = depth / 2047f;
  v = (float) Math.pow(v, 3)* 6;
  v = v*6*256;

  int pval = Math.round(v);
  int lb = pval & 0xff;
  switch (pval>>8) {
  case 0:
    b = 255;
    g = 255-lb;
    r = 255-lb;
    break;
  case 1:
    b = 255;
    g = lb;
    r = 0;
    break;
  case 2:
    b = 255-lb;
    g = 255;
    r = 0;
    break;
  case 3:
    b = 0;
    g = 255;
    r = lb;
    break;
  case 4:
    b = 0;
    g = 255-lb;
    r = 255;
    break;
  case 5:
    b = 0;
    g = 0;
    r = 255-lb;
    break;
  default:
    r = 0;
    g = 0;
    b = 0;
    break;
  }

  int pixel = (0xFF) << 24
      | (b & 0xFF) << 16
      | (g & 0xFF) << 8
      | (r & 0xFF) << 0;

  return pixel;
}

int depth2intensity(int depth) {//short depth) {
  float maxDepth = 8000f; //2047f;
  int d = round((1 - (depth / maxDepth)) * 255f);
  int pixel = (0xFF) << 24
      | (d & 0xFF) << 16
      | (d & 0xFF) << 8
      | (d & 0xFF) << 0;

  return pixel;
}

double fx_d = 1.0 / 5.9421434211923247e+02;
double fy_d = 1.0 / 5.9104053696870778e+02;
double cx_d = 3.3930780975300314e+02;
double cy_d = 2.4273913761751615e+02;
  
PVector depthToWorld(int x, int y, float [] depthLookUp, int depthValue) {
  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}

// http://shiffman.net/p5/kinect/

// depthInMeters = 1.0 / (rawDepth * -0.0030711016 + 3.3309495161);
// Rather than do this calculation all the time, we can precompute all of these
// values in a lookup table since there are only 2048 depth values.

float[] depthLookUp = new float[2048];

void setupDepthLookUp() {
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}
