ArrayList<RotatingPoint> rotatingPoints = new ArrayList<RotatingPoint>();
float centerX, centerY;
float twinkleTime = 0; //반짝이는 효과 변수
float t = 0; // 은하수 시간값

void setup() {
  size(1080, 720, P2D);
  smooth(2);
  colorMode(RGB);
  noStroke();
  centerX = width / 2;
  centerY = height / 2;

  loadPointsFromCSV("clicked_points.csv", "normal");   // 나머지 별 좌표 불러오기
  loadPointsFromCSV("summer_points.csv", "twinkle");   // 여름 별자리 좌표 불러오기
}

void draw() {
  drawGalaxyBackground(); // 은하수 배경 먼저 그리기 --> 

  // 테두리 원
  noFill();
  stroke(80);
  strokeWeight(1);
  ellipse(width/2, height/2, 650, 650); // 테두리 그리기
  ellipse(width/2, height/2, 645, 645);
  ellipse(width/2, height/2, 585, 585);
  ellipse(width/2, height/2, 580, 580);

  // 반짝이는 효과: 여름멸자리의 투명도 값. 주기적으로 투명도 변화해서 반짝이는 것처럼 표현
  twinkleTime += 0.05;
  float alphaVal = map(sin(twinkleTime), -1, 1, 100, 255);

  // 별 그리기
  for (RotatingPoint pt : rotatingPoints) {
    pt.update();
    pt.display(alphaVal);
  }
}

// 배경(은하수)
void drawGalaxyBackground() {
  loadPixels();
  color[] palette = {
    color(0, 0, 0),       // 검정
    color(23, 0, 100)     // 남색
  };
  // 노이즈 효과로 위의 두 색 혼합
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float n = noise(x * 0.003, y * 0.003, t);
      float segment = 1.0 / (palette.length - 1);
      int index = int(n / segment);
      index = constrain(index, 0, palette.length - 2);
      float amt = (n - index * segment) / segment;
      color c = lerpColor(palette[index], palette[index + 1], amt);
      pixels[x + y * width] = c;
    }
  }
  updatePixels();
  t += 0.01;
}

// 회전하는 별 클래스
class RotatingPoint {
  float radius, angle, speed;
  String type;
// 회전시키기
  RotatingPoint(float x, float y, String type) {
    float dx = x - centerX;
    float dy = y - centerY;
    radius = dist(x, y, centerX, centerY);
    angle = atan2(dy, dx);
    speed = radians(0.03);
    this.type = type;
  }

  void update() {
    angle -= speed;
  }

  void display(float alphaVal) {
    float x = centerX + cos(angle) * radius;
    float y = centerY + sin(angle) * radius;
// (2, 2)원으로 별그리기: 여름별자리는 투명도 alphaVal로 받고 나머지 별은 투명도 70
    noStroke();
    if (type.equals("normal")) {
      fill(255, 70);
      ellipse(x, y, 2, 2);
    } else if (type.equals("twinkle")) {
      fill(255, alphaVal);
      ellipse(x, y, 2, 2);
    }
  }
}

// 별 좌표 csv 파일 불러오기
void loadPointsFromCSV(String filename, String type) {
  String[] rows = loadStrings(filename);
  if (rows == null) {
    println("⚠️ 파일 없음: " + filename);
    return;
  }

  for (int i = 1; i < rows.length; i++) {
    String row = rows[i].trim();
    if (row.equals("")) continue;

    String[] parts = split(row, ',');
    if (parts.length == 2) {
      float x = float(parts[0]);
      float y = float(parts[1]);
      rotatingPoints.add(new RotatingPoint(x, y, type));
    }
  }

  println("✔ " + filename + " 로딩 완료 (" + type + ")");
}
