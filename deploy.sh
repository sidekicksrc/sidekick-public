main() {
  set -e
  check_deployable
  deploy
}
check_deployable() {
  diffs=`git diff --name-status HEAD | wc -l`
  if [[ $diffs != "0" ]]; then
    echo "Can't deploy, unsaved changes:"
    git diff --name-status HEAD
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
  `git show-ref deploy-staging | awk '{print $2}'`
}

create_commit() {
  commit=most_recent_deploy
  git add -f output
  tree=`git write-tree --prefix output/`
  parent_opt=""
  if [[ $commit != "" ]]; then
    parent_opt="-p $commit"
  fi
  new_commit=git commit-tree $tree -m 'new version' $parent_opt
  git update-ref deploy $new_commit
}

checkout_clean_branch() {
  # deploy-staging is an orphan branch, only history on it is deployed versions
  git checkout deploy-staging
}

compile() {
  NANOC_ENV=production nanoc compile
}


main
