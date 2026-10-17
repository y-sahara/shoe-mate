-- shoe-mate データベーススキーマ
-- Supabase SQL Editor で実行する想定
-- 参照: ../../../01_design/data_model.md

-- shoes: シューズ
create table if not exists shoes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  brand text,
  model text,
  purchased_at date,
  started_at date,
  retirement_distance_km numeric not null default 500,
  status text not null default 'active' check (status in ('active', 'retired')),
  memo text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- shoe_photos: シューズ写真
create table if not exists shoe_photos (
  id uuid primary key default gen_random_uuid(),
  shoe_id uuid not null references shoes (id) on delete cascade,
  storage_path text not null,
  sort_order integer not null default 0,
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

-- usage_records: 使用記録
create table if not exists usage_records (
  id uuid primary key default gen_random_uuid(),
  shoe_id uuid not null references shoes (id) on delete cascade,
  recorded_at date not null,
  total_distance_km numeric not null,
  memo text,
  source text not null default 'manual' check (source in ('manual', 'api')),
  created_at timestamptz not null default now()
);

create index if not exists idx_shoes_user_id on shoes (user_id);
create index if not exists idx_shoe_photos_shoe_id on shoe_photos (shoe_id);
create index if not exists idx_usage_records_shoe_id on usage_records (shoe_id);

-- updated_at 自動更新
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_shoes_updated_at on shoes;
create trigger trg_shoes_updated_at
  before update on shoes
  for each row
  execute function set_updated_at();

-- RLS 有効化
alter table shoes enable row level security;
alter table shoe_photos enable row level security;
alter table usage_records enable row level security;

-- shoes: 自分の行のみ操作可能
create policy "shoes_select_own" on shoes
  for select using (auth.uid() = user_id);
create policy "shoes_insert_own" on shoes
  for insert with check (auth.uid() = user_id);
create policy "shoes_update_own" on shoes
  for update using (auth.uid() = user_id);
create policy "shoes_delete_own" on shoes
  for delete using (auth.uid() = user_id);

-- shoe_photos: 親 shoes の所有者のみ操作可能
create policy "shoe_photos_select_own" on shoe_photos
  for select using (
    exists (select 1 from shoes where shoes.id = shoe_photos.shoe_id and shoes.user_id = auth.uid())
  );
create policy "shoe_photos_insert_own" on shoe_photos
  for insert with check (
    exists (select 1 from shoes where shoes.id = shoe_photos.shoe_id and shoes.user_id = auth.uid())
  );
create policy "shoe_photos_update_own" on shoe_photos
  for update using (
    exists (select 1 from shoes where shoes.id = shoe_photos.shoe_id and shoes.user_id = auth.uid())
  );
create policy "shoe_photos_delete_own" on shoe_photos
  for delete using (
    exists (select 1 from shoes where shoes.id = shoe_photos.shoe_id and shoes.user_id = auth.uid())
  );

-- usage_records: 親 shoes の所有者のみ操作可能
create policy "usage_records_select_own" on usage_records
  for select using (
    exists (select 1 from shoes where shoes.id = usage_records.shoe_id and shoes.user_id = auth.uid())
  );
create policy "usage_records_insert_own" on usage_records
  for insert with check (
    exists (select 1 from shoes where shoes.id = usage_records.shoe_id and shoes.user_id = auth.uid())
  );
create policy "usage_records_update_own" on usage_records
  for update using (
    exists (select 1 from shoes where shoes.id = usage_records.shoe_id and shoes.user_id = auth.uid())
  );
create policy "usage_records_delete_own" on usage_records
  for delete using (
    exists (select 1 from shoes where shoes.id = usage_records.shoe_id and shoes.user_id = auth.uid())
  );
