-- Execute no SQL Editor do Supabase.
create table if not exists public.floor_models (
  id text primary key,
  model jsonb not null,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index if not exists floor_models_updated_at_idx on public.floor_models(updated_at);
alter table public.floor_models enable row level security;

-- Esta versão é um catálogo compartilhado: qualquer visitante pode ler e alterar
-- modelos personalizados. Para dados privados, substitua por Supabase Auth + user_id.
drop policy if exists "public read floor models" on public.floor_models;
drop policy if exists "public insert floor models" on public.floor_models;
drop policy if exists "public update floor models" on public.floor_models;
drop policy if exists "public delete floor models" on public.floor_models;
create policy "public read floor models" on public.floor_models for select to anon, authenticated using (true);
create policy "public insert floor models" on public.floor_models for insert to anon, authenticated with check (true);
create policy "public update floor models" on public.floor_models for update to anon, authenticated using (true) with check (true);
create policy "public delete floor models" on public.floor_models for delete to anon, authenticated using (true);

-- Permite que o PostgREST retorne a tabela após alterações.
grant select, insert, update, delete on public.floor_models to anon, authenticated;
