class CollisionObj
{
  //Los obstaculos son muy simples, simplemente tendremos una posicion donde esten ubicados, tamanyo y color
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
    strokeWeight(1);
    stroke(0,0,0);
    translate(pos.x, pos.y, pos.z);
    sphere(size);
    popMatrix();
  }


}
