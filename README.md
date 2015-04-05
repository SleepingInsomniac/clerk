```bash
bundle install
rake db:migrate
racksh
```
```ruby
User.create name: 'admin', password: 'adminpassword'
```
```bash
rackup -p 3000
```

Visit localhost:3000, and you're good to go!
(change `set :files_root, './files'` to where you want the file root)