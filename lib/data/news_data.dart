class NewsData {
  static List<Map<String, dynamic>> getNoticias() {
    return [
      {
        'img': 'assets/images/semanacademica.jfif',
        'title': 'Semana Acadêmica',
        'desc': 'Participe das palestras e workshops de 12 a 16 de junho!',
        'data': '12 a 16 de junho',
        'local': 'Auditório Principal',
        'horario': '08:00 às 18:00',
        'detalhes': 'A Semana Acadêmica deste ano traz uma programação especial com palestras sobre inovação tecnológica, workshops práticos de desenvolvimento e networking com empresas parceiras. Não perca esta oportunidade única de expandir seus conhecimentos e fazer conexões importantes para sua carreira.',
        'categoria': 'Evento Acadêmico',
      },
      {
        'img': 'assets/images/cantina.jfif',
        'title': 'Novo Restaurante Universitário',
        'desc': 'Inauguração nesta sexta-feira, às 11h.',
        'data': 'Sexta-feira',
        'local': 'Bloco A - Térreo',
        'horario': '11:00',
        'detalhes': 'O novo Restaurante Universitário oferece um cardápio diversificado com opções vegetarianas, veganas e tradicionais. Com capacidade para 200 pessoas, o espaço conta com ambiente climatizado, Wi-Fi gratuito e horário de funcionamento das 7h às 19h.',
        'categoria': 'Infraestrutura',
      },
      {
        'img': 'assets/images/edital.jfif',
        'title': 'Edital de Bolsas',
        'desc': 'Inscrições abertas até 20/06 para bolsas de pesquisa.',
        'data': 'Até 20 de junho',
        'local': 'Pró-Reitoria de Pesquisa',
        'horario': '08:00 às 17:00',
        'detalhes': 'Estão abertas as inscrições para bolsas de iniciação científica, mestrado e doutorado. O programa oferece bolsas de R\$ 400 a R\$ 2.200 dependendo do nível. Os projetos devem estar alinhados com as áreas prioritárias da universidade.',
        'categoria': 'Bolsa de Estudos',
      },
    ];
  }
} 