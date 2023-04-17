class CollisionObj
{
  PVector pos;
  float size;
  color c_color;

  CollisionObj(PVector _pos, float _size, color _color)
  {
    pos = _pos;
    size = _size;
    c_color = _color;
  }



  void Draw()
  {
    pushMatrix();
    fill(c_color);
    noStroke();
    translate(pos.x, pos.y, pos.z);
    sphere(size);
    popMatrix();
  }


}
