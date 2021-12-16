create table user_sessions (
  user_session_id uuid primary key,
  session_id text not null,
  user_id uuid references users,
  created_at timestamptz not null,
);

create unique index on packages(user_session_id, session_id);
create index on user_sessions(user_id);
