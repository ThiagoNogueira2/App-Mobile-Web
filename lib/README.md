# 🏗️ Estrutura Completa do Projeto

Este projeto foi completamente refatorado para melhor organização, manutenibilidade e escalabilidade. Aqui está a estrutura completa:

## 📁 Estrutura de Pastas

### `/lib/pages/`
- **`home_pages.dart`** - Página principal com navegação entre abas
- **`home_page.dart`** - Página inicial (Home) refatorada
- **`agenda_page.dart`** - Página da agenda separada
- **`perfil_page.dart`** - Página do perfil (existente)
- **`login_pages.dart`** - Página de login
- **`register_page.dart`** - Página de registro
- **`welcome_page.dart`** - Página de boas-vindas
- **`buscarsala_page.dart`** - Página de busca de salas

### `/lib/widgets/`
Componentes reutilizáveis organizados por funcionalidade:

- **`home_header.dart`** - Header da página inicial com gradiente
- **`quick_access_buttons.dart`** - Botões de acesso rápido
- **`next_class_card.dart`** - Card da próxima aula
- **`carousel_news.dart`** - Carrossel de notícias
- **`important_notices.dart`** - Seção de avisos importantes
- **`news_modal.dart`** - Modal de detalhes das notícias

### `/lib/data/`
- **`news_data.dart`** - Dados das notícias do carrossel

### `/lib/models/`
- **`user_model.dart`** - Modelo de dados do usuário
- **`agendamento_model.dart`** - Modelo de dados dos agendamentos

### `/lib/services/`
- **`api_service.dart`** - Serviço de API para Supabase

### `/lib/utils/`
- **`app_colors.dart`** - Constantes de cores do app
- **`app_text_styles.dart`** - Estilos de texto padronizados
- **`app_spacing.dart`** - Dimensões e espaçamentos
- **`app_constants.dart`** - Constantes gerais do app
- **`app_utils.dart`** - Utilitários e funções auxiliares
- **`app_dimensions.dart`** - Dimensões e constantes do app (existente)

### `/lib/auth/`
- **`auth_gate.dart`** - Controle de autenticação
- **`auth_service.dart`** - Serviço de autenticação

### `/lib/routes/`
- **`routes.dart`** - Configuração de rotas

## 📁 Estrutura de Pastas

### `/lib/pages/`
- **`home_pages.dart`** - Página principal com navegação entre abas
- **`home_page.dart`** - Página inicial (Home) refatorada
- **`agenda_page.dart`** - Página da agenda separada
- **`perfil_page.dart`** - Página do perfil (existente)

### `/lib/widgets/`
Componentes reutilizáveis organizados por funcionalidade:

- **`home_header.dart`** - Header da página inicial com gradiente
- **`quick_access_buttons.dart`** - Botões de acesso rápido
- **`next_class_card.dart`** - Card da próxima aula
- **`carousel_news.dart`** - Carrossel de notícias
- **`important_notices.dart`** - Seção de avisos importantes
- **`news_modal.dart`** - Modal de detalhes das notícias

### `/lib/data/`
- **`news_data.dart`** - Dados das notícias do carrossel

### `/lib/auth/`
- **`auth_gate.dart`** - Controle de autenticação
- **`auth_service.dart`** - Serviço de autenticação

### `/lib/utils/`
- **`app_dimensions.dart`** - Dimensões e constantes do app

## 🔧 Como Usar

### Adicionando uma Nova Notícia
1. Abra `lib/data/news_data.dart`
2. Adicione um novo item no array `getNoticias()`
3. Inclua todos os campos necessários: `img`, `title`, `desc`, `data`, `local`, `horario`, `detalhes`, `categoria`

### Modificando o Header da Home
1. Edite `lib/widgets/home_header.dart`
2. As mudanças serão refletidas automaticamente na página inicial

### Alterando o Card da Próxima Aula
1. Edite `lib/widgets/next_class_card.dart`
2. O componente busca dados do Supabase automaticamente

### Personalizando o Carrossel
1. Edite `lib/widgets/carousel_news.dart`
2. O componente já inclui auto-scroll e indicador de clique

## 🎨 Funcionalidades Implementadas

### Carrossel de Notícias
- ✅ Auto-scroll a cada 2 segundos
- ✅ Indicador visual de clique
- ✅ Modal com detalhes completos
- ✅ Imagens clicáveis
- ✅ Informações detalhadas por categoria

### Agenda
- ✅ Seletor de dias da semana
- ✅ Busca de agendamentos por dia
- ✅ Layout responsivo e moderno
- ✅ Informações completas das aulas

### Home
- ✅ Header com gradiente moderno
- ✅ Botões de acesso rápido
- ✅ Card da próxima aula
- ✅ Carrossel de notícias
- ✅ Seção de avisos importantes

## 📱 Navegação

O app usa um `BottomNavigationBar` com três abas:
1. **Início** - Página principal com todas as funcionalidades
2. **Agenda** - Visualização da agenda semanal
3. **Perfil** - Página do perfil do usuário

## 🔄 Estado e Dados

- **Supabase** - Banco de dados para agendamentos e usuários
- **Estado Local** - Gerenciado pelo Flutter para UI
- **Dados Estáticos** - Notícias e configurações em arquivos separados

## 🚀 Próximos Passos

Para adicionar novas funcionalidades:
1. Crie novos widgets em `/lib/widgets/`
2. Adicione novas páginas em `/lib/pages/` se necessário
3. Organize dados em `/lib/data/`
4. Mantenha a estrutura modular para fácil manutenção

## 🎨 Design System

### Cores Principais
- **Primary**: `#2563EB` (Azul)
- **Secondary**: `#6366F1` (Índigo)
- **Success**: `#10B981` (Verde)
- **Warning**: `#F59E0B` (Amarelo)
- **Error**: `#EF4444` (Vermelho)

### Tipografia
- **H1-H6**: Títulos com pesos diferentes
- **Body**: Texto do corpo com diferentes tamanhos
- **Label**: Textos de destaque
- **Button**: Estilos para botões

### Espaçamentos
- **XS**: 4px, **SM**: 8px, **MD**: 16px
- **LG**: 24px, **XL**: 32px, **XXL**: 48px

## 🔧 Funcionalidades Implementadas

### ✅ Concluído
- [x] Refatoração completa da estrutura
- [x] Carrossel de notícias clicável
- [x] Modal de detalhes das notícias
- [x] Sistema de cores padronizado
- [x] Tipografia consistente
- [x] Espaçamentos padronizados
- [x] Modelos de dados estruturados
- [x] Serviço de API para Supabase
- [x] Utilitários e constantes
- [x] Componentes modulares
- [x] Navegação entre páginas

### 🚧 Em Desenvolvimento
- [ ] Integração completa com Supabase
- [ ] Sistema de notificações
- [ ] Cache offline
- [ ] Testes automatizados
- [ ] Temas claro/escuro

## 📱 Responsividade

O app é responsivo e funciona em:
- 📱 Smartphones (Android/iOS)
- 💻 Tablets
- 🖥️ Web (PWA)

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework principal
- **Dart**: Linguagem de programação
- **Supabase**: Backend e autenticação
- **Material Design**: Design system
- **Provider/Riverpod**: Gerenciamento de estado (futuro)

## 📋 Próximos Passos

1. **Integração com Supabase**
   - Conectar com banco de dados real
   - Implementar autenticação
   - Sincronização de dados

2. **Melhorias de UX**
   - Animações mais fluidas
   - Feedback tátil
   - Loading states

3. **Funcionalidades Avançadas**
   - Notificações push
   - Modo offline
   - Compartilhamento de horários

4. **Otimizações**
   - Performance
   - Tamanho do app
   - Acessibilidade 