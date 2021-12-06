
/* -------- CODE FOR PATH COLLISION DETECTION --------- */

float pointDistToLine(PVector start, PVector end, PVector point) {
  // Code from https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
  float l2 = (start.x - end.x) * (start.x - end.x) + (start.y - end.y) * (start.y - end.y);  // i.e. |w-v|^2 -  avoid a sqrt
  if (l2 == 0.0) return dist(end.x, end.y, point.x, point.y);   // v == w case
  float t = max(0, min(1, PVector.sub(point, start).dot(PVector.sub(end, start)) / l2));
  PVector projection = PVector.add(start, PVector.mult(PVector.sub(end, start), t));  // Projection falls on the segment
  return dist(point.x, point.y, projection.x, projection.y);
}

float shortestDist(PVector point) {
  float answer = Float.MAX_VALUE;
  for (int i = 0; i < points.size() - 1; i++) {
    PVector start = points.get(i);
    PVector end = points.get(i + 1);
    float distance = pointDistToLine(start, end, point);
    answer = min(answer, distance);
  }
  return answer;
}

// ------- CODE FOR THE PATH
ArrayList<PVector> points = new ArrayList<PVector>(); // The points on the path, in order.
final float PATH_RADIUS = 20;
void addPointToPath(float x, float y) {
  points.add(new PVector(x, y));
}

void initPath() {
  addPointToPath(0, 200);
  addPointToPath(50, 200);
  addPointToPath(200, 150);
  addPointToPath(350, 200);
  addPointToPath(500, 150);
  addPointToPath(650, 200);
  addPointToPath(650, 300);
  addPointToPath(500, 250);
  addPointToPath(350, 300);
  addPointToPath(200, 250);
  addPointToPath(50, 300);
  addPointToPath(50, 400);
  addPointToPath(200, 350);
  addPointToPath(350, 400);
  addPointToPath(500, 350);
  addPointToPath(650, 400);
  addPointToPath(800, 350);
}

void drawPath() {
  stroke(#4C6710);
  strokeWeight(PATH_RADIUS * 2 + 1);
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
  }

  stroke(#7b9d32);
  strokeWeight(PATH_RADIUS * 2);
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
  }
}

HashMap<Float, PVector> dp = new HashMap<Float, PVector>();
// GIVEN TO PARTICIPANTS BY DEFAULT
PVector getLocation(float travelDistance)
{
  PVector memoized = dp.get(travelDistance);
  if (memoized != null) {
    return memoized;
  }
  float originalDist = travelDistance;
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    float distance = dist(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
    if (distance <= EPSILON || travelDistance >= distance) {
      travelDistance -= distance;
    } else {
      // In between two points
      float travelProgress = travelDistance / distance;
      float xDist = nextPoint.x - currentPoint.x;
      float yDist = nextPoint.y - currentPoint.y;
      float x = currentPoint.x + xDist * travelProgress;
      float y = currentPoint.y + yDist * travelProgress;
      dp.put(originalDist, new PVector(x, y));
      return new PVector(x, y);
    }
  }
  // At end of path
  dp.put(originalDist, points.get(points.size() - 1));
  return points.get(points.size() - 1);
}
