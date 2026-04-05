create table public.study_requests (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) not null,
  subject text not null,
  exam_date date not null,
  difficulty text default 'medium',
  status text default 'pending',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create table public.study_timetables (
  id uuid default gen_random_uuid() primary key,
  request_id uuid references public.study_requests(id) on delete cascade not null,
  user_id uuid references auth.users(id) not null,
  timetable_data jsonb not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table public.study_requests enable row level security;
alter table public.study_timetables enable row level security;

-- study_requests policies
create policy "Users can insert their own study requests"
  on public.study_requests for insert
  with check ( auth.uid() = user_id );

create policy "Users can view their own study requests"
  on public.study_requests for select
  using ( auth.uid() = user_id );

create policy "Admins can select all study requests"
  on public.study_requests for select
  using ( auth.jwt() ->> 'email' = 'msajeeshna@gmail.com' ); -- Update with config admin email

create policy "Admins can update all study requests"
  on public.study_requests for update
  using ( auth.jwt() ->> 'email' = 'msajeeshna@gmail.com' );

-- study_timetables policies
create policy "Users can view their own study timetables"
  on public.study_timetables for select
  using ( auth.uid() = user_id );

create policy "Admins can insert study timetables"
  on public.study_timetables for insert
  with check ( auth.jwt() ->> 'email' = 'msajeeshna@gmail.com' );

create policy "Admins can update study timetables"
  on public.study_timetables for update
  using ( auth.jwt() ->> 'email' = 'msajeeshna@gmail.com' );

create policy "Admins can select all study timetables"
  on public.study_timetables for select
  using ( auth.jwt() ->> 'email' = 'msajeeshna@gmail.com' );
