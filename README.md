```bash
bundle install
rake db:migrate
rackup -p 3000
```
Good to go!
(change set :root, './public/root' to where you want the file root)