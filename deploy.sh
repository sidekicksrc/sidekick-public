main() {
  set -e
  check_deployable
  create_commit
  deploy
}
check_deployable() {
  diffs=`git diff --name-status HEAD | wc -l`
  if [[ $diffs != "0" ]]; then
    echo "Can't deploy, unsaved changes"
    exit 1
  fi
}

deploy() {
  rm -rf output
  compile
  create_commit
  git push origin deploy
}

most_recent_deploy() {
  git show-ref deploy | awk '{print $1}'
}

create_commit() {
  commit=`most_recent_deploy`
  added=`git add -f output`
  tree=`git write-tree --prefix output/`
  git reset
  parent_opt=""
  if [[ $commit != "" ]]; then
    parent_opt="-p $commit"
  fi
  new_commit=`git commit-tree $tree -m 'new version' $parent_opt`
  git update-ref deploy $new_commit
}

compile() {
  NANOC_ENV=production nanoc compile
}


main
