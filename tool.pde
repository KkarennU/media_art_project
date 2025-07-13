PImage img;
float imgX, imgY;

ArrayList<PVector> clickedPoints = new ArrayList<PVector>();
PrintWriter csvWriter;

void setup() {
  size(1080, 720, P2D);
  smooth(8); // 이미지 화질저하 방지
  
  img = loadImage("your_image.jpg");  // 이미지 크기: 1080x720

  // 이미지 중앙 정렬
  imgX = (width - img.width) / 2.0;
  imgY = (height - img.height) / 2.0;

  csvWriter = createWriter("clicked_points.csv"); //csv 파일에 쓰기
  csvWriter.println("x,y"); 
}

void draw() {
  background(255);

  // 이미지 정중앙에 표시. 이미지는 좌표 저장과 무관. 사용자가 보는 것만을 목적으로
  image(img, imgX, imgY);

  // 찍은 점들 표시
  drawPoints();
}

void drawPoints() {
  fill(255, 0, 0);
  noStroke();
  for (PVector pt : clickedPoints) {
    ellipse(pt.x, pt.y, 8, 8); // 클릭한 별에 대해 (8,8) 사이즈의 원 그리기
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    float x = mouseX;
    float y = mouseY;

    // 이미지와 상관없이 캔버스 전체 좌표를 저장
    clickedPoints.add(new PVector(x, y));
    csvWriter.println(nf(x, 1, 2) + "," + nf(y, 1, 2));
    csvWriter.flush();

    println("좌표 저장: " + x + ", " + y);
  } 
  else if (mouseButton == RIGHT) {
    // 별자리 구분자 (빈 줄)
    csvWriter.println();
    csvWriter.flush();
    println("별자리 구분 (빈 줄 추가)");
  }
}

void exit() {
  csvWriter.flush();
  csvWriter.close();
  super.exit();
}
