int avatarNum = 7;
Particle[] particleArr;
float deltaTime;
PVector posDest;

void setup()
{
  size(800, 600);
  particleArr = new Particle[avatarNum];
  posDest = new PVector(width/2, height/2, 0.0);
  for (int i = 0; i < avatarNum; i++)
  {
    particleArr[i] = new Particle(new PVector(random(500), random(500)), new PVector(), 1f, 30f, color(random(255), random(255), random(255)));
  }

  deltaTime = 0.04;
}

void draw()
{
  background(0);

  DrawDest(posDest);
  for (int i = 0; i < avatarNum; i++)
  {
    if (i == 6)
    {
      particleArr[i].Move();
    }
    particleArr[i].Draw();
  }
}


void DrawDest(PVector dir)
{
  strokeWeight(3);
  noFill();
  stroke(255, 0, 255);
  rectMode(CENTER);
  rect(dir.x, dir.y, 60, 60);
}

PVector UnitaryVector(PVector start, PVector end)
{
  PVector result = new PVector();

  result.x = end.x - start.x;
  result.y = end.y - start.y;

  float mod = sqrt(result.x * result.x + result.y * result.y);

  result.x /= mod;
  result.y /= mod;

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
  }

  result.x /= avatarNum;
  result.y /= avatarNum;

  return result;
}
