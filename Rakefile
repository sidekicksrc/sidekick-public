

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
  git checkout deploy
  git reset master
  NANOC_ENV=production nanoc compile
  ls | grep -v output | grep -v tmp | while read file; do rm -rf $file; done 
  mv output/* .
  rm -rf output
  git add . -A
  git commit -m 'latest'
  mv /tmp/sk-deploy-vendor vendor/
  )
end
