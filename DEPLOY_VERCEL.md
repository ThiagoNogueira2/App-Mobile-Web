# Deploy no Vercel - Guia de Configuração

## Arquivos Criados

✅ `vercel.json` - Configuração do Vercel
✅ `.github/workflows/deploy-vercel.yml` - Workflow automático de deploy

## Opção 1: Deploy Manual (Rápido)

### Pré-requisitos
1. Instale o Flutter SDK
2. Instale o Vercel CLI: `npm i -g vercel`

### Passos

1. **Compile o projeto:**
```bash
cd App-Mobile-Web
flutter pub get
flutter build web --release
```

2. **Faça login no Vercel:**
```bash
vercel login
```

3. **Faça o deploy:**
```bash
cd App-Mobile-Web
vercel --prod
```

## Opção 2: Deploy Automático via GitHub Actions

### Configuração Inicial

1. **Crie um projeto no Vercel:**
   - Acesse [vercel.com](https://vercel.com)
   - Crie um novo projeto
   - Anote o `Project ID` e `Org ID`

2. **Configure os Secrets no GitHub:**
   - Vá em: Repositório → Settings → Secrets and variables → Actions
   - Adicione os seguintes secrets:
     - `VERCEL_TOKEN`: Token do Vercel (crie em: Vercel Dashboard → Settings → Tokens)
     - `VERCEL_ORG_ID`: ID da organização do Vercel
     - `VERCEL_PROJECT_ID`: ID do projeto do Vercel

3. **Faça push para o repositório:**
   - O workflow será executado automaticamente ao fazer push para `main` ou `master`
   - Ou execute manualmente em: Actions → Build and Deploy to Vercel → Run workflow

## Estrutura de Arquivos

```
App-Mobile-Web/
├── vercel.json              # Configuração do Vercel
├── build/web/               # Output do build (gerado automaticamente)
└── ...

.github/
└── workflows/
    └── deploy-vercel.yml    # Workflow de deploy automático
```

## Notas Importantes

- O diretório `build/` está no `.gitignore` e não será commitado
- O Vercel servirá os arquivos estáticos de `build/web/`
- Todas as rotas são redirecionadas para `index.html` (SPA)
- Assets estáticos têm cache de 1 ano configurado

## Troubleshooting

### Erro: "Flutter not found"
- Certifique-se de ter o Flutter instalado e no PATH
- Execute `flutter doctor` para verificar

### Erro: "Build directory not found"
- Execute `flutter build web --release` primeiro
- Verifique se o diretório `build/web` foi criado

### Erro no GitHub Actions
- Verifique se todos os secrets estão configurados corretamente
- Verifique os logs do workflow em Actions → Workflow runs
