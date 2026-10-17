-- shoe-photos バケットの RLS ポリシー
-- 事前に Supabase ダッシュボードの Storage で "shoe-photos" バケット（非公開）を作成しておくこと
--
-- 想定パス構造: {user_id}/{shoe_id}/{filename}
-- こうすることでパスの先頭セグメント（フォルダ名）を見るだけで所有者を判定できる

create policy "shoe_photos_storage_select_own"
  on storage.objects for select
  using (
    bucket_id = 'shoe-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "shoe_photos_storage_insert_own"
  on storage.objects for insert
  with check (
    bucket_id = 'shoe-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "shoe_photos_storage_update_own"
  on storage.objects for update
  using (
    bucket_id = 'shoe-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "shoe_photos_storage_delete_own"
  on storage.objects for delete
  using (
    bucket_id = 'shoe-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
