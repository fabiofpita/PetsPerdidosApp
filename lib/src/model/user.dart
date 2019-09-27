class User {
  String id;
  String nome;
  String sobrenome;
  String email;
  String telefone;

  User(this.nome, this.sobrenome, this.email, this.telefone);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        sobrenome = json['sobrenome'],
        email = json['email'],
        telefone = json['telefone'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'telefone': telefone,
      };
}
