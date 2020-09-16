import 'package:elpromediadorapp/models/consolidado.dart';
import 'package:flutter/material.dart';

class Notas extends StatefulWidget {
  static const routeName = '/notas';
  final _consolidado;
  Notas(this._consolidado);
  @override
  _NotasState createState() => _NotasState();
}

class _NotasState extends State<Notas> {
  Consolidado consolidado;
  int idCiclo;
  String codigoCursoExpanded;
  // Ciclo ciclo;
  List<int> listIdCiclos;
  PageController pageController = PageController(
    initialPage: 0,
  );
  @override
  void initState() {
    consolidado = widget._consolidado;
    listIdCiclos = consolidado.ciclos.map((ciclo) => ciclo.id).toList();
    listIdCiclos.sort((a, b) => b.compareTo(a));
    cambiarCiclo(consolidado.cicloActual);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              consolidado.nombre,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              consolidado.carrera,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Card(
              color: Colors.red,
              elevation: 7,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARRERA',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Prom. acumulado: ${calcularPromedioAcum()}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Prom. acum. actual: ${calcularPromedioAcum(actual: true)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Card(
              color: Colors.red,
              elevation: 7,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CICLO',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Ciclo: $idCiclo',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Total cursos: ${getCiclo().totalCursos}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Total créditos: ${getCiclo().totalCreditos}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Ciclo: ${getCiclo().estado}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    RaisedButton(
                      child: Text(
                        'CAMBIAR CICLO',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      onPressed: seleccionarCiclo,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ExpansionPanelList(
                  expandedHeaderPadding: EdgeInsets.symmetric(vertical: 0),
                  expansionCallback: (index, isExpanded) {
                    setState(() {
                      codigoCursoExpanded =
                          !isExpanded ? getCiclo().cursos[index].codigo : null;
                    });
                  },
                  children: getCiclo().cursos.map<ExpansionPanel>((curso) {
                    return ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text('${curso.codigo} - ${curso.nombre}'),
                        );
                      },
                      body: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: DataTable(
                                horizontalMargin: 0,
                                columnSpacing: 0,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Align(child: Text('Tipo')),
                                    ),
                                  ),
                                  DataColumn(label: Text('Evaluacion')),
                                  DataColumn(
                                    label: Expanded(
                                      child: Align(child: Text('N°')),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Align(child: Text('Peso')),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Align(child: Text('Nota')),
                                    ),
                                  ),
                                  DataColumn(label: Text('')),
                                ],
                                rows: List.generate(curso.notas.length,
                                    (index) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(curso.notas[index].tipo),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 170,
                                          child: Text(
                                            curso.notas[index].evaluacion,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          child: Text(
                                            curso.notas[index].numero
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          child: Text(
                                            curso.notas[index].peso.toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          child: Text(
                                            curso.notas[index].obs == null ||
                                                    curso.notas[index].obs ==
                                                        'P'
                                                ? curso.notas[index].nota
                                                    .toString()
                                                : curso.notas[index].obs,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 20,
                                            child: Icon(
                                              curso.notas[index].obs == 'P'
                                                  ? Icons.edit
                                                  : Icons.lock,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        onTap: curso.notas[index].obs == 'P'
                                            ? () {
                                                ingresarNota(
                                                    curso.codigo,
                                                    curso.notas[index].tipo,
                                                    curso.notas[index].numero,
                                                    curso.notas[index].nota);
                                              }
                                            : null,
                                      ),
                                    ],
                                  );
                                })
                                  ..add(DataRow(
                                    cells: [
                                      DataCell(Text('')),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Promedio',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text('')),
                                      DataCell(Text('')),
                                      DataCell(
                                        Align(
                                          child: Text(
                                            getNotaMask(
                                                calcularPromedioCurso(curso)),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text('')),
                                    ],
                                  )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      isExpanded: curso.codigo == codigoCursoExpanded,
                      canTapOnHeader: true,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Ciclo getCiclo() {
    return consolidado.ciclos.firstWhere((ciclo) => ciclo.id == idCiclo);
  }

  void cambiarCiclo(idNewCiclo) {
    idCiclo = idNewCiclo;
    codigoCursoExpanded = null;
  }

  void seleccionarCiclo() {
    int idCicloSeleccionado = idCiclo;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecciona el ciclo'),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listIdCiclos.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: listIdCiclos[index],
                      groupValue: idCicloSeleccionado,
                      onChanged: (id) {
                        setState(() {
                          cambiarCiclo(id);
                        });
                        Navigator.of(context).pop();
                      },
                      title: Text(
                        listIdCiclos[index].toString(),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('CANCELAR'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void ingresarNota(
      String codigoCurso, String tipoNota, int numeroNota, double notaActual) {
    TextEditingController notaController =
        new TextEditingController(text: notaActual.toString());
    notaController.selection =
        TextSelection(baseOffset: 0, extentOffset: notaController.text.length);
    submitaNota() {
      double nuevaNota = double.tryParse(notaController.text);
      if (nuevaNota == null) {
        notaController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: notaController.text.length,
        );
      } else {
        cambiarNota(codigoCurso, tipoNota, numeroNota, nuevaNota);
        Navigator.of(context).pop();
      }
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        bool notaValidate = true;
        return AlertDialog(
          title: Text('$codigoCurso - $tipoNota $numeroNota'),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          notaValidate = double.tryParse(text) != null;
                        });
                      },
                      autofocus: true,
                      controller: notaController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        labelText: 'Nota',
                        errorText: notaValidate ? null : 'Nota no válida',
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        submitaNota();
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: Text('Ingresar'),
                      onPressed: submitaNota,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void cambiarNota(
      String codigoCurso, String tipoNota, int numeroNota, double nuevaNota) {
    setState(() {
      consolidado.ciclos
          .firstWhere((ciclo) => ciclo.id == idCiclo)
          .cursos
          .firstWhere((curso) => curso.codigo == codigoCurso)
          .notas
          .firstWhere(
              (nota) => nota.tipo == tipoNota && nota.numero == numeroNota)
          .nota = nuevaNota;
    });
  }

  int calcularPromedioCurso(Curso curso) {
    if (curso.estado == "RETIRADO") {
      return -1;
    }
    return curso.notas
        .fold<double>(0, (acc, nota) => acc + nota.nota * nota.peso)
        .round();
  }

  String getNotaMask(int nota) {
    return nota >= 0 ? nota.toString() : "RET";
  }

  String calcularPromedioAcum({bool actual = false}) {
    List<Curso> cursos = consolidado.ciclos
        .where((ciclo) =>
            actual ? ciclo.estado != "RETIRADO" : ciclo.estado == "CERRADO")
        .expand((ciclo) => ciclo.cursos)
        .where((curso) =>
            actual ? curso.estado != "RETIRADO" : curso.estado == "CERRADO")
        .toList();
    double a = cursos.fold<double>(
        0, (acc, curso) => acc + calcularPromedioCurso(curso) * curso.creditos);
    double b = cursos.fold<double>(0, (acc, curso) => acc + curso.creditos);
    return (a / b).toStringAsFixed(2);
  }
}
