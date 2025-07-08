class AppConstants {
  // Nomes dos períodos
  static const String PERIODO_MATUTINO = 'Matutino';
  static const String PERIODO_VESPERTINO = 'Vespertino';
  static const String PERIODO_NOTURNO = 'Noturno';
  
  // Valores dos períodos
  static const int PERIODO_MATUTINO_VALUE = 1;
  static const int PERIODO_VESPERTINO_VALUE = 2;
  static const int PERIODO_NOTURNO_VALUE = 3;
  
  // Horários das aulas
  static const Map<int, List<Map<String, String>>> HORARIOS_AULAS = {
    1: [ // Matutino
      {'inicio': '08:00', 'fim': '09:40'},
      {'inicio': '09:55', 'fim': '11:35'},
    ],
    2: [ // Vespertino
      {'inicio': '13:00', 'fim': '14:40'},
      {'inicio': '14:55', 'fim': '16:35'},
    ],
    3: [ // Noturno
      {'inicio': '19:00', 'fim': '20:40'},
      {'inicio': '20:55', 'fim': '22:35'},
    ],
  };
  
  // Dias da semana
  static const List<String> DIAS_SEMANA = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
  ];
  
  static const List<String> DIAS_SEMANA_ABREVIADO = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
  ];
  
  // Categorias de notícias
  static const String CATEGORIA_EVENTO_ACADEMICO = 'Evento Acadêmico';
  static const String CATEGORIA_INFRAESTRUTURA = 'Infraestrutura';
  static const String CATEGORIA_BOLSA_ESTUDOS = 'Bolsa de Estudos';
  
  // Mensagens padrão
  static const String MSG_CARREGANDO = 'Carregando...';
  static const String MSG_ERRO_GENERICO = 'Ocorreu um erro. Tente novamente.';
  static const String MSG_SEM_DADOS = 'Nenhum dado encontrado.';
  static const String MSG_SEM_AULAS = 'Sem aulas hoje! 🎉';
  static const String MSG_APROVEITE_TEMPO = 'Aproveite para descansar ou estudar em casa.';
  
  // Títulos das páginas
  static const String TITULO_HOME = 'Início';
  static const String TITULO_AGENDA = 'Minha Agenda';
  static const String TITULO_PERFIL = 'Perfil';
  static const String TITULO_BUSCAR_SALA = 'Buscar Sala';
  static const String TITULO_MAPA = 'Mapa do Campus';
  
  // Textos dos botões
  static const String BTN_SABER_MAIS = 'Saber Mais';
  static const String BTN_FECHAR = 'Fechar';
  static const String BTN_CANCELAR = 'Cancelar';
  static const String BTN_CONFIRMAR = 'Confirmar';
  static const String BTN_SALVAR = 'Salvar';
  static const String BTN_EDITAR = 'Editar';
  static const String BTN_EXCLUIR = 'Excluir';
  
  // Placeholders
  static const String PLACEHOLDER_BUSCAR = 'Buscar...';
  static const String PLACEHOLDER_EMAIL = 'Digite seu email';
  static const String PLACEHOLDER_SENHA = 'Digite sua senha';
  static const String PLACEHOLDER_NOME = 'Digite seu nome';
  
  // Validações
  static const String VALIDACAO_EMAIL_OBRIGATORIO = 'Email é obrigatório';
  static const String VALIDACAO_EMAIL_INVALIDO = 'Email inválido';
  static const String VALIDACAO_SENHA_OBRIGATORIA = 'Senha é obrigatória';
  static const String VALIDACAO_SENHA_MINIMA = 'Senha deve ter pelo menos 6 caracteres';
  static const String VALIDACAO_NOME_OBRIGATORIO = 'Nome é obrigatório';
  
  // Configurações do app
  static const int TIMEOUT_API = 30000; // 30 segundos
  static const int TIMER_CARROSSEL = 2000; // 2 segundos
  static const double OPACIDADE_PADRAO = 0.8;
  static const double OPACIDADE_BAIXA = 0.6;
  static const double OPACIDADE_ALTA = 0.9;
  
  // Animações
  static const Duration DURACAO_ANIMACAO_RAPIDA = Duration(milliseconds: 200);
  static const Duration DURACAO_ANIMACAO_NORMAL = Duration(milliseconds: 300);
  static const Duration DURACAO_ANIMACAO_LENTA = Duration(milliseconds: 500);
  
  // Tamanhos
  static const double TAMANHO_ICONE_PEQUENO = 16.0;
  static const double TAMANHO_ICONE_NORMAL = 24.0;
  static const double TAMANHO_ICONE_GRANDE = 32.0;
  static const double TAMANHO_ICONE_MUITO_GRANDE = 48.0;
  
  // Limites
  static const int LIMITE_CARACTERES_NOME = 100;
  static const int LIMITE_CARACTERES_DESCRICAO = 500;
  static const int LIMITE_ITENS_LISTA = 50;
} 