# FirmaFloor — calculadora sincronizada

Aplicação web estática para calcular materiais de piso e cadastrar modelos personalizados. O cálculo continua funcionando offline; modelos personalizados são mantidos no navegador e sincronizados com o Supabase quando houver conexão.

## Publicação rápida

1. No Supabase, abra **SQL Editor** e execute `supabase-pdv.sql`.
2. Publique esta pasta em um repositório do GitHub.
3. Na Vercel, importe o repositório e use as configurações padrão para projeto estático.
4. Abra o domínio publicado em dois navegadores e cadastre um modelo para confirmar a sincronização.

Não use a chave `service_role` no navegador. A chave `sb_publishable_...` é própria para cliente público; a proteção real é feita pelas políticas RLS do Supabase.

## Arquivos

- `index.html`: aplicação e interface responsiva.
- `config.js`: URL e chave pública do Supabase.
- `supabase-pdv.sql`: tabela, índice, RLS e permissões.
- `vercel.json`: cabeçalhos básicos de segurança e URLs limpas.
- `.env.example`: referência de configuração para automações futuras.

## Formatos de entrada e saída

- Entrada: modelo, fabricante, dimensões, unidades por pacote, área por pacote em m² e opção de manta.
- Entrada de cálculo: área útil em m², com ponto ou vírgula conforme o navegador.
- Saída: unidades/caixas de piso, rodapé, manta, PU e materiais complementares; valores exibidos com duas casas decimais.
- Persistência: registros JSON na coluna `model` e timestamps ISO-8601 em `updated_at`.

## Roadmap técnico

### Fase 1 — fundação (concluída)
- Interface responsiva e cálculo local.
- `localStorage` para continuidade após reinicialização.
- Fila de sincronização para indisponibilidade temporária de rede.
- Supabase REST para carregar, inserir, atualizar e excluir modelos.
- Configuração compatível com GitHub e Vercel.

### Fase 2 — banco e publicação
- Executar o SQL e confirmar as políticas RLS.
- Fazer deploy pela Vercel a partir do GitHub.
- Validar domínio HTTPS, cache e carregamento de `config.js`.

### Fase 3 — testes de aceitação
- Cadastrar modelo no navegador A e recarregar no navegador B.
- Editar e excluir em dispositivos diferentes.
- Desconectar a rede, cadastrar, reconectar e conferir a fila.
- Testar Safari, Chrome, Firefox e tela móvel.
- Conferir mensagens de erro quando o Supabase estiver indisponível.

### Fase 4 — segurança e evolução recomendada
A política atual cria um catálogo compartilhado e público. Se os modelos precisarem ser privados por cliente, adicionar Supabase Auth, `user_id` na tabela e políticas RLS baseadas em `auth.uid()`; nesse cenário também será possível compartilhar por convite ou link com permissão controlada.

### Fase 5 — qualidade operacional
- Adicionar validação de schema para o JSON do modelo.
- Registrar auditoria de alterações.
- Criar testes automatizados para arredondamento, perda de 10% e materiais extras.
- Monitorar falhas de sincronização e limitar tamanho/quantidade de registros.
- Versionar migrações SQL em vez de editar a tabela manualmente.

## Desafios e soluções

- **Navegador diferente:** `localStorage` é isolado por navegador; por isso o Supabase é a fonte compartilhada e o armazenamento local atua como cache/offline.
- **Queda de conexão:** alterações entram em fila local e são reenviadas ao voltar a conexão.
- **Conflito de edição:** a versão atual usa `updated_at` e aplica o registro remoto mais recente; para colaboração crítica, evoluir para controle otimista por versão.
- **Exposição da chave pública:** é esperada no frontend, mas nunca deve ser substituída pela `service_role`; RLS deve permanecer habilitado.
- **Concorrência:** o upsert usa o `id` do modelo e `Prefer: resolution=merge-duplicates`; a política de versão pode ser fortalecida na próxima fase.
