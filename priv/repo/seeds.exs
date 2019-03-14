# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaskTracker.Repo.insert!(%TaskTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias TaskTracker.Repo
alias TaskTracker.Users.User
alias TaskTracker.Tasks.Task
alias TaskTracker.TimeBlocks.TimeBlock

Repo.insert!(%User{email: "alice@example.com", admin: false})
Repo.insert!(%User{email: "bob@example.com", admin: true})
Repo.insert!(%User{email: "brian.vullo@gmail.com", admin: false, manager_id: 2})
Repo.insert!(%Task{completed: false, user_id: 1, title: "test"})
Repo.insert!(%TimeBlock{user_id: 1, task_id: 1, start_time: DateTime.truncate(DateTime.utc_now, :second)})
