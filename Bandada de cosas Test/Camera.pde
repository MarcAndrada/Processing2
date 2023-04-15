void CameraBehaviour() {

  //Variables de velocidad de movimiento y de rotacion de la cammara
  float camSpeed = 4, camRotSpeed = 0.01;

  //Dibujamos un texto con los Controles
  text("Flecha : [ARRIBA],[ABAJO] : Mirar Arriba/Abajo", 10, 20);
  text("Flecha : [LEFT],[RIGHT] : Mirar Izquierda/Derecha", 10, 35);
  text("[W],[S] : Moverse Adelante/Atras", 10, 50);
  text("[A],[D] : Moverse Iquierda/Derecha", 10, 65 );
  text("[Q],[E] : Moverse Arriba/Abajo", 10, 80 );

  if ( !keyPressed ) return;

  PMatrix3D M = new PMatrix3D();

  if ( key == 'w' ) {
    M.translate( 0, 0, camSpeed );
  }

  if ( key == 's' ) {
    M.translate( 0, 0, -camSpeed );
  }

  if ( key == 'a' ) {
    M.translate( camSpeed, 0, 0 );
  }

  if ( key == 'd' ) {
    M.translate( -camSpeed, 0, 0 );
  }
  if ( key == 'q' ) {
    M.translate( 0, camSpeed, 0 );
  }
  if ( key == 'e' ) {
    M.translate( 0, -camSpeed, 0 );
  }

  if ( keyCode == PConstants.UP ) {
    M.rotateX(camRotSpeed);
  }
  if ( keyCode == PConstants.DOWN ) {
    M.rotateX(-camRotSpeed);
  }
  if ( keyCode == PConstants.RIGHT ) {
    M.rotateY(camRotSpeed);
  }
  if ( keyCode == PConstants.LEFT ) {
    M.rotateY(-camRotSpeed);
  }

  // Editamos la matriz de la camara
  PMatrix3D C = ((PGraphicsOpenGL)(g)).camera.get(); // Copiamos la matriz de la camara para editarla desde una variable
  C.preApply(M);

  // Corregimos la matriz papara definir el vector de arriba (0,1,0)
  C.invert();

  float ex = C.m03;
  float ey = C.m13;
  float ez = C.m23;
  float cx = -C.m02 + ex;
  float cy = -C.m12 + ey;
  float cz = -C.m22 + ez;

  camera( ex, ey, ez, cx, cy, cz, 0, 1, 0 );
}
