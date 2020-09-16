class Consolidado {
  String carrera;
  int cicloActual;
  List<Ciclo> ciclos;
  String codigo;
  String nombre;

  Consolidado(
      {this.carrera, this.cicloActual, this.ciclos, this.codigo, this.nombre});

  Consolidado.fromJson(Map<String, dynamic> json) {
    carrera = json['carrera'];
    cicloActual = json['ciclo_actual'];
    if (json['ciclos'] != null) {
      ciclos = new List<Ciclo>();
      json['ciclos'].forEach((v) {
        ciclos.add(new Ciclo.fromJson(v));
      });
    }
    codigo = json['codigo'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carrera'] = this.carrera;
    data['ciclo_actual'] = this.cicloActual;
    if (this.ciclos != null) {
      data['ciclos'] = this.ciclos.map((v) => v.toJson()).toList();
    }
    data['codigo'] = this.codigo;
    data['nombre'] = this.nombre;
    return data;
  }
}

class Ciclo {
  List<Curso> cursos;
  String estado;
  int id;
  int nivel;
  int totalCreditos;
  int totalCursos;

  Ciclo(
      {this.cursos,
      this.estado,
      this.id,
      this.nivel,
      this.totalCreditos,
      this.totalCursos});

  Ciclo.fromJson(Map<String, dynamic> json) {
    if (json['cursos'] != null) {
      cursos = new List<Curso>();
      json['cursos'].forEach((v) {
        cursos.add(new Curso.fromJson(v));
      });
    }
    estado = json['estado'];
    id = json['id'];
    nivel = json['nivel'];
    totalCreditos = json['total_creditos'];
    totalCursos = json['total_cursos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cursos != null) {
      data['cursos'] = this.cursos.map((v) => v.toJson()).toList();
    }
    data['estado'] = this.estado;
    data['id'] = this.id;
    data['nivel'] = this.nivel;
    data['total_creditos'] = this.totalCreditos;
    data['total_cursos'] = this.totalCursos;
    return data;
  }
}

class Curso {
  String codigo;
  int creditos;
  String estado;
  String nombre;
  List<Nota> notas;

  Curso({this.codigo, this.creditos, this.estado, this.nombre, this.notas});

  Curso.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    creditos = json['creditos'];
    estado = json['estado'];
    nombre = json['nombre'];
    if (json['notas'] != null) {
      notas = new List<Nota>();
      json['notas'].forEach((v) {
        notas.add(new Nota.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['creditos'] = this.creditos;
    data['estado'] = this.estado;
    data['nombre'] = this.nombre;
    if (this.notas != null) {
      data['notas'] = this.notas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nota {
  String evaluacion;
  double nota;
  int numero;
  String obs;
  double peso;
  String tipo;

  Nota(
      {this.evaluacion,
      this.nota,
      this.numero,
      this.obs,
      this.peso,
      this.tipo});

  Nota.fromJson(Map<String, dynamic> json) {
    evaluacion = json['evaluacion'];
    nota = json['nota'];
    numero = json['numero'];
    obs = json['obs'];
    peso = json['peso'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['evaluacion'] = this.evaluacion;
    data['nota'] = this.nota;
    data['numero'] = this.numero;
    data['obs'] = this.obs;
    data['peso'] = this.peso;
    data['tipo'] = this.tipo;
    return data;
  }
}
