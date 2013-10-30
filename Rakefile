

task :deploy do
  diffs = `git diff --name-status HEAD`
  unless diffs.split("\n").empty?
    puts "Can't deploy, unsaved changes:"
    puts diffs
  end
  %x(
  set -e
  rm -rf output
  mv vendor /tmp/sk-deploy-vendor
  git checkout gh-pages
  git reset --hard master
  DOMAIN=sidekicksrc.com BASE_URL='http://sidekicksrc.com' nanoc compile
  ls | grep -v output | grep -v tmp | while read file; do rm -rf $file; done 
  mv output/* .
  rm -rf output
  git add . -A
  git commit -m 'latest'
  git push --force public gh-pages
  git checkout master
  mv /tmp/sk-deploy-vendor vendor/
  )
end
