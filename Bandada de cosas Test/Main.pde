int avatarNum = 7;
Particle[] particleArr;
float deltaTime;
PVector posDest;

void setup()
{
  size(2000 , 2000, P3D);
  particleArr = new Particle[avatarNum];
  posDest = new PVector(width/2, height/2, 10.0);
  for (int i = 0; i < avatarNum; i++)
  {
    float randomKB = random(1);
    float randomKD = 1 - randomKB;
    println("KB = " + randomKB + " y el KD = " + randomKD);
    particleArr[i] = new Particle(new PVector(random(20), random(20), 10), new PVector(), 0.7f, 30f, color(random(255), random(255), random(255)), randomKB, randomKD);
  }

  deltaTime = 0.04;
}

void draw()
{
  background(0);
  posDest = new PVector(mouseX, mouseY, 10);
  DrawDest(posDest);
  for (int i = 0; i < avatarNum; i++)
  {
    particleArr[i].Move(posDest);
    particleArr[i].Draw();
  }
}


void DrawDest(PVector dir)
{
  strokeWeight(3);
  noFill();
  stroke(255, 0, 255);
  
  pushMatrix();
  translate(dir.x, dir.y, dir.z);
  box(60);
  popMatrix();
}

PVector UnitaryVector(PVector start, PVector end)
{
  PVector result = new PVector();

  result.x = end.x - start.x;
  result.y = end.y - start.y;
  result.z = end.z - start.z;

  float mod = sqrt(result.x * result.x + result.y * result.y + result.z * result.z );

  result.x /= mod;
  result.y /= mod;
  result.z /= mod;


  return result;
}

PVector FlockCenter()
{
  PVector result;
  result = new PVector(0.0, 0.0, 0.0);

  for (int i = 0; i < avatarNum; i++)
  {
    result.x += particleArr[i].pos.x;
    result.y += particleArr[i].pos.y;
    result.z += particleArr[i].pos.z;
  }

  result.x /= avatarNum;
  result.y /= avatarNum;
  result.z /= avatarNum;


  return result;
}
