# Calculadora de Pisos — pacote para compartilhamento

Pacote da calculadora web atual, preservando a interface, o layout, os estilos, os componentes e as funcionalidades existentes. A persistência foi otimizada para manter uma cópia local e sincronizar os modelos personalizados com o Supabase.

## Requisitos

- Conta no GitHub;
- Conta na Vercel;
- Navegador moderno com JavaScript habilitado;
- Projeto Supabase com `supabase/schema.sql` executado uma vez.

A calculadora é estática e não exige Node.js. Os modelos personalizados são sincronizados com a nuvem; o armazenamento local continua como fallback para uso offline ou indisponibilidade temporária.

## Publicação

1. Execute `supabase/schema.sql` no SQL Editor do Supabase.
2. Envie o conteúdo deste pacote ao GitHub, mantendo `index.html` na raiz.
3. Importe o repositório na Vercel como projeto estático.
4. Não informe comando de build nem diretório de saída.
5. Publique e faça um cadastro de teste.
6. Abra a publicação em outro navegador ou dispositivo para confirmar a sincronização.

## Plano de implementação aplicado

- **Persistência local:** gravação imediata no `localStorage`, preservando o uso mesmo sem rede.
- **Sincronização em nuvem:** carregamento dos modelos remotos ao abrir e envio de cadastro, alteração e exclusão.
- **Resiliência:** fila local de operações pendentes, reenvio posterior, timeout de rede e mensagens de modo offline.
- **Conflitos:** cada alteração registra data; ao carregar, a versão remota mais recente é aplicada quando houver comparação disponível.
- **Segurança:** chave pública apenas no navegador, RLS habilitado, escrita limitada a modelos personalizados e nenhuma chave administrativa no front-end.
- **Compatibilidade:** uso de APIs disponíveis em navegadores modernos de desktop e celular, com fallback local quando a nuvem não puder ser acessada.

## Limite de segurança atual

Sem autenticação, o catálogo é compartilhado por todos os visitantes da publicação. Qualquer visitante pode consultar, alterar ou excluir modelos personalizados. Para dados privados ou múltiplas equipes, implemente Supabase Auth, associe cada modelo a um `owner_id` e substitua as políticas públicas por políticas baseadas no usuário autenticado.

## Checklist

- [ ] Executar `supabase/schema.sql`;
- [ ] Confirmar que a tabela `floor_models` existe;
- [ ] Testar cadastro, alteração e exclusão;
- [ ] Testar em dois navegadores ou dispositivos;
- [ ] Simular indisponibilidade da rede e confirmar o fallback local;
- [ ] Nunca publicar uma chave `service_role`;
- [ ] Revisar autenticação antes de usar dados privados.
