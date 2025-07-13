ArrayList<MovingPoint> points;
PFont font;
String[] labels;

void setup() {
  size(1080, 720);
  font = createFont("조선일보명조", 14);
  textFont(font);
  textAlign(CENTER, CENTER);
  smooth();

  points = new ArrayList<MovingPoint>();

  // 별자리 이름 저장된 csv 파일 열기
  String[] lines = loadStrings("28celestial.csv");
  labels = subset(lines, 1); // 맨 윗줄 제외

  // 별자리 각각을 노드로
  for (int i = 0; i < labels.length; i++) {
    points.add(new MovingPoint(random(width), random(height), labels[i]));
  }

  // 랜덤하게 일반 점 생성 (1300개)
  for (int i = 0; i < 100; i++) {
    points.add(new MovingPoint(random(width), random(height), null));
  }
}

void draw() {
  background(0);

  // 업데이트 및 출력
  for (MovingPoint p : points) {
    p.update();
    p.display();
  }

  // 특정 거리 이하가 되면 선으로 연결되도록
  for (int i = 0; i < points.size(); i++) {
    MovingPoint a = points.get(i);
    for (int j = i + 1; j < points.size(); j++) {
      MovingPoint b = points.get(j);
      float d = dist(a.x, a.y, b.x, b.y);
      if (d < 80) {
        stroke(255, 60);
        line(a.x, a.y, b.x, b.y);
      }
    }
  }
}
//움직이는 점 클래스
class MovingPoint {
  float x, y;
  float vx, vy;
  String label;

  MovingPoint(float x, float y, String label) {
    this.x = x;
    this.y = y;
    this.label = label;
    this.vx = random(-0.5, 0.5); // x축 방향 무작위 속도 설정
    this.vy = random(-0.5, 0.5); // y축 방향 무작위 속도 설정
  }
// 위치 업데이트
  void update() {
    x += vx;
    y += vy;
    if (x < 0 || x > width) vx *= -1; //화면 끝에 닿으면 반대로 이동
    if (y < 0 || y > height) vy *= -1;
  }

  void display() {
    if (label != null) {   //화면에 텍스트 출력
      fill(255);
      text(label, x, y);
    } else {               //화면에 점(별)출력
      noStroke();
      fill(255);
      ellipse(x, y, 1, 1);
    }
  }
}
