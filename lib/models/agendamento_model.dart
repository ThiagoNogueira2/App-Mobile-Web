class AgendamentoModel {
  final String id;
  final String dia;
  final String? aulaPeriodo;
  final String? horaInicio;
  final String? horaFim;
  final int? periodo;
  final String? cursoId;
  final String? salaId;
  final String? materiaId;
  final String? professorId;
  final CursoModel? curso;
  final SalaModel? sala;
  final MateriaModel? materia;
  final ProfessorModel? professor;

  AgendamentoModel({
    required this.id,
    required this.dia,
    this.aulaPeriodo,
    this.horaInicio,
    this.horaFim,
    this.periodo,
    this.cursoId,
    this.salaId,
    this.materiaId,
    this.professorId,
    this.curso,
    this.sala,
    this.materia,
    this.professor,
  });

  factory AgendamentoModel.fromJson(Map<String, dynamic> json) {
    return AgendamentoModel(
      id: json['id'] ?? '',
      dia: json['dia'] ?? '',
      aulaPeriodo: json['aula_periodo'],
      horaInicio: json['hora_inicio'],
      horaFim: json['hora_fim'],
      periodo: json['periodo'],
      cursoId: json['curso_id']?.toString(),
      salaId: json['sala_id']?.toString(),
      materiaId: json['materia_id']?.toString(),
      professorId: json['professor_id']?.toString(),
      curso: json['cursos'] != null ? CursoModel.fromJson(json['cursos']) : null,
      sala: json['salas'] != null ? SalaModel.fromJson(json['salas']) : null,
      materia: json['materias'] != null ? MateriaModel.fromJson(json['materias']) : null,
      professor: json['professores'] != null ? ProfessorModel.fromJson(json['professores']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dia': dia,
      'aula_periodo': aulaPeriodo,
      'hora_inicio': horaInicio,
      'hora_fim': horaFim,
      'periodo': periodo,
      'curso_id': cursoId,
      'sala_id': salaId,
      'materia_id': materiaId,
      'professor_id': professorId,
      'cursos': curso?.toJson(),
      'salas': sala?.toJson(),
      'materias': materia?.toJson(),
      'professores': professor?.toJson(),
    };
  }

  @override
  String toString() {
    return 'AgendamentoModel(id: $id, dia: $dia, aulaPeriodo: $aulaPeriodo, horaInicio: $horaInicio, horaFim: $horaFim)';
  }
}

class CursoModel {
  final String id;
  final String? curso;
  final int? semestre;
  final int? periodo;

  CursoModel({
    required this.id,
    this.curso,
    this.semestre,
    this.periodo,
  });

  factory CursoModel.fromJson(Map<String, dynamic> json) {
    return CursoModel(
      id: json['id'] ?? '',
      curso: json['curso'],
      semestre: json['semestre'],
      periodo: json['periodo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'curso': curso,
      'semestre': semestre,
      'periodo': periodo,
    };
  }
}

class SalaModel {
  final String id;
  final String? numeroSala;

  SalaModel({
    required this.id,
    this.numeroSala,
  });

  factory SalaModel.fromJson(Map<String, dynamic> json) {
    return SalaModel(
      id: json['id'] ?? '',
      numeroSala: json['numero_sala'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_sala': numeroSala,
    };
  }
}

class MateriaModel {
  final String id;
  final String? nome;

  MateriaModel({
    required this.id,
    this.nome,
  });

  factory MateriaModel.fromJson(Map<String, dynamic> json) {
    return MateriaModel(
      id: json['id'] ?? '',
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}

class ProfessorModel {
  final String id;
  final String? nomeProfessor;

  ProfessorModel({
    required this.id,
    this.nomeProfessor,
  });

  factory ProfessorModel.fromJson(Map<String, dynamic> json) {
    return ProfessorModel(
      id: json['id'] ?? '',
      nomeProfessor: json['nome_professor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome_professor': nomeProfessor,
    };
  }
} 