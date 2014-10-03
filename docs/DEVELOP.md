# Reminders
Fuseki running?
Rails running?
Redis running?
Sidekiq running?

# New sidekiq worker
Create a new queue for each new sidekiq worker
Remeber to update rails3/config/sidekiq.yml otherwise jobs in the new queue won't process.