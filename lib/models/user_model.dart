class UserModel {
  final String id;
  final String? nome;
  final String? email;
  final String? cursoId;
  final String? matricula;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    this.nome,
    this.email,
    this.cursoId,
    this.matricula,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nome: json['nome'],
      email: json['email'],
      cursoId: json['curso_id']?.toString(),
      matricula: json['matricula'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'curso_id': cursoId,
      'matricula': matricula,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? cursoId,
    String? matricula,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      cursoId: cursoId ?? this.cursoId,
      matricula: matricula ?? this.matricula,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nome: $nome, email: $email, cursoId: $cursoId, matricula: $matricula)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 